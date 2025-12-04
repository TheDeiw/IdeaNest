import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ideanest/src/common/constants/app_colors.dart';
import 'package:ideanest/src/features/notes/presentation/widgets/delete_note_dialog.dart';
import 'package:ideanest/src/features/tags/application/tags_provider.dart';
import 'package:ideanest/src/features/tags/presentation/widgets/add_tag_dialog.dart';
import 'package:ideanest/src/features/notes/application/notes_provider.dart';
import 'package:ideanest/src/features/notes/domain/note.dart';

class NoteEditScreen extends ConsumerStatefulWidget {
  final String? noteId;
  final String? initialTitle;
  final String? initialContent;
  final List<String>? initialTagIds;

  const NoteEditScreen({
    super.key,
    this.noteId,
    this.initialTitle,
    this.initialContent,
    this.initialTagIds,
  });

  @override
  ConsumerState<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends ConsumerState<NoteEditScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final List<String> _selectedTagIds;
  bool _isLoading = false;
  bool _isLoadingNote = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle ?? '');
    _contentController = TextEditingController(text: widget.initialContent ?? '');
    _selectedTagIds = widget.initialTagIds ?? [];

    if (widget.noteId != null) {
      _loadNoteData();
    }
  }

  Future<void> _loadNoteData() async {
    if (widget.noteId == null) return;

    setState(() => _isLoadingNote = true);

    try {
      final note = await ref.read(notesProvider.notifier).getNote(widget.noteId!);
      if (note != null && mounted) {
        setState(() {
          _titleController.text = note.title;
          _contentController.text = note.content;
          _selectedTagIds.clear();
          _selectedTagIds.addAll(note.tagIds);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading note: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingNote = false);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

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

  Future<void> _handleDelete() async {
    final noteTitle = _titleController.text.trim().isEmpty
        ? 'Untitled Note'
        : _titleController.text.trim();

    final result = await DeleteNoteDialog.show(context, noteTitle);

    if (result == true && widget.noteId != null) {
      setState(() => _isLoading = true);

      try {
        await ref.read(notesProvider.notifier).deleteNote(widget.noteId!);

        if (mounted) {
          Navigator.of(context).pop(true);
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting note: $e')),
          );
        }
      }
    }
  }

  Future<void> _handleSave() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty && content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a title or content')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final notesNotifier = ref.read(notesProvider.notifier);

      // Debug: print selected tags
      print('💾 Saving note with tags: $_selectedTagIds');

      if (widget.noteId != null) {
        final existingNote = await notesNotifier.getNote(widget.noteId!);
        if (existingNote != null) {
          final updatedNote = existingNote.copyWith(
            title: title,
            content: content,
            tagIds: List<String>.from(_selectedTagIds), // Create new list
          );
          print('💾 Updated note tags: ${updatedNote.tagIds}');
          await notesNotifier.updateNote(updatedNote);
        }
      } else {
        await notesNotifier.createNote(
          title: title,
          content: content,
          tagIds: List<String>.from(_selectedTagIds), // Create new list
        );
      }

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      print('❌ Error saving note: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving note: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tagsAsync = ref.watch(tagsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
        ),
        actions: [
          if (widget.noteId != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.black87),
              onPressed: _isLoading ? null : _handleDelete,
            ),
        ],
      ),
      body: _isLoadingNote
          ? const Center(child: CircularProgressIndicator())
          : tagsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
              data: (allTags) {
                final selectedTags = _selectedTagIds
                    .map((id) {
                      try {
                        return allTags.firstWhere((tag) => tag.id == id);
                      } catch (_) {
                        return null;
                      }
                    })
                    .where((tag) => tag != null)
                    .toList();

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      TextField(
                        controller: _titleController,
                        enabled: !_isLoading,
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Title",
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _contentController,
                        enabled: !_isLoading,
                        maxLines: 10,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Start writing your note...",
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 10)
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ToggleButtons(
                    isSelected: const [false, true, false],
                    onPressed: (index) {},
                    children: const [
                      Icon(Icons.format_bold),
                      Icon(Icons.format_italic),
                      Icon(Icons.format_underline)
                    ],
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
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(widget.noteId != null ? "Save Changes" : "Create Note"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
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
    final r = (backgroundColor >> 16) & 0xFF;
    final g = (backgroundColor >> 8) & 0xFF;
    final b = backgroundColor & 0xFF;
    final luminance = (0.299 * r + 0.587 * g + 0.114 * b) / 255;
    return luminance > 0.5 ? Colors.black87 : Colors.white;
  }
}

