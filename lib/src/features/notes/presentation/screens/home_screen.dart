// In lib/src/features/notes/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../widgets/home_drawer.dart';
import '../widgets/note_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold - це наш головний конструктор екрана.
    return Scaffold(
      // backgroundColor: Colors.grey[100], // Світло-сірий фон, як на макеті

      // 1. Бокове меню, яке ми створили.
      drawer: const HomeDrawer(),

      // 2. Плаваюча кнопка дії.
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Логіка створення нової нотатки
        },
        child: const Icon(Icons.add),
      ),

      // body займає весь простір екрана.
      // SafeArea гарантує, що контент не накладається на системні елементи.
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // 3. Верхня панель (AppBar). Ми робимо її "плаваючою" (sliver).
            SliverAppBar(
              pinned: true, // Залишається видимою при прокрутці
              floating: true, // З'являється, як тільки починаємо скролити вгору
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 1,
              // Іконка профілю
              actions: [
                IconButton(
                  icon: const Icon(Icons.person_outline, size: 28),
                  onPressed: () { /* TODO: Profile action */ },
                ),
                const SizedBox(width: 8),
              ],
              // Поле пошуку замість стандартного заголовка
              title: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ),

            // 4. Основний контент - сітка з нотатками
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                // Використовуємо пакет, який додали раніше
                child: MasonryGridView.count(
                  crossAxisCount: 2, // 2 колонки
                  mainAxisSpacing: 8, // Відступ по вертикалі
                  crossAxisSpacing: 8, // Відступ по горизонталі
                  itemCount: 10, // Поки що покажемо 10 однакових нотаток
                  // Важливо! ці два рядки потрібні, щоб сітка не скролилась самостійно
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    // Тут ми будемо передавати реальні дані
                    return const NoteCard();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}