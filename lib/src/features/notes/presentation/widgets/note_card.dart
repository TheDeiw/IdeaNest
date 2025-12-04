import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ideanest/src/features/notes/domain/note.dart';
import 'package:ideanest/src/features/notes/presentation/screens/note_edit_screen.dart';
import 'package:ideanest/src/features/tags/application/tags_provider.dart';
import 'package:ideanest/src/features/tags/domain/tag.dart';

class NoteCard extends ConsumerWidget {
  final Note note;

  const NoteCard({super.key, required this.note});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagsAsync = ref.watch(tagsProvider);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => NoteEditScreen(
              noteId: note.id,
              initialTitle: note.title,
              initialContent: note.content,
              initialTagIds: note.tagIds,
            ),
          ),
        );
      },
      child: Card(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey[200]!, width: 1),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Padding(
          padding: const EdgeInsets.all(17.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (note.title.isNotEmpty) ...[
                Text(
                  note.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF101828),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
              ],
              if (note.content.isNotEmpty) ...[
                Text(
                  note.content,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF4A5565)),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
              ],
              // Tags
              tagsAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
                data: (allTags) {
                  final noteTags = note.tagIds
                      .map((id) {
                        try {
                          return allTags.firstWhere((tag) => tag.id == id);
                        } catch (_) {
                          return null;
                        }
                      })
                      .whereType<Tag>()
                      .take(3) // Limit to 3 tags
                      .toList();

                  if (noteTags.isEmpty) return const SizedBox.shrink();

                  return Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: noteTags.map((tag) {
                      return Chip(
                        label: Text(
                          tag.name,
                          style: TextStyle(
                            color: _getTextColor(tag.color),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        backgroundColor: Color(tag.color),
                        shape: StadiumBorder(
                          side: BorderSide(color: Color(tag.color).withAlpha(76)),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      );
                    }).toList(),
                  );
                },
              ),
              if (note.tagIds.isNotEmpty) const SizedBox(height: 12),
              // Date
              Text(
                _formatDate(note.updatedAt),
                style: const TextStyle(fontSize: 12, color: Color(0xFF99A1AF)),
              ),
            ],
          ),
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

