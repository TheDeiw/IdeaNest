// In lib/src/features/notes/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:ideanest/src/common/constants/app_colors.dart';
import 'package:ideanest/src/common/widgets/app_drawer.dart';
import 'package:ideanest/src/features/notes/application/filtered_notes_provider.dart';
import 'search_screen.dart';
import 'note_edit_screen.dart';
import '../widgets/note_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    const cardMinWidth = 180.0;
    final crossAxisCount = (screenWidth / cardMinWidth).floor().clamp(1, 5);

    return Scaffold(
       backgroundColor: AppColors.background,

      drawer: const AppDrawer(currentRoute: '/home'),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const NoteEditScreen(),
            ),
          );
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
              backgroundColor: AppColors.background,
              surfaceTintColor: AppColors.background,
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
                    onPressed: () {
                      Navigator.of(context).pushNamed('/settings');
                    },
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
                    // Поле пошуку - при кліку відкриває SearchScreen
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const SearchScreen(),
                            ),
                          );
                        },
                        child: Container(
                          color: Colors.transparent,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: const Text(
                            'Search',
                            style: TextStyle(
                              color: Color(0xFF49454F),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            ),

            // Notes grid from Firestore
            ref.watch(filteredNotesProvider).when(
              loading: () => const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
              error: (error, stack) => SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Center(
                    child: Column(
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text('Error: $error', textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ),
              ),
              data: (notes) {
                if (notes.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.note_add_outlined, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'No notes yet',
                              style: TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Tap + to create your first note',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MasonryGridView.count(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      itemCount: notes.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return NoteCard(note: notes[index]);
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
