import 'package:http/http.dart' as http;
import 'dart:convert';
import 'token_storage.dart';

class RequestHttp {
  final String _baseUrl = 'https://testeapi.monetaria.app.br';
  final TokenStorage _tokenStorage = TokenStorage();

  Future<http.Response> _requestWithToken(String method, String endpoint,
      [Map<String, dynamic>? data]) async {
    final token = await _tokenStorage.getToken();

    if (token == null) {
      throw Exception('Token não encontrado. Faça login novamente.');
    }

    final url = Uri.parse('$_baseUrl/$endpoint');
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    http.Response response;

    if (method == 'GET') {
      response = await http.get(url, headers: headers);
    } else if (method == 'POST') {
      response =
          await http.post(url, headers: headers, body: json.encode(data));
    } else if (method == 'PUT') {
      response = await http.put(url, headers: headers, body: json.encode(data));
    } else if (method == 'DELETE') {
      response = await http.delete(url, headers: headers);
    } else {
      throw Exception('Método HTTP inválido.');
    }

    return _handleResponse(response);
  }

  // Métodos HTTP públicos
  Future<http.Response> get(String endpoint) async {
    return await _requestWithToken('GET', endpoint);
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> data) async {
    return await _requestWithToken('POST', endpoint, data);
  }

  Future<http.Response> put(String endpoint, Map<String, dynamic> data) async {
    return await _requestWithToken('PUT', endpoint, data);
  }

  Future<http.Response> delete(String endpoint) async {
    return await _requestWithToken('DELETE', endpoint);
  }

  http.Response _handleResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response;
    } else {
      throw Exception('Erro na requisição: ${response.body}');
    }
  }

  // CRUD para metas

  // Criar uma nova meta
  Future<http.Response> createGoal(Map<String, dynamic> goalData) async {
    return await post('goals/create', goalData);
  }

  // Obter todas as metas (ou uma meta específica, se necessário)
  Future<http.Response> getGoals() async {
    return await get('goals');
  }

  // Atualizar uma meta existente
  Future<http.Response> updateGoal(
      int goalId, Map<String, dynamic> goalData) async {
    return await put('goals/$goalId', goalData);
  }

  // Excluir uma meta
  Future<http.Response> deleteGoal(int goalId) async {
    return await delete('goals/$goalId');
  }
}
