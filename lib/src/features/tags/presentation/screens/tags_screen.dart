import 'package:flutter/material.dart';
import 'package:ideanest/src/common/widgets/app_drawer.dart';
import 'package:ideanest/src/features/tags/presentation/screens/edit_tag_screen.dart';
import 'package:ideanest/src/features/tags/presentation/widgets/tag_card.dart';

class TagsScreen extends StatelessWidget {
  const TagsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Hardcoded data for demonstration
    final tags = [
            {
              'name': 'development',
              'count': 1,
              'color': const Color(0xFF372AAC),
              'bgColor': const Color(0xFFE0E7FF),
              'borderColor': const Color(0xFFC6D2FF)
            },
            {
              'name': 'health',
              'count': 1,
              'color': const Color(0xFF006045),
              'bgColor': const Color(0xFFD0FAE5),
              'borderColor': const Color(0xFFA4F4CF)
            },
            {
              'name': 'ideas',
              'count': 1,
              'color': const Color(0xFF894B00),
              'bgColor': const Color(0xFFFEF9C2),
              'borderColor': const Color(0xFFFFF085)
            },
            {
              'name': 'meeting',
              'count': 1,
              'color': const Color(0xFF6E11B0),
              'bgColor': const Color(0xFFF3E8FF),
              'borderColor': const Color(0xFFE9D4FF)
            },
            {
              'name': 'personal',
              'count': 4,
              'color': const Color(0xFF016630),
              'bgColor': const Color(0xFFD1FAE5),
              'borderColor': const Color(0xFFB9F8CF)
            },
            {
              'name': 'reading',
              'count': 1,
              'color': const Color(0xFF5D0EC0),
              'bgColor': const Color(0xFFEDE9FE),
              'borderColor': const Color(0xFFDDD6FF)
            },
            {
              'name': 'research',
              'count': 1,
              'color': const Color(0xFF005F5A),
              'bgColor': const Color(0xFFCBFBF1),
              'borderColor': const Color(0xFF96F7E4)
            },
            {
              'name': 'routine',
              'count': 1,
              'color': const Color(0xFF3C6300),
              'bgColor': const Color(0xFFECFCCA),
              'borderColor': const Color(0xFFD8F999)
            },
            {
              'name': 'shopping',
              'count': 1,
              'color': const Color(0xFFA3004C),
              'bgColor': const Color(0xFFFCE7F3),
              'borderColor': const Color(0xFFFCCEE8)
            },
            {
              'name': 'travel',
              'count': 1,
              'color': const Color(0xFF005F78),
              'bgColor': const Color(0xFFCEFAFE),
              'borderColor': const Color(0xFFA2F4FD)
            },
            {
              'name': 'weekend',
              'count': 1,
              'color': const Color(0xFF9F2D00),
              'bgColor': const Color(0xFFFFEDD4),
              'borderColor': const Color(0xFFFFD6A7)
            },
            {
              'name': 'work',
              'count': 1,
              'color': const Color(0xFF193CB8),
              'bgColor': const Color(0xFFDBEAFE),
              'borderColor': const Color(0xFFBEDBFF)
            },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      drawer: const AppDrawer(currentRoute: '/tags'),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const EditTagScreen(
              tagName: '',
              tagColor: Color(0xFF3B82F6),
              tagBackgroundColor: Color(0xFFDBEAFE),
              tagBorderColor: Color(0xFFBEDBFF),
            ),
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
                    // TODO: Profile action
                  },
                ),
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(21),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index.isOdd) {
                    return const SizedBox(height: 12);
                  }
                  final tagIndex = index ~/ 2;
                  final tag = tags[tagIndex];
                  return TagCard(
                    tagName: tag['name'] as String,
                    noteCount: tag['count'] as int,
                    tagColor: tag['color'] as Color,
                    tagBackgroundColor: tag['bgColor'] as Color,
                    tagBorderColor: tag['borderColor'] as Color,
                  );
                },
                childCount: tags.length * 2 - 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
