// In lib/src/features/notes/presentation/widgets/home_drawer.dart
import 'package:flutter/material.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // Drawer - стандартний Material віджет для бокового меню.
    return Drawer(
      child: ListView(
        // padding: EdgeInsets.zero прибирає зайвий відступ зверху.
        padding: EdgeInsets.zero,
        children: [
          // DrawerHeader - красива шапка для меню.
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.white, // Можна змінити на колір вашого бренду
            ),
            child: Text(
              'IdeaNest',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // ListTile - ідеальний віджет для пунктів меню (іконка + текст).
          ListTile(
            leading: const Icon(Icons.lightbulb_outline),
            title: const Text('Ideas'),
            onTap: () {
              // TODO: Додати логіку
              Navigator.pop(context); // Закриває меню
            },
          ),
          ListTile(
            leading: const Icon(Icons.tag),
            title: const Text('Tags'),
            onTap: () {
              // TODO: Додати логіку
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            onTap: () {
              // TODO: Додати логіку
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}