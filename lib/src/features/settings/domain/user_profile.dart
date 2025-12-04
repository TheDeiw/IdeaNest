import 'package:cloud_firestore/cloud_firestore.dart';

/// UserProfile model representing user settings and information
class UserProfile {
  final String userId;
  final String displayName;
  final String email;
  final String? photoURL;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.userId,
    required this.displayName,
    required this.email,
    this.photoURL,
    required this.createdAt,
    required this.updatedAt,
  });

  UserProfile copyWith({
    String? userId,
    String? displayName,
    String? email,
    String? photoURL,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoURL: photoURL ?? this.photoURL,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Convert UserProfile to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'displayName': displayName,
      'email': email,
      'photoURL': photoURL,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Create UserProfile from Firestore document
  factory UserProfile.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return UserProfile(
      userId: doc.id,
      displayName: data['displayName'] as String? ?? 'User',
      email: data['email'] as String? ?? '',
      photoURL: data['photoURL'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Create UserProfile from JSON
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['userId'] as String,
      displayName: json['displayName'] as String? ?? 'User',
      email: json['email'] as String? ?? '',
      photoURL: json['photoURL'] as String?,
      createdAt: json['createdAt'] is DateTime
          ? json['createdAt']
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] is DateTime
          ? json['updatedAt']
          : DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Convert UserProfile to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'displayName': displayName,
      'email': email,
      'photoURL': photoURL,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserProfile &&
        other.userId == userId &&
        other.displayName == displayName &&
        other.email == email;
  }

  @override
  int get hashCode {
    return Object.hash(userId, displayName, email);
  }

  @override
  String toString() {
    return 'UserProfile(userId: $userId, displayName: $displayName, email: $email)';
  }
}

