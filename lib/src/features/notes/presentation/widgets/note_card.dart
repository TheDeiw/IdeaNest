// In lib/src/features/notes/presentation/widgets/note_card.dart
import 'package:flutter/material.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Для прикладу, поки що дані захардкодимо
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Project Planning Session",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Review quarterly goals\nAssign team\nSet milestone deadlines",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 12),
            // Wrap дозволяє тегам переноситись на новий рядок, якщо їм не вистачає місця
            Wrap(
              spacing: 8.0, // Горизонтальний відступ між тегами
              runSpacing: 4.0, // Вертикальний відступ між рядками тегів
              children: [
                _buildTag("work", Colors.blue),
                _buildTag("meeting", Colors.green),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              "Mar 15",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // Допоміжний метод для створення віджету тега
  Widget _buildTag(String label, Color color) {
    return Chip(
      label: Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}