import 'package:cloud_firestore/cloud_firestore.dart';

// Tag model
class Tag {
  final String id;
  final String name;
  final int color;

  Tag({
    required this.id,
    required this.name,
    required this.color,
  });

  Tag copyWith({
    String? id,
    String? name,
    int? color,
  }) {
    return Tag(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
    );
  }

  /// Convert Tag to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'color': color,
    };
  }

  /// Create Tag from Firestore document
  factory Tag.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Tag(
      id: doc.id,
      name: data['name'] as String,
      color: data['color'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color,
    };
  }

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'] as String,
      name: json['name'] as String,
      color: json['color'] as int,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Tag &&
      other.id == id &&
      other.name == name &&
      other.color == color;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ color.hashCode;
}

