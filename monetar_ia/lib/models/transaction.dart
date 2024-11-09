import 'package:intl/intl.dart';

class Transaction {
  final int id;
  final int userId;
  final double amount;
  final String type; // Pode ser "INCOME" ou "EXPENSE"
  final int categoryId;
  final String? description;
  final DateTime transactionDate;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Transaction({
    required this.id,
    required this.userId,
    required this.amount,
    required this.type,
    required this.categoryId,
    this.description,
    required this.transactionDate,
    required this.createdAt,
    this.updatedAt,
  });

  // Getter para formatar a data da transação
  String get formattedTransactionDate {
    return DateFormat('dd/MM/yyyy').format(transactionDate);
  }

  // Método para formatar o tipo
  String get formattedType {
    switch (type) {
      case 'INCOME':
        return 'Receitas';
      case 'EXPENSE':
        return 'Despesas';
      default:
        return type; // Retorna como está se não houver mapeamento
    }
  }

  // Método para formatar o amount como String
  String get formattedAmount {
    return NumberFormat.simpleCurrency()
        .format(amount); // Formatação como moeda
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      userId: json['user_id'],
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      type: json['type'],
      categoryId: json['category_id'],
      description: json['description'],
      transactionDate: DateTime.parse(json['transaction_date']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  // Método para converter a instância para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'amount': amount,
      'type': type,
      'category_id': categoryId,
      'description': description,
      'transaction_date': transactionDate.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
