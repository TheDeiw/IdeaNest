import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:ideanest/src/features/tags/application/tags_provider.dart';
import 'package:ideanest/src/features/notes/application/search_provider.dart';
import 'package:ideanest/src/features/notes/application/filtered_notes_provider.dart';
import '../widgets/note_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(searchQueryProvider.notifier).clear();
      ref.read(selectedFilterTagsProvider.notifier).clear();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleFilterTag(String tagId) {
    ref.read(selectedFilterTagsProvider.notifier).toggleTag(tagId);
  }

  void _clearSearch() {
    _searchController.clear();
    ref.read(searchQueryProvider.notifier).clear();
    ref.read(selectedFilterTagsProvider.notifier).clear();
  }

  @override
  Widget build(BuildContext context) {
    final selectedFilterTags = ref.watch(selectedFilterTagsProvider);
    final tagsAsync = ref.watch(tagsProvider);
    final filteredNotesAsync = ref.watch(filteredNotesProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    const cardMinWidth = 180.0;
    final crossAxisCount = (screenWidth / cardMinWidth).floor().clamp(1, 5);

    return Scaffold(
      backgroundColor: const Color(0xFFEAEAEA),
      body: SafeArea(
        child: Column(
          children: [
            // Search header
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
              height: 72,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: const EdgeInsets.all(12),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      onChanged: (value) {
                        ref.read(searchQueryProvider.notifier).updateQuery(value);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Input text',
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF1D1B20),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: _clearSearch,
                    padding: const EdgeInsets.all(12),
                  ),
                ],
              ),
            ),

            // Divider
            Container(
              height: 1,
              color: Colors.grey[300],
            ),

            // Quick select tags
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quick select tags:',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF49454F),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 106,
                    child: tagsAsync.when(
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (err, _) => Center(child: Text('Error: $err')),
                      data: (allTags) {
                        if (allTags.isEmpty) {
                          return const Center(child: Text('No tags available'));
                        }
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 2,
                            child: Wrap(
                              direction: Axis.horizontal,
                              spacing: 8,
                              runSpacing: 8,
                              children: allTags.map((tag) {
                                final isSelected = selectedFilterTags.contains(tag.id);
                                return InkWell(
                                  onTap: () => _toggleFilterTag(tag.id),
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 13,
                                      vertical: 7,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected ? Color(tag.color) : Colors.white,
                                      borderRadius: BorderRadius.circular(isSelected ? 16 : 1000),
                                      border: Border.all(
                                        color: const Color(0xFFCAC4D0),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          tag.name,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: isSelected
                                                ? _getTextColor(tag.color)
                                                : const Color(0xFF1D1B20),
                                          ),
                                        ),
                                        if (isSelected) ...[
                                          const SizedBox(width: 4),
                                          Icon(
                                            Icons.close,
                                            size: 12,
                                            color: _getTextColor(tag.color),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Divider
            Container(
              height: 1,
              color: Colors.grey[300],
              margin: const EdgeInsets.symmetric(vertical: 8),
            ),

            // Search results
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: filteredNotesAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, _) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text('Error: $err'),
                      ],
                    ),
                  ),
                  data: (notes) {
                    if (notes.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'No notes found',
                              style: TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Try different search terms or tags',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    }
                    return MasonryGridView.count(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        return NoteCard(note: notes[index]);
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTextColor(int backgroundColor) {
    final r = (backgroundColor >> 16) & 0xFF;
    final g = (backgroundColor >> 8) & 0xFF;
    final b = backgroundColor & 0xFF;
    final luminance = (0.299 * r + 0.587 * g + 0.114 * b) / 255;
    return luminance > 0.5 ? Colors.black87 : Colors.white;
  }
}

