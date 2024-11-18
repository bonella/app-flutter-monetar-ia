import 'package:http/http.dart' as http;
import 'package:monetar_ia/services/auth_service.dart';
import 'dart:convert';
import 'token_storage.dart';
import '../models/goal.dart';
import '../models/transaction.dart';
import '../models/category.dart';

class RequestHttp {
  final String _baseUrl = 'https://api.monetaria.app.br';
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
      "Authorization": "bearer $token",
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

    return _handleResponse(response);
  }

  Future<int?> getUserId() async {
    final response = await get('me');
    if (response.statusCode == 200) {
      final userData = json.decode(response.body);
      return userData['id'];
    } else {
      print('Erro ao obter informações do usuário: ${response.statusCode}');
      return null;
    }
  }

  Future<String?> getUserName() async {
    final response = await get('me');
    if (response.statusCode == 200) {
      final userData = json.decode(response.body);
      return userData['name'];
    } else {
      print('Erro ao obter informações do usuário: ${response.statusCode}');
      return null;
    }
  }

  Future<double> getTotalReceitas(String mes) async {
    final response = await get('transactions/total_receitas?mes=$mes');
    if (response.statusCode == 200) {
      final totalData = json.decode(response.body);
      return totalData['total']?.toDouble() ?? 0.0;
    } else {
      throw Exception(
          'Erro ao obter total de receitas: ${response.statusCode}');
    }
  }

  // Método para obter e filtrar despesas por mês
  Future<double> getTotalExpensesByMonth(String mes) async {
    final response = await get('transactions/expenses');
    if (response.statusCode == 200) {
      final List<dynamic> despesas = json.decode(response.body);
      double total = 0.0;

      // Filtra e soma os valores das despesas do mês especificado
      for (var despesa in despesas) {
        String dataDespesa = despesa['data'];
        if (dataDespesa.contains(mes)) {
          total += despesa['valor']?.toDouble() ?? 0.0;
        }
      }

      return total;
    } else {
      throw Exception(
          'Erro ao obter total de despesas: ${response.statusCode}');
    }
  }

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
    }
    throw Exception('Erro na requisição: ${response.body}');
  }

  // CRUD para metas
  Future<http.Response> createGoal(Map<String, dynamic> goalData) async {
    return await post('goals/create', goalData);
  }

  Future<List<Goal>> getGoals() async {
    final response = await get('goals/');
    return parseGoals(response.body);
  }

  List<Goal> parseGoals(String responseBody) {
    final List<dynamic> parsed = json.decode(responseBody);
    return parsed.map<Goal>((json) => Goal.fromJson(json)).toList();
  }

  Future<http.Response> updateGoal(
      int goalId, Map<String, dynamic> goalData) async {
    return await put('goals/$goalId', goalData);
  }

  Future<http.Response> deleteGoal(int goalId) async {
    return await delete('goals/$goalId');
  }

  // CRUD para transações
  Future<http.Response> createTransaction(
      Map<String, dynamic> transactionData) async {
    return await post('transactions/create', transactionData);
  }

  Future<List<Transaction>> getTransactions() async {
    final response = await get('transactions/');
    return parseTransactions(response.body);
  }

  List<Transaction> parseTransactions(String responseBody) {
    final List<dynamic> parsed = json.decode(responseBody);
    return parsed
        .map<Transaction>((json) => Transaction.fromJson(json))
        .toList();
  }

  Future<http.Response> updateTransaction(
      int transactionId, Map<String, dynamic> transactionData) async {
    return await put('transactions/$transactionId', transactionData);
  }

  Future<http.Response> deleteTransaction(int transactionId) async {
    return await delete('transactions/$transactionId');
  }

  // CRUD para categorias
  Future<List<Category>> getCategories({int skip = 0, int limit = 10}) async {
    final response = await get('categories?skip=$skip&limit=$limit');
    final decodedBody = utf8.decode(response.bodyBytes);
    return parseCategories(decodedBody);
  }

  List<Category> parseCategories(String responseBody) {
    final List<dynamic> parsed = json.decode(responseBody);
    return parsed.map<Category>((json) => Category.fromJson(json)).toList();
  }

  Future<http.Response> createCategory(Category category) async {
    // Obtém o ID do usuário
    final userId = await getUserId();
    if (userId == null) {
      throw Exception('Não foi possível obter o ID do usuário.');
    }

    // Prepara os dados para a criação da categoria
    final Map<String, dynamic> categoryData = {
      "name": category.name,
      "type": category.type,
      "user_id": userId,
    };

    // Faz a requisição POST para criar a categoria
    final response = await post('categories/create', categoryData);

    // Verifica se a criação foi bem-sucedida
    if (response.statusCode == 201) {
      print('Categoria criada com sucesso');
      return response;
    } else {
      print('Erro ao criar categoria: ${response.statusCode}');
      throw Exception('Erro ao criar categoria: ${response.body}');
    }
  }

  Future<http.Response> updateCategory(
      int categoryId, Category category) async {
    return await put('categories/$categoryId', category.toJson());
  }

  Future<http.Response> deleteCategory(int categoryId) async {
    return await delete('categories/$categoryId');
  }

  // Método para integrar o chat com IA
  Future<http.Response> chatWithAI(String texto) async {
    final token = await AuthService().getAuthToken();

    final url = '$_baseUrl/chat/ia/$texto';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'bearer $token',
        'Accept': 'application/json',
      },
    );

    return _handleResponse(response);
  }

  // Método para validar o código de redefinição de senha
  Future<http.Response> validateResetCode(String email, int resetCode) async {
    final url = Uri.parse('https://api.monetaria.app.br/validate-reset-code');

    final body = jsonEncode({
      "email": email,
      "reset_code": resetCode,
    });

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception(
          jsonDecode(response.body)['detail'] ?? 'Erro desconhecido');
    }
  }

  // Método para gerar e enviar um código de redefinição de senha sem autenticação
  Future<http.Response> requestPasswordResetCode(String email) async {
    Map<String, dynamic> data = {
      "email": email,
    };

    final uri = Uri.parse('https://api.monetaria.app.br/password-reset-code');
    return await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );
  }

  // Método para redefinir a senha usando o endpoint '/new-password'
  Future<http.Response> changePassword(String email, String newPassword) async {
    Map<String, dynamic> data = {
      "email": email,
      "new_password": newPassword,
    };

    final url = Uri.parse('https://api.monetaria.app.br/new-password');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception(
          jsonDecode(response.body)['detail'] ?? 'Erro desconhecido');
    }
  }

  // Método para atualizar o usuário autenticado (nome e/ou sobrenome)
  Future<http.Response> updateUser({String? name, String? lastName}) async {
    Map<String, dynamic> userUpdateData = {};

    if (name != null && name.isNotEmpty) {
      userUpdateData['name'] = name;
    }
    if (lastName != null && lastName.isNotEmpty) {
      userUpdateData['last_name'] = lastName;
    }

    if (userUpdateData.isEmpty) {
      throw Exception('Nenhum campo para atualizar foi fornecido.');
    }

    final response = await put('users/update', userUpdateData);

    if (response.statusCode == 200) {
      print('Usuário atualizado com sucesso.');
      return response;
    } else if (response.statusCode == 404) {
      throw Exception('Usuário não encontrado.');
    } else if (response.statusCode == 422) {
      final errorDetails = jsonDecode(response.body)['detail'];
      throw Exception('Erro de validação: $errorDetails');
    } else {
      throw Exception('Erro ao atualizar usuário: ${response.body}');
    }
  }
}
