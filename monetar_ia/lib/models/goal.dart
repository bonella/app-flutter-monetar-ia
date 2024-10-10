import 'package:intl/intl.dart';

class Goal {
  final int id;
  final int userId;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final String? description;
  final DateTime deadline;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Goal({
    required this.id,
    required this.userId,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    this.description,
    required this.deadline,
    required this.createdAt,
    this.updatedAt,
  });

  // Getter para calcular a porcentagem de progresso
  String get percentage {
    if (targetAmount == 0) {
      return '0';
    }
    double progress = (currentAmount / targetAmount) * 100;
    return progress.toStringAsFixed(1);
  }

  // Getter para formatar a data de criação
  String get creationDate {
    return DateFormat('dd/MM/yyyy').format(createdAt);
  }

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      targetAmount: double.parse(json['target_amount']),
      currentAmount: double.parse(json['current_amount']),
      description: json['description'],
      deadline: DateTime.parse(json['deadline']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }
}
