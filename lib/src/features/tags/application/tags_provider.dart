import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ideanest/src/features/tags/domain/tag.dart';

// Provider для списку всіх тегів
final tagsProvider = NotifierProvider<TagsNotifier, List<Tag>>(TagsNotifier.new);

// Notifier для управління тегами
class TagsNotifier extends Notifier<List<Tag>> {
  @override
  List<Tag> build() {
    return _getDefaultTags();
  }

  static List<Tag> _getDefaultTags() {
    return [
      Tag(id: '1', name: 'development', color: 0xFFFFD8E4),
      Tag(id: '2', name: 'health', color: 0xFFD0FAE5),
      Tag(id: '3', name: 'ideas', color: 0xFFE8DEF8),
      Tag(id: '4', name: 'personal', color: 0xFFFBBC04),
      Tag(id: '5', name: 'reading', color: 0xFFF3EDF7),
      Tag(id: '6', name: 'research', color: 0xFFCBFBF1),
      Tag(id: '7', name: 'routine', color: 0xFFDDD6FE),
      Tag(id: '8', name: 'shopping', color: 0xFFFCE7F3),
      Tag(id: '9', name: 'travel', color: 0xFFFFEDD4),
      Tag(id: '10', name: 'weekend', color: 0xFFEADDFF),
      Tag(id: '11', name: 'work', color: 0xFFDBEAFE),
      Tag(id: '12', name: 'meeting', color: 0xFFD1FAE5),
    ];
  }

  // Додати новий тег
  void addTag(Tag tag) {
    state = [...state, tag];
  }

  // Видалити тег
  void removeTag(String tagId) {
    state = state.where((tag) => tag.id != tagId).toList();
  }

  // Оновити тег
  void updateTag(Tag updatedTag) {
    state = [
      for (final tag in state)
        if (tag.id == updatedTag.id) updatedTag else tag,
    ];
  }

  // Знайти тег за іменем
  Tag? findTagByName(String name) {
    try {
      return state.firstWhere(
        (tag) => tag.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  // Отримати тег за ID
  Tag? getTagById(String id) {
    try {
      return state.firstWhere((tag) => tag.id == id);
    } catch (e) {
      return null;
    }
  }

  // Пошук тегів за запитом
  List<Tag> searchTags(String query) {
    if (query.isEmpty) return state;
    return state.where((tag) =>
      tag.name.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
}

