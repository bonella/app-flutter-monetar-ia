import 'package:http/http.dart' as http;
import 'dart:convert';
import 'token_storage.dart';

class AuthService {
  final String _baseUrl = 'https://api.monetaria.app.br';
  final TokenStorage _tokenStorage = TokenStorage();

  Future<http.Response> signup({
    required String name,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final url = Uri.parse('$_baseUrl/signup');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "name": name,
        "last_name": lastName,
        "email": email,
        "password": password,
        "salary": 0,
      }),
    );

    if (response.statusCode == 200) {
      return response;
    } else if (response.statusCode == 422) {
      throw Exception('Usuário já existe');
    } else {
      throw Exception('Erro ao criar usuário: ${response.body}');
    }
  }

  Future<http.Response> signin({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$_baseUrl/signin');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      String token = responseBody['access_token'];
      print('Token recebido Auth: $token');

      await _tokenStorage.saveToken(token);
      return response;
    } else if (response.statusCode == 401) {
      throw Exception('E-mail ou senha incorretos');
    } else {
      throw Exception('Erro ao fazer login: ${response.body}');
    }
  }

  Future<void> updateUserProfile(
    String name,
    String lastName,
    String currentPassword,
    String newPassword,
  ) async {
    final url =
        Uri.parse('$_baseUrl/update_profile'); // Altere para o endpoint correto

    final token = await _tokenStorage.getToken();

    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        "name": name,
        "last_name": lastName,
        "current_password": currentPassword,
        "new_password": newPassword,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar perfil: ${response.body}');
    }
  }

  // Função para obter informações do usuário
  Future<Map<String, dynamic>?> getUser() async {
    final token = await _tokenStorage.getToken();
    final response = await http.get(
      Uri.parse('$_baseUrl/protected'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Falha ao carregar informações do usuário');
    }
  }

  // Função para pegar o id do usuário
  Future<int> getUserId() async {
    try {
      final user = await getUser();
      if (user != null && user['userId'] != null) {
        return user['userId']; // Retorna o user_id se encontrado
      } else {
        print('User not found or user_id is null');
        return -1; // Retorna -1 se não encontrar o ID
      }
    } catch (error) {
      print('Error fetching user ID: $error');
      return -1; // Retorna -1 em caso de erro
    }
  }

  // Função para verificar a validade do token usando o endpoint /me
  Future<bool> isTokenValid() async {
    final token = await _tokenStorage.getToken();

    if (token == null) return false;

    final response = await http.get(
      Uri.parse('$_baseUrl/me'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    return response.statusCode == 200;
  }

  Future<String?> getAuthToken() async {
    // Método que retorna o token de autenticação, se disponível
    return await _tokenStorage.getToken();
  }
}
