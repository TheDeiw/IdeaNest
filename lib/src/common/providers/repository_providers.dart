import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ideanest/src/features/notes/data/repositories/notes_repository.dart';
import 'package:ideanest/src/features/tags/data/repositories/tags_repository.dart';
import 'package:ideanest/src/features/settings/data/repositories/user_profile_repository.dart';

/// Provider for FirebaseFirestore instance
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

/// Provider for FirebaseAuth instance
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

/// Provider for NotesRepository
final notesRepositoryProvider = Provider<NotesRepository>((ref) {
  return NotesRepository(
    firestore: ref.watch(firestoreProvider),
    auth: ref.watch(firebaseAuthProvider),
  );
});

/// Provider for TagsRepository
final tagsRepositoryProvider = Provider<TagsRepository>((ref) {
  return TagsRepository(
    firestore: ref.watch(firestoreProvider),
    auth: ref.watch(firebaseAuthProvider),
  );
});

/// Provider for UserProfileRepository
final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  return UserProfileRepository(
    firestore: ref.watch(firestoreProvider),
    auth: ref.watch(firebaseAuthProvider),
  );
});

