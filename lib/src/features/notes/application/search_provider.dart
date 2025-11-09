import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider для тексту пошуку
final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(SearchQueryNotifier.new);

class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void updateQuery(String query) {
    state = query;
  }

  void clear() {
    state = '';
  }
}

// Provider для вибраних тегів для фільтрації
final selectedFilterTagsProvider = NotifierProvider<SelectedFilterTagsNotifier, List<String>>(
  SelectedFilterTagsNotifier.new,
);

class SelectedFilterTagsNotifier extends Notifier<List<String>> {
  @override
  List<String> build() => [];

  void toggleTag(String tagId) {
    if (state.contains(tagId)) {
      state = state.where((id) => id != tagId).toList();
    } else {
      state = [...state, tagId];
    }
  }

  void clear() {
    state = [];
  }
}

