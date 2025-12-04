import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ideanest/src/features/tags/application/tags_provider.dart';

class CreateTagDialog extends ConsumerStatefulWidget {
  const CreateTagDialog({super.key});

  @override
  ConsumerState<CreateTagDialog> createState() => _CreateTagDialogState();
}

class _CreateTagDialogState extends ConsumerState<CreateTagDialog> {
  final _nameController = TextEditingController();
  int _selectedColor = 0xFF3B82F6; // Blue by default

  final List<Map<String, dynamic>> _colorOptions = [
    {'name': 'Blue', 'color': 0xFF3B82F6},
    {'name': 'Green', 'color': 0xFF10B981},
    {'name': 'Purple', 'color': 0xFF8B5CF6},
    {'name': 'Orange', 'color': 0xFFF97316},
    {'name': 'Yellow', 'color': 0xFFEAB308},
    {'name': 'Indigo', 'color': 0xFF6366F1},
    {'name': 'Pink', 'color': 0xFFEC4899},
    {'name': 'Cyan', 'color': 0xFF06B6D4},
    {'name': 'Teal', 'color': 0xFF14B8A6},
    {'name': 'Lime', 'color': 0xFF84CC16},
    {'name': 'Emerald', 'color': 0xFF059669},
    {'name': 'Violet', 'color': 0xFF7C3AED},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _createTag() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a tag name')),
      );
      return;
    }

    try {
      await ref.read(tagsProvider.notifier).addTag(name, _selectedColor);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tag created successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Tag'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Tag Name',
                hintText: 'Enter tag name',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            const Text(
              'Choose Color',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _colorOptions.map((colorOption) {
                final color = colorOption['color'] as int;
                final isSelected = color == _selectedColor;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = color;
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(color),
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: Colors.black, width: 3)
                          : null,
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 20)
                        : null,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _createTag,
          child: const Text('Create'),
        ),
      ],
    );
  }
}

