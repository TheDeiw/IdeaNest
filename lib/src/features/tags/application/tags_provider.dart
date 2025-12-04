import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ideanest/src/features/tags/domain/tag.dart';
import 'package:ideanest/src/features/tags/data/repositories/tags_repository.dart';
import 'package:ideanest/src/common/providers/repository_providers.dart';

/// Provider for tags list with Firestore integration
final tagsProvider = AsyncNotifierProvider<TagsNotifier, List<Tag>>(TagsNotifier.new);

/// Notifier for managing tags with Firestore
class TagsNotifier extends AsyncNotifier<List<Tag>> {
  late TagsRepository _repository;

  @override
  Future<List<Tag>> build() async {
    _repository = ref.watch(tagsRepositoryProvider);

    try {
      // Return tags from Firestore (no automatic initialization)
      return _repository.getTags();
    } catch (e) {
      // If user is not authenticated, return empty list
      return [];
    }
  }

  /// Додати новий тег
  Future<void> addTag(String name, int color) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.createTag(name: name, color: color);
      return _repository.getTags();
    });
  }

  /// Видалити тег
  Future<void> deleteTag(String tagId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.deleteTag(tagId);
      return _repository.getTags();
    });
  }

  /// Оновити тег
  Future<void> updateTag(Tag updatedTag) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.updateTag(updatedTag);
      return _repository.getTags();
    });
  }

  /// Знайти тег за іменем
  Tag? findTagByName(String name) {
    return state.value?.firstWhere(
      (tag) => tag.name.toLowerCase() == name.toLowerCase(),
      orElse: () => throw StateError('Tag not found'),
    );
  }

  /// Отримати тег за ID
  Tag? getTagById(String id) {
    return state.value?.firstWhere(
      (tag) => tag.id == id,
      orElse: () => throw StateError('Tag not found'),
    );
  }

  /// Пошук тегів за запитом
  List<Tag> searchTags(String query) {
    final tags = state.value ?? [];
    if (query.isEmpty) return tags;
    return tags.where((tag) =>
      tag.name.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  /// Refresh tags from Firestore
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getTags());
  }
}

