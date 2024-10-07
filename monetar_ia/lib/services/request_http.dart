import 'package:http/http.dart' as http;
import 'dart:convert';
import 'token_storage.dart';
import '../models/goal.dart'; // Importe a classe Goal

class RequestHttp {
  final String _baseUrl = 'https://testeapi.monetaria.app.br';
  final TokenStorage _tokenStorage = TokenStorage();

  Future<http.Response> _requestWithToken(String method, String endpoint,
      [Map<String, dynamic>? data]) async {
    final token = await _tokenStorage.getToken();
    print('Token recuperado WitjToken: $token');

    if (token == null) {
      throw Exception('Token não encontrado. Faça login novamente.');
    }

    final url = Uri.parse('$_baseUrl/$endpoint');
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    http.Response response;

    switch (method) {
      case 'GET':
        response = await http.get(url, headers: headers);
        break;
      case 'POST':
        response =
            await http.post(url, headers: headers, body: json.encode(data));
        break;
      case 'PUT':
        response =
            await http.put(url, headers: headers, body: json.encode(data));
        break;
      case 'DELETE':
        response = await http.delete(url, headers: headers);
        break;
      default:
        throw Exception('Método HTTP inválido.');
    }

    print('Requisição para $url');
    print('Status da resposta: ${response.statusCode}');
    print('Corpo da resposta: ${response.body}');

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
    } else if (response.statusCode == 401) {
      // Lógica para lidar com token expirado ou inválido
      print("Token expirado ou inválido. Redirecionando para login...");
      // Aqui você pode adicionar lógica para lidar com o logout, se necessário
    }
    throw Exception('Erro na requisição: ${response.body}');
  }

  // CRUD para metas

  // Criar uma nova meta
  Future<http.Response> createGoal(Map<String, dynamic> goalData) async {
    return await post('goals/create', goalData);
  }

  // Obter todas as metas (retorna uma lista de Goal)
  Future<List<Goal>> getGoals() async {
    final response = await get('goals'); // Obtém a resposta da API
    return parseGoals(
        response.body); // Converte a resposta em uma lista de Goals
  }

  // Método para converter o JSON da resposta em uma lista de Goals
  List<Goal> parseGoals(String responseBody) {
    final List<dynamic> parsed = json.decode(responseBody);
    return parsed.map<Goal>((json) => Goal.fromJson(json)).toList();
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
