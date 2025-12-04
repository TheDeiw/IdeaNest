import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ideanest/src/features/tags/domain/tag.dart';

/// Repository for managing tags in Firestore
class TagsRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  TagsRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  /// Get reference to user's tags collection
  CollectionReference<Map<String, dynamic>> _getTagsCollection() {
    final userId = _auth.currentUser?.uid;
    print('🏷️ TagsRepository: Getting tags collection for user: $userId');
    if (userId == null) {
      print('❌ TagsRepository: User not authenticated!');
      throw Exception('User not authenticated');
    }
    print('✅ TagsRepository: User authenticated, accessing: users/$userId/tags');
    return _firestore.collection('users').doc(userId).collection('tags');
  }

  /// Stream of all tags for the current user
  Stream<List<Tag>> watchTags() {
    return _getTagsCollection()
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Tag.fromFirestore(doc))
            .toList());
  }

  /// Get all tags (one-time fetch)
  Future<List<Tag>> getTags() async {
    final snapshot = await _getTagsCollection().get();
    return snapshot.docs.map((doc) => Tag.fromFirestore(doc)).toList();
  }

  /// Get a single tag by ID
  Future<Tag?> getTag(String tagId) async {
    final doc = await _getTagsCollection().doc(tagId).get();
    return doc.exists ? Tag.fromFirestore(doc) : null;
  }

  /// Create a new tag
  Future<Tag> createTag({
    required String name,
    required int color,
  }) async {
    final docRef = _getTagsCollection().doc();

    final tag = Tag(
      id: docRef.id,
      name: name,
      color: color,
    );

    await docRef.set(tag.toFirestore());
    return tag;
  }

  /// Update an existing tag
  Future<void> updateTag(Tag tag) async {
    await _getTagsCollection()
        .doc(tag.id)
        .update({
          'name': tag.name,
          'color': tag.color,
        });
  }

  /// Delete a tag
  Future<void> deleteTag(String tagId) async {
    await _getTagsCollection().doc(tagId).delete();
  }

  /// Find tag by name (case-insensitive)
  Future<Tag?> findTagByName(String name) async {
    final allTags = await getTags();
    final lowerName = name.toLowerCase();

    try {
      return allTags.firstWhere(
        (tag) => tag.name.toLowerCase() == lowerName,
      );
    } catch (_) {
      return null;
    }
  }

  /// Search tags by query
  Future<List<Tag>> searchTags(String query) async {
    if (query.isEmpty) {
      return getTags();
    }

    // Firestore doesn't support text search, so we fetch all and filter locally
    final allTags = await getTags();
    final lowerQuery = query.toLowerCase();

    return allTags.where((tag) =>
      tag.name.toLowerCase().contains(lowerQuery)
    ).toList();
  }


  /// Check if user has any tags
  Future<bool> hasAnyTags() async {
    final snapshot = await _getTagsCollection().limit(1).get();
    return snapshot.docs.isNotEmpty;
  }
}

