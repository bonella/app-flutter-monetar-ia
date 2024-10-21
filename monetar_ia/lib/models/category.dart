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
  }) {
    if (type != 'INCOME' && type != 'EXPENSE') {
      throw ArgumentError('Invalid category type: $type');
    }
  }

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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Category &&
        other.id == id &&
        other.name == name &&
        other.type == type &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        type.hashCode ^
        (userId?.hashCode ?? 0);
  }
}
