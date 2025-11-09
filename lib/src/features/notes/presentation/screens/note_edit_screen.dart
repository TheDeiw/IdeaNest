// In lib/src/features/notes/presentation/screens/note_edit_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ideanest/src/common/constants/app_colors.dart';
import 'package:ideanest/src/features/tags/application/tags_provider.dart';
import 'package:ideanest/src/features/tags/presentation/widgets/add_tag_dialog.dart';

class NoteEditScreen extends ConsumerStatefulWidget {
  const NoteEditScreen({super.key});

  @override
  ConsumerState<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends ConsumerState<NoteEditScreen> {
  final List<String> _selectedTagIds = ['3']; // Default "ideas" tag

  void _showAddTagDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: AddTagDialog(
          selectedTagIds: _selectedTagIds,
          onTagsSelected: (selectedIds) {
            setState(() {
              _selectedTagIds.clear();
              _selectedTagIds.addAll(selectedIds);
            });
          },
        ),
      ),
    );
  }

  void _removeTag(String tagId) {
    setState(() {
      _selectedTagIds.remove(tagId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tagsNotifier = ref.read(tagsProvider.notifier);
    final selectedTags = _selectedTagIds
        .map((id) => tagsNotifier.getTagById(id))
        .where((tag) => tag != null)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.black87),
            onPressed: () { /* TODO: Delete Logic */ },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Секція тегів
            const Text("TAGS", style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                ...selectedTags.map((tag) => Chip(
                  label: Text(tag!.name),
                  backgroundColor: Color(tag.color),
                  deleteIcon: const Icon(Icons.close, size: 16),
                  onDeleted: () => _removeTag(tag.id),
                  labelStyle: TextStyle(
                    color: _getTextColor(tag.color),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1000),
                    side: const BorderSide(
                      color: Color(0xFFCAC4D0),
                      width: 1,
                    ),
                  ),
                )),
                ActionChip(
                  avatar: const Icon(Icons.add, size: 16),
                  label: const Text("Add Tag"),
                  onPressed: _showAddTagDialog,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1000),
                    side: const BorderSide(
                      color: Color(0xFFD1D5DC),
                      width: 1,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 2. Поле для вводу заголовка
            TextField(
              controller: TextEditingController(text: "App Ideas"),
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Title",
              ),
            ),
            const SizedBox(height: 16),

            // 3. Поле для вводу тіла нотатки
            TextField(
              controller: TextEditingController(text: "Start writing your note..."),
              maxLines: 10, // Дозволяє полю розширюватися
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Start writing your note...",
              ),
            ),
          ],
        ),
      ),
      // 4. Нижня панель з кнопками
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Щоб Column займав мінімум місця
          children: [
            // Панель форматування
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ToggleButtons(
                    isSelected: const [false, true, false], // B, I, U
                    onPressed: (index) {},
                    children: const [Icon(Icons.format_bold), Icon(Icons.format_italic), Icon(Icons.format_underline)],
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.format_list_bulleted),
                    label: const Text("Bullets"),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Кнопки збереження
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text("Save Changes"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text("Cancel"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getTextColor(int backgroundColor) {
    // Simple contrast calculation
    final color = Color(backgroundColor);
    final luminance = (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
    return luminance > 0.5 ? Colors.black87 : Colors.white;
  }
}