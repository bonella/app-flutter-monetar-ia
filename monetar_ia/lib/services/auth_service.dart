// lib/services/auth_service.dart

import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final String _baseUrl = 'https://testeapi.monetaria.app.br';

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
      return response;
    } else if (response.statusCode == 401) {
      throw Exception('E-mail ou senha incorretos');
    } else {
      throw Exception('Erro ao fazer login: ${response.body}');
    }
  }

  // Função para obter informações do usuário
  Future<Map<String, dynamic>> getUser() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/protected'),
      headers: {
        'Authorization': 'Bearer YOUR_ACCESS_TOKEN',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Falha ao carregar informações do usuário');
    }
  }
}
