import 'package:flutter/material.dart';
import 'package:ideanest/src/features/tags/presentation/screens/edit_tag_screen.dart';

class TagCard extends StatelessWidget {
  final String tagName;
  final int noteCount;
  final Color tagColor;
  final Color tagBackgroundColor;
  final Color tagBorderColor;

  const TagCard({
    super.key,
    required this.tagName,
    required this.noteCount,
    required this.tagColor,
    required this.tagBackgroundColor,
    required this.tagBorderColor,
  });

  @override
  Widget build(BuildContext context) {
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
                  label: Text(tagName,
                      style: TextStyle(
                          color: tagColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500)),
                  backgroundColor: tagBackgroundColor,
                  shape: StadiumBorder(side: BorderSide(color: tagBorderColor)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                const SizedBox(width: 12),
                Text(
                  '$noteCount note${noteCount > 1 ? 's' : ''}',
                  style: const TextStyle(fontSize: 14, color: Color(0xFF4A5565)),
                ),
              ],
            ),
            TextButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => EditTagScreen(
                    tagName: tagName,
                    tagColor: tagColor,
                    tagBackgroundColor: tagBackgroundColor,
                    tagBorderColor: tagBorderColor,
                  ),
                );
              },
              icon: const Icon(Icons.edit, size: 16),
              label: const Text('Edit'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF4A5565),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

