import 'package:cloud_firestore/cloud_firestore.dart';

/// Note model representing a user's note
class Note {
  final String id;
  final String title;
  final String content;
  final List<String> tagIds;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPinned;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.tagIds,
    required this.createdAt,
    required this.updatedAt,
    this.isPinned = false,
  });

  Note copyWith({
    String? id,
    String? title,
    String? content,
    List<String>? tagIds,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPinned,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      tagIds: tagIds ?? this.tagIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPinned: isPinned ?? this.isPinned,
    );
  }

  /// Convert Note to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'content': content,
      'tagIds': tagIds,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isPinned': isPinned,
    };
  }

  /// Create Note from Firestore document
  factory Note.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Note(
      id: doc.id,
      title: data['title'] as String? ?? '',
      content: data['content'] as String? ?? '',
      tagIds: List<String>.from(data['tagIds'] as List? ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Create Note from JSON (for local storage or testing)
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      tagIds: List<String>.from(json['tagIds'] as List? ?? []),
      createdAt: json['createdAt'] is DateTime
          ? json['createdAt']
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] is DateTime
          ? json['updatedAt']
          : DateTime.parse(json['updatedAt'] as String),
      isPinned: json['isPinned'] as bool? ?? false,
    );
  }

  /// Convert Note to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'tagIds': tagIds,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isPinned': isPinned,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Note &&
        other.id == id &&
        other.title == title &&
        other.content == content &&
        other.tagIds.toString() == tagIds.toString() &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      title,
      content,
      tagIds,
      createdAt,
      updatedAt,
    );
  }

  @override
  String toString() {
    return 'Note(id: $id, title: $title, tagIds: $tagIds)';
  }
}

