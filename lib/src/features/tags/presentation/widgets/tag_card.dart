import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ideanest/src/features/tags/application/tags_provider.dart';
import 'package:ideanest/src/features/tags/presentation/screens/edit_tag_screen.dart';

class TagCard extends ConsumerWidget {
  final String tagId;
  final String tagName;
  final int noteCount;
  final Color tagColor;
  final Color tagBackgroundColor;
  final Color tagBorderColor;

  const TagCard({
    super.key,
    required this.tagId,
    required this.tagName,
    required this.noteCount,
    required this.tagColor,
    required this.tagBackgroundColor,
    required this.tagBorderColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey[200]!, width: 1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Chip(
                  label: Text(
                    tagName,
                    style: TextStyle(
                      color: tagColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  backgroundColor: tagBackgroundColor,
                  shape: StadiumBorder(side: BorderSide(color: tagBorderColor)),
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                const SizedBox(width: 12),
                Text(
                  '$noteCount note${noteCount != 1 ? 's' : ''}',
                  style: const TextStyle(fontSize: 14, color: Color(0xFF4A5565)),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Edit button
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  onPressed: () async {
                    final tagsAsync = ref.read(tagsProvider);
                    final tag = tagsAsync.value?.firstWhere((t) => t.id == tagId);

                    if (tag != null) {
                      showDialog(
                        context: context,
                        builder: (context) => EditTagScreen(
                          tag: tag,
                          tagName: tagName,
                          tagColor: tagColor,
                          tagBackgroundColor: tagBackgroundColor,
                          tagBorderColor: tagBorderColor,
                        ),
                      );
                    }
                  },
                  color: const Color(0xFF4A5565),
                  tooltip: 'Edit tag',
                ),
                // Delete button
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 18),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Tag'),
                        content: Text('Are you sure you want to delete "$tagName"?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      await ref.read(tagsProvider.notifier).deleteTag(tagId);
                    }
                  },
                  color: Colors.red,
                  tooltip: 'Delete tag',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

