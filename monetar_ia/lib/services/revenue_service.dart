// lib/services/revenue_service.dart
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:monetar_ia/models/category.dart';
import 'package:monetar_ia/models/transaction.dart';
import 'package:monetar_ia/services/request_http.dart';
import 'package:monetar_ia/services/token_storage.dart';

class RevenueService {
  final RequestHttp _requestHttp = RequestHttp();
  final TokenStorage _tokenStorage = TokenStorage();

  Future<List<Category>> loadCategories(DateTime selectedDate) async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

    try {
      var response = await _requestHttp.get('categories?date=$formattedDate');

      if (response.statusCode == 200) {
        var decodedResponse = utf8.decode(response.bodyBytes);
        return (json.decode(decodedResponse) as List)
            .map((category) => Category.fromJson(category))
            .toList();
      } else {
        throw Exception('Falha ao carregar categorias: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao carregar categorias: $e');
    }
  }

  Future<List<Transaction>> loadRevenues(DateTime selectedDate) async {
    String formattedDate = DateFormat('yyyy-MM').format(selectedDate);
    List<Transaction> revenues = [];

    if (await _tokenStorage.isTokenValid()) {
      var response =
          await _requestHttp.get('transactions/revenues?date=$formattedDate');

      if (response.statusCode == 200) {
        revenues = (json.decode(response.body) as List)
            .map((revenue) => Transaction.fromJson(revenue))
            .toList();
        revenues.sort((a, b) => b.transactionDate.compareTo(a.transactionDate));
      } else {
        throw Exception('Erro ao carregar receitas: ${response.statusCode}');
      }
    } else {
      throw Exception("Token não está disponível. Faça login novamente.");
    }

    return revenues;
  }

  Future<void> deleteTransaction(String transactionId) async {
    try {
      var response = await _requestHttp.delete('transactions/$transactionId');
      if (response.statusCode != 200) {
        throw Exception('Erro ao excluir a transação: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao excluir a transação: $e');
    }
  }

  // ... (outros métodos conforme necessário)
}
