import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAEAEA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEAEAEA),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'FAQ',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            _buildFAQCard(
              question: 'How do I create a new note?',
              answer:
                  'Tap the "+" button at the bottom right of the home screen to create a new note. You can add a title, content, and tags to organize your ideas.',
            ),
            const SizedBox(height: 16),
            _buildFAQCard(
              question: 'Can I add tags to my notes?',
              answer:
                  'Yes! When creating or editing a note, you can add custom tags to categorize and organize your notes. Tags help you quickly find related notes later.',
            ),
            const SizedBox(height: 16),
            _buildFAQCard(
              question: 'How do I search for notes?',
              answer:
                  'Use the search bar at the top of the home screen. You can search by title, content, or tags to quickly find the notes you need.',
            ),
            const SizedBox(height: 16),
            _buildFAQCard(
              question: 'How do I edit or delete a note?',
              answer:
                  'Tap on any note to open it. Once opened, you can edit the content directly. To delete a note, use the delete button in the note view.',
            ),
            const SizedBox(height: 16),
            _buildFAQCard(
              question: 'Can I change my password?',
              answer:
                  'Yes! Go to Settings and tap on "Change password". Follow the instructions to update your password securely.',
            ),
            const SizedBox(height: 16),
            _buildFAQCard(
              question: 'How do I sync my notes across devices?',
              answer:
                  'All your notes are automatically synced to the cloud when you\'re logged in. Simply sign in with the same account on another device to access all your notes.',
            ),
            const SizedBox(height: 16),
            _buildFAQCard(
              question: 'Is my data secure?',
              answer:
                  'Absolutely! We use industry-standard encryption to protect your data. Your notes are stored securely and only you have access to them.',
            ),
            const SizedBox(height: 16),
            _buildFAQCard(
              question: 'What are the different note views?',
              answer:
                  'The home screen displays your notes in a masonry grid layout, which adapts to different screen sizes. You can view note previews including title, content snippet, tags, and date.',
            ),
            const SizedBox(height: 16),
            _buildFAQCard(
              question: 'Can I organize notes into folders?',
              answer:
                  'Currently, you can use tags to organize your notes. We\'re working on adding folder support in a future update!',
            ),
            const SizedBox(height: 16),
            _buildFAQCard(
              question: 'How do I logout?',
              answer:
                  'Go to Settings and tap on the "Leave" button at the bottom of the screen. This will log you out of your account.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQCard({
    required String question,
    required String answer,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Theme(
        data: ThemeData(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          childrenPadding: const EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 20,
          ),
          title: Text(
            question,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF101828),
            ),
          ),
          iconColor: const Color(0xFF1447E6),
          collapsedIconColor: const Color(0xFF4A5565),
          children: [
            Text(
              answer,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF4A5565),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

