import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ideanest/src/features/notes/domain/note.dart';
import 'package:ideanest/src/features/notes/data/repositories/notes_repository.dart';
import 'package:ideanest/src/common/providers/repository_providers.dart';

/// Provider for notes list with Firestore integration
final notesProvider = AsyncNotifierProvider<NotesNotifier, List<Note>>(NotesNotifier.new);

/// Notifier for managing notes with Firestore
class NotesNotifier extends AsyncNotifier<List<Note>> {
  late NotesRepository _repository;

  @override
  Future<List<Note>> build() async {
    _repository = ref.watch(notesRepositoryProvider);

    try {
      print('📝 NotesProvider: Initializing...');

      // Listen to notes stream
      _repository.watchNotes().listen((notes) {
        print('📝 NotesProvider: Received ${notes.length} notes from stream');
        state = AsyncValue.data(notes);
      }, onError: (error) {
        print('❌ NotesProvider Stream Error: $error');
        // Handle stream errors (e.g., user not authenticated)
        state = AsyncValue.error(error, StackTrace.current);
      });

      // Return initial data
      final notes = await _repository.getNotes();
      print('✅ NotesProvider: Loaded ${notes.length} notes initially');
      return notes;
    } catch (e) {
      print('❌ NotesProvider Build Error: $e');
      // If user is not authenticated, return empty list instead of error
      return [];
    }
  }

  /// Create a new note
  Future<Note?> createNote({
    required String title,
    required String content,
    required List<String> tagIds,
    bool isPinned = false,
  }) async {
    try {
      final note = await _repository.createNote(
        title: title,
        content: content,
        tagIds: tagIds,
        isPinned: isPinned,
      );
      await refresh();
      return note;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return null;
    }
  }

  /// Update an existing note
  Future<void> updateNote(Note note) async {
    try {
      await _repository.updateNote(note);
      await refresh();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// Delete a note
  Future<void> deleteNote(String noteId) async {
    try {
      await _repository.deleteNote(noteId);
      await refresh();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }


  /// Search notes
  Future<List<Note>> searchNotes(String query) async {
    try {
      return await _repository.searchNotes(query);
    } catch (e) {
      return [];
    }
  }

  /// Get notes by tags
  Future<List<Note>> getNotesByTags(List<String> tagIds) async {
    try {
      return await _repository.getNotesByTags(tagIds);
    } catch (e) {
      return [];
    }
  }

  /// Get a single note
  Future<Note?> getNote(String noteId) async {
    try {
      return await _repository.getNote(noteId);
    } catch (e) {
      return null;
    }
  }

  /// Refresh notes from Firestore
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getNotes());
  }
}


