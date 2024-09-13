import 'package:http/http.dart' as http;
import 'dart:convert';

class RequestHttp {
  final String _baseUrl = 'https://testeapi.monetaria.app.br';

  Future<http.Response> get(String endpoint) async {
    final url = Uri.parse('$_baseUrl/$endpoint');
    final response = await http.get(url);
    return _handleResponse(response);
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$_baseUrl/$endpoint');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  Future<http.Response> put(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$_baseUrl/$endpoint');
    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  Future<http.Response> delete(String endpoint) async {
    final url = Uri.parse('$_baseUrl/$endpoint');
    final response = await http.delete(url);
    return _handleResponse(response);
  }

  http.Response _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Erro: ${response.statusCode} - ${response.body}');
    }
  }
}
