// lib/models/category.dart

class Category {
  final int id;
  final String name;
  final String type; // "INCOME" ou "EXPENSE"
  final int? userId;

  Category({
    required this.id,
    required this.name,
    required this.type,
    this.userId,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'user_id': userId,
    };
  }
}
