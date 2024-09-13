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
        "username": email,
        "password": password,
        "salary": 0,
      }),
    );
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Erro ao criar usuário: ${response.body}');
    }
  }
}
