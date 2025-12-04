import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ideanest/src/features/tags/domain/tag.dart';
import 'package:ideanest/src/features/tags/application/tags_provider.dart';

class AddTagDialog extends ConsumerStatefulWidget {
  final List<String> selectedTagIds;
  final Function(List<String>) onTagsSelected;

  const AddTagDialog({
    super.key,
    required this.selectedTagIds,
    required this.onTagsSelected,
  });

  @override
  ConsumerState<AddTagDialog> createState() => _AddTagDialogState();
}

class _AddTagDialogState extends ConsumerState<AddTagDialog> {
  final TextEditingController _searchController = TextEditingController();
  late List<String> _selectedTags;
  String _searchQuery = '';
  bool _isCreatingTag = false;

  @override
  void initState() {
    super.initState();
    _selectedTags = List.from(widget.selectedTagIds);
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleTag(String tagId) {
    setState(() {
      if (_selectedTags.contains(tagId)) {
        _selectedTags.remove(tagId);
      } else {
        _selectedTags.add(tagId);
      }
    });
  }

  Future<void> _createNewTag() async {
    final tagName = _searchQuery.trim();
    if (tagName.isEmpty || _isCreatingTag) return;

    setState(() => _isCreatingTag = true);

    try {
      final tagsAsync = ref.read(tagsProvider);

      // Check if tag already exists
      Tag? existingTag;
      try {
        existingTag = tagsAsync.value?.firstWhere(
          (tag) => tag.name.toLowerCase() == tagName.toLowerCase(),
        );
      } catch (_) {
        existingTag = null;
      }

      if (existingTag != null) {
        _toggleTag(existingTag.id);
        setState(() {
          _searchController.clear();
          _searchQuery = '';
          _isCreatingTag = false;
        });
        return;
      }

      // Create new tag in Firestore
      await ref.read(tagsProvider.notifier).addTag(
        tagName,
        _getRandomColor(),
      );

      // Wait for the provider to update
      await Future.delayed(const Duration(milliseconds: 500));

      // Get the newly created tag
      Tag? newTag;
      try {
        newTag = ref.read(tagsProvider).value?.firstWhere(
          (tag) => tag.name.toLowerCase() == tagName.toLowerCase(),
        );
      } catch (_) {
        newTag = null;
      }

      if (newTag != null && mounted) {
        setState(() {
          _selectedTags.add(newTag!.id);
          _searchController.clear();
          _searchQuery = '';
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating tag: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isCreatingTag = false);
      }
    }
  }

  int _getRandomColor() {
    final colors = [
      0xFFFFD8E4,
      0xFFD0FAE5,
      0xFFE8DEF8,
      0xFFFBBC04,
      0xFFF3EDF7,
      0xFFCBFBF1,
      0xFFDDD6FE,
      0xFFFCE7F3,
      0xFFFFEDD4,
      0xFFEADDFF,
    ];
    return colors[DateTime.now().millisecondsSinceEpoch % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final tagsAsync = ref.watch(tagsProvider);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Add Tags',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1D1B20),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 16),
                onPressed: () => Navigator.of(context).pop(),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Search/Create input
          TextField(
            controller: _searchController,
            enabled: !_isCreatingTag,
            decoration: InputDecoration(
              hintText: 'Search or create tag...',
              hintStyle: const TextStyle(
                color: Color(0xFF49454F),
                fontSize: 16,
              ),
              filled: true,
              fillColor: const Color(0xFFEAEAEA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFF79747E),
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFF79747E),
                  width: 1,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 4,
              ),
            ),
            onSubmitted: (_) => _createNewTag(),
          ),
          const SizedBox(height: 16),

          // Available Tags label
          const Text(
            'Available Tags',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF49454F),
            ),
          ),
          const SizedBox(height: 8),

          // Tags list
          Container(
            constraints: const BoxConstraints(maxHeight: 144),
            child: tagsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
              data: (allTags) {
                final filteredTags = _searchQuery.isEmpty
                    ? allTags
                    : allTags.where((tag) =>
                        tag.name.toLowerCase().contains(_searchQuery.toLowerCase())
                      ).toList();

                // Show empty state if no tags exist
                if (allTags.isEmpty && _searchQuery.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'No tags yet. Type to create your first tag!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF49454F),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                }

                return SingleChildScrollView(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ...filteredTags.map((tag) => _buildTagChip(tag)),
                      if (_searchQuery.isNotEmpty &&
                          !filteredTags.any((tag) =>
                            tag.name.toLowerCase() == _searchQuery.toLowerCase()))
                        _buildCreateTagChip(),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Done button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isCreatingTag
                  ? null
                  : () {
                      widget.onTagsSelected(_selectedTags);
                      Navigator.of(context).pop();
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF33394D),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: const Text(
                'Done',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagChip(Tag tag) {
    final isSelected = _selectedTags.contains(tag.id);

    return InkWell(
      onTap: () => _toggleTag(tag.id),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 4),
        decoration: BoxDecoration(
          color: Color(tag.color),
          borderRadius: BorderRadius.circular(16),
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
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: _getTextColor(tag.color),
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              isSelected ? Icons.check : Icons.add,
              size: 12,
              color: _getTextColor(tag.color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateTagChip() {
    return InkWell(
      onTap: _createNewTag,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFE8DEF8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFCAC4D0),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Create "$_searchQuery"',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1D192B),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.add,
              size: 12,
              color: Color(0xFF1D192B),
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

