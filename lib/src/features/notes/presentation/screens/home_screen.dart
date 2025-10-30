// In lib/src/features/notes/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:ideanest/src/common/constants/app_colors.dart';
import '../widgets/home_drawer.dart';
import '../widgets/note_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.grey[100],

      drawer: const HomeDrawer(),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Логіка створення нової нотатки
        },
        backgroundColor: AppColors.primaryVariant,
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),

      body: SafeArea(
        child: CustomScrollView(
          slivers: [

            SliverAppBar(
              pinned: false,
              floating: true,
              snap: true,
              backgroundColor: AppColors.surface,
              elevation: 1,
              leading: Builder(
                builder: (BuildContext context) => Container(
                  margin: const EdgeInsets.only(left: 8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.menu, color: Color(0xFF49454F)),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
              ),
              // Іконка профілю у білому колі
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.person_outline, color: Color(0xFF49454F)),
                    onPressed: () { /* TODO: Profile action */ },
                  ),
                ),
              ],
              title: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      child: const Icon(Icons.search, color: Color(0xFF49454F)),
                    ),
                    const SizedBox(width: 8),
                    // Саме поле пошуку — без бордера, займає всю доступну ширину
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          // TODO: обробка пошуку
                        },
                        decoration: const InputDecoration(
                          hintText: 'Search',
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),

            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: MasonryGridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  itemCount: 10,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
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
