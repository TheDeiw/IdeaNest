import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ideanest/src/common/widgets/app_drawer.dart';
import 'package:ideanest/src/features/tags/presentation/widgets/tag_card.dart';
import 'package:ideanest/src/features/tags/presentation/widgets/create_tag_dialog.dart';
import 'package:ideanest/src/features/tags/application/tags_provider.dart';
import 'package:ideanest/src/features/notes/application/notes_provider.dart';

class TagsScreen extends ConsumerWidget {
  const TagsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagsAsync = ref.watch(tagsProvider);
    final notesAsync = ref.watch(notesProvider);

    // Calculate note count for each tag
    Map<String, int> getTagCounts() {
      if (notesAsync.value == null) return {};

      final counts = <String, int>{};
      for (final note in notesAsync.value!) {
        for (final tagId in note.tagIds) {
          counts[tagId] = (counts[tagId] ?? 0) + 1;
        }
      }
      return counts;
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      drawer: const AppDrawer(currentRoute: '/tags'),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const CreateTagDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: false,
            floating: true,
            snap: true,
            backgroundColor: Colors.grey[100],
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
            title: const Text('Tags'),
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
          ),

          // Tags list from Firestore
          tagsAsync.when(
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stack) => SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error: $error'),
                  ],
                ),
              ),
            ),
            data: (tags) {
              if (tags.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.label_outline, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No tags yet',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Tap + to create your first tag',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final tagCounts = getTagCounts();

              return SliverPadding(
                padding: const EdgeInsets.all(21),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index.isOdd) {
                        return const SizedBox(height: 12);
                      }
                      final tagIndex = index ~/ 2;
                      final tag = tags[tagIndex];

                      // Calculate colors from tag.color
                      final baseColor = Color(tag.color);
                      final bgColor = Color.alphaBlend(
                        baseColor.withValues(alpha: 0.15),
                        Colors.white,
                      );
                      final borderColor = Color.alphaBlend(
                        baseColor.withValues(alpha: 0.3),
                        Colors.white,
                      );

                      return TagCard(
                        tagId: tag.id,
                        tagName: tag.name,
                        noteCount: tagCounts[tag.id] ?? 0,
                        tagColor: baseColor,
                        tagBackgroundColor: bgColor,
                        tagBorderColor: borderColor,
                      );
                    },
                    childCount: tags.length * 2 - 1,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
