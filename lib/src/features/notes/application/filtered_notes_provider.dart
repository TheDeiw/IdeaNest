import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ideanest/src/features/notes/domain/note.dart';
import 'package:ideanest/src/features/notes/application/notes_provider.dart';
import 'package:ideanest/src/features/notes/application/search_provider.dart';

/// Provider for filtered notes based on search query and selected tags
final filteredNotesProvider = Provider<AsyncValue<List<Note>>>((ref) {
  final notesAsync = ref.watch(notesProvider);
  final searchQuery = ref.watch(searchQueryProvider);
  final selectedTags = ref.watch(selectedFilterTagsProvider);

  return notesAsync.whenData((notes) {
    var filtered = notes;

    // Filter by search query
    if (searchQuery.isNotEmpty) {
      final lowerQuery = searchQuery.toLowerCase();
      filtered = filtered.where((note) =>
        note.title.toLowerCase().contains(lowerQuery) ||
        note.content.toLowerCase().contains(lowerQuery)
      ).toList();
    }

    // Filter by selected tags
    if (selectedTags.isNotEmpty) {
      filtered = filtered.where((note) =>
        note.tagIds.any((tagId) => selectedTags.contains(tagId))
      ).toList();
    }

    return filtered;
  });
});


