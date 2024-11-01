import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TokenStorage {
  final String _baseUrl = 'https://testeapi.monetaria.app.br';

  // Salva o token
  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Obtém o token
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Limpa o token
  Future<void> clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // Verifica se o token é válido utilizando a rota /me
  Future<bool> isTokenValid() async {
    final token = await getToken();
    if (token == null || token.isEmpty) return false;

    final url = Uri.parse('$_baseUrl/me');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    return response.statusCode == 200;
  }
}
