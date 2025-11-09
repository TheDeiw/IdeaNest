// In lib/src/features/notes/presentation/widgets/note_card.dart
import 'package:flutter/material.dart';
import 'package:ideanest/src/features/notes/presentation/screens/note_view_screen.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Для прикладу, поки що дані захардкодимо
    return GestureDetector(
        onTap: () {
          // Navigator.push відкриває новий екран поверх поточного.
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const NoteViewScreen()),
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
                const Text(
                  "Project Planning Session",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF101828),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Review quarterly goals\nAssign team\nSet milestone deadlines",
                  style: TextStyle(fontSize: 14, color: Color(0xFF4A5565)),
                ),
                const SizedBox(height: 12),
                // Wrap дозволяє тегам переноситись на новий рядок, якщо їм не вистачає місця
                Wrap(
                  spacing: 8.0, // Горизонтальний відступ між тегами
                  runSpacing: 4.0, // Вертикальний відступ між рядками тегів
                  children: [
                    _buildTag("work", const Color(0xFF1447E6), const Color(0xFFDBEAFE), const Color(0xFFBEDBFF)),
                    _buildTag("meeting", const Color(0xFF008236), const Color(0xFFD1FAE5), const Color(0xFFB9F8CF)),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  "Mar 15",
                  style: TextStyle(fontSize: 12, color: Color(0xFF99A1AF)),
                ),
              ],
            ),
          )
      ),
    );
  }

  // Допоміжний метод для створення віджету тега
  Widget _buildTag(String label, Color textColor, Color backgroundColor, Color borderColor) {
    return Chip(
      label: Text(label, style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.w500)),
      backgroundColor: backgroundColor,
      shape: StadiumBorder(side: BorderSide(color: borderColor)),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}