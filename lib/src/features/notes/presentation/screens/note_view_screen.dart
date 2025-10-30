// In lib/src/features/notes/presentation/screens/note_view_screen.dart
import 'package:flutter/material.dart';
import 'package:ideanest/src/common/constants/app_colors.dart';
import 'package:ideanest/src/features/notes/presentation/screens/note_edit_screen.dart';

class NoteViewScreen extends StatelessWidget {
  const NoteViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // Плаваюча кнопка для переходу в режим редагування
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const NoteEditScreen()),
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.edit_outlined, color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Верхня панель з кнопками "Назад" та "Видалити"
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildIconButton(context, Icons.arrow_back, () => Navigator.of(context).pop()),
                  _buildIconButton(context, Icons.delete_outline, () { /* TODO: Delete logic */ }),
                ],
              ),
              const SizedBox(height: 24),

              // 2. Секція тегів
              const Text("TAGS", style: TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                children: [
                  _buildTag("ideas", Colors.lightBlue),
                  _buildTag("development", Colors.purpleAccent),
                ],
              ),
              const SizedBox(height: 24),

              // 3. Заголовок нотатки
              const Text(
                "App Ideas",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // 4. Тіло нотатки
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "Been thinking about creating a habit tracker that uses gamification principles. Users could earn points and unlock achievements for maintaining streaks. Could integrate with health apps for additional data insights.\n\nAnother idea: A collaborative recipe app where families can share and modify recipes together. Each person could add their own notes and modifications.",
                  style: TextStyle(fontSize: 16, height: 1.5),
                ),
              ),
              const SizedBox(height: 60), // Відступ, щоб не перекривалось FAB

              // 5. Дата створення
              const Center(
                child: Text(
                  "Created on March 13, 2024 at 04:20 PM",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Допоміжний віджет для круглої кнопки зверху
  Widget _buildIconButton(BuildContext context, IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2)),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.black87),
        onPressed: onPressed,
      ),
    );
  }

  // Допоміжний віджет для тега
  Widget _buildTag(String label, Color color) {
    return Chip(
      label: Text(label),
      backgroundColor: color.withOpacity(0.1),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.bold),
      side: BorderSide.none,
    );
  }
}