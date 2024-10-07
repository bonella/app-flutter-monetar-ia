class Goal {
  final int id;
  final int userId;
  final String name;
  final String targetAmount; // Mantido como String de acordo com a API
  final String currentAmount; // Mantido como String de acordo com a API
  final String description;
  final DateTime
      deadline; // Usando DateTime para facilitar a manipulação de datas
  final DateTime
      createdAt; // Usando DateTime para facilitar a manipulação de datas
  final DateTime
      updatedAt; // Usando DateTime para facilitar a manipulação de datas

  Goal({
    required this.id,
    required this.userId,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    required this.description,
    required this.deadline,
    required this.createdAt,
    required this.updatedAt,
  });

  // Método para criar uma instância de Goal a partir de um mapa (JSON)
  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      targetAmount: json['target_amount'],
      currentAmount: json['current_amount'],
      description: json['description'],
      deadline: DateTime.parse(json['deadline']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
