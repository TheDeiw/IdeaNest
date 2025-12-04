import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ideanest/src/features/settings/domain/user_profile.dart';

/// Repository for managing user profile in Firestore
class UserProfileRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  UserProfileRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  /// Get reference to users collection
  DocumentReference<Map<String, dynamic>> _getUserDocument() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not authenticated');
    }
    return _firestore.collection('users').doc(userId);
  }

  /// Stream of current user's profile
  Stream<UserProfile?> watchUserProfile() {
    return _getUserDocument()
        .snapshots()
        .map((doc) => doc.exists ? UserProfile.fromFirestore(doc) : null);
  }

  /// Get user profile (one-time fetch)
  Future<UserProfile?> getUserProfile() async {
    final doc = await _getUserDocument().get();
    return doc.exists ? UserProfile.fromFirestore(doc) : null;
  }

  /// Create or update user profile
  Future<void> saveUserProfile(UserProfile profile) async {
    await _getUserDocument().set(
      profile.toFirestore(),
      SetOptions(merge: true),
    );
  }

  /// Create initial user profile from Firebase Auth user
  Future<UserProfile> createUserProfile({
    required String userId,
    required String email,
    String? displayName,
    String? photoURL,
  }) async {
    final now = DateTime.now();
    final profile = UserProfile(
      userId: userId,
      displayName: displayName ?? email.split('@').first,
      email: email,
      photoURL: photoURL,
      createdAt: now,
      updatedAt: now,
    );

    await _firestore.collection('users').doc(userId).set(profile.toFirestore());
    return profile;
  }

  /// Update display name
  Future<void> updateDisplayName(String displayName) async {
    await _getUserDocument().update({
      'displayName': displayName,
      'updatedAt': Timestamp.now(),
    });
  }

  /// Update photo URL
  Future<void> updatePhotoURL(String? photoURL) async {
    await _getUserDocument().update({
      'photoURL': photoURL,
      'updatedAt': Timestamp.now(),
    });
  }

  /// Remove profile photo URL
  Future<void> removePhotoURL() async {
    await _getUserDocument().update({
      'photoURL': FieldValue.delete(),
      'updatedAt': Timestamp.now(),
    });
  }

  /// Check if user profile exists
  Future<bool> userProfileExists() async {
    final doc = await _getUserDocument().get();
    return doc.exists;
  }

  /// Initialize user profile if it doesn't exist
  Future<UserProfile?> initializeUserProfile() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return null;

    final exists = await userProfileExists();
    if (exists) {
      return getUserProfile();
    }

    return createUserProfile(
      userId: currentUser.uid,
      email: currentUser.email ?? '',
      displayName: currentUser.displayName,
    );
  }

  /// Delete user profile
  Future<void> deleteUserProfile() async {
    await _getUserDocument().delete();
  }
}

