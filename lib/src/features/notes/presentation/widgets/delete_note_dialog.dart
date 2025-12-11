import 'package:flutter/material.dart';

class DeleteNoteDialog extends StatelessWidget {
  final String noteTitle;

  const DeleteNoteDialog({
    super.key,
    required this.noteTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      backgroundColor: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: const Color(0xFFD1D5DC),
            width: 1.028,
          ),
        ),
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header section
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title
                const Text(
                  'Delete Note?',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1D1B20),
                    height: 28 / 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                // Description
                Text(
                  'This action cannot be undone. The note "$noteTitle" will be permanently deleted.',
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF4A5565),
                    height: 20 / 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Buttons section
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Cancel button
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(
                      color: Color(0xFFD1D5DC),
                      width: 1.028,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 17.028,
                      vertical: 9.028,
                    ),
                    minimumSize: const Size(0, 36),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1D1B20),
                      height: 20 / 14,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Delete button
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE7000B),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    minimumSize: const Size(0, 36),
                  ),
                  child: const Text(
                    'Delete',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      height: 20 / 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Show the delete note dialog and return true if user confirms deletion
  static Future<bool?> show(BuildContext context, String noteTitle) {
    return showDialog<bool>(
      context: context,
      builder: (context) => DeleteNoteDialog(noteTitle: noteTitle),
    );
  }
}

