import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ideanest/src/features/notes/domain/note.dart';

/// Repository for managing notes in Firestore
class NotesRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  NotesRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  /// Get reference to user's notes collection
  CollectionReference<Map<String, dynamic>> _getNotesCollection() {
    final userId = _auth.currentUser?.uid;
    print('📝 NotesRepository: Getting notes collection for user: $userId');
    if (userId == null) {
      print('❌ NotesRepository: User not authenticated!');
      throw Exception('User not authenticated');
    }
    print('✅ NotesRepository: User authenticated, accessing: users/$userId/notes');
    return _firestore.collection('users').doc(userId).collection('notes');
  }

  /// Stream of all notes for the current user
  Stream<List<Note>> watchNotes() {
    return _getNotesCollection()
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Note.fromFirestore(doc))
            .toList());
  }

  /// Stream of a single note
  Stream<Note?> watchNote(String noteId) {
    return _getNotesCollection()
        .doc(noteId)
        .snapshots()
        .map((doc) => doc.exists ? Note.fromFirestore(doc) : null);
  }

  /// Get all notes (one-time fetch)
  Future<List<Note>> getNotes() async {
    final snapshot = await _getNotesCollection()
        .orderBy('updatedAt', descending: true)
        .get();
    return snapshot.docs.map((doc) => Note.fromFirestore(doc)).toList();
  }

  /// Get a single note by ID
  Future<Note?> getNote(String noteId) async {
    final doc = await _getNotesCollection().doc(noteId).get();
    return doc.exists ? Note.fromFirestore(doc) : null;
  }

  /// Create a new note
  Future<Note> createNote({
    required String title,
    required String content,
    required List<String> tagIds,
    bool isPinned = false,
  }) async {
    final now = DateTime.now();
    final docRef = _getNotesCollection().doc();

    final note = Note(
      id: docRef.id,
      title: title,
      content: content,
      tagIds: tagIds,
      createdAt: now,
      updatedAt: now,
      isPinned: isPinned,
    );

    await docRef.set(note.toFirestore());
    return note;
  }

  /// Update an existing note
  Future<void> updateNote(Note note) async {
    final updatedNote = note.copyWith(updatedAt: DateTime.now());
    await _getNotesCollection()
        .doc(note.id)
        .update(updatedNote.toFirestore());
  }

  /// Delete a note
  Future<void> deleteNote(String noteId) async {
    await _getNotesCollection().doc(noteId).delete();
  }

  /// Toggle pin status
  Future<void> togglePin(String noteId, bool isPinned) async {
    await _getNotesCollection().doc(noteId).update({
      'isPinned': isPinned,
      'updatedAt': Timestamp.now(),
    });
  }

  /// Search notes by text
  Future<List<Note>> searchNotes(String query) async {
    if (query.isEmpty) {
      return getNotes();
    }

    // Note: Firestore doesn't support full-text search natively
    // We'll fetch all notes and filter locally
    // For production, consider using Algolia or ElasticSearch
    final allNotes = await getNotes();
    final lowerQuery = query.toLowerCase();

    return allNotes.where((note) =>
      note.title.toLowerCase().contains(lowerQuery) ||
      note.content.toLowerCase().contains(lowerQuery)
    ).toList();
  }

  /// Get notes by tag IDs
  Future<List<Note>> getNotesByTags(List<String> tagIds) async {
    if (tagIds.isEmpty) {
      return getNotes();
    }

    final snapshot = await _getNotesCollection()
        .where('tagIds', arrayContainsAny: tagIds)
        .orderBy('updatedAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => Note.fromFirestore(doc)).toList();
  }

  /// Stream notes by tag IDs
  Stream<List<Note>> watchNotesByTags(List<String> tagIds) {
    if (tagIds.isEmpty) {
      return watchNotes();
    }

    return _getNotesCollection()
        .where('tagIds', arrayContainsAny: tagIds)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Note.fromFirestore(doc))
            .toList());
  }
}

