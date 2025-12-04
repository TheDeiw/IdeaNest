import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Upload profile photo and return download URL
  Future<String?> uploadProfilePhoto(File imageFile) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      print('☁️ Uploading to Firebase Storage for user: $userId');

      // Create reference to storage location
      final ref = _storage.ref().child('profile_photos/$userId');

      print('☁️ Storage path: profile_photos/$userId');

      // Upload file
      final uploadTask = await ref.putFile(
        imageFile,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      print('☁️ Upload complete. Getting download URL...');

      // Get download URL
      final downloadUrl = await ref.getDownloadURL();

      print('☁️ Download URL: $downloadUrl');

      return downloadUrl;
    } catch (e) {
      print('❌ Error uploading profile photo: $e');
      return null;
    }
  }

  /// Delete profile photo from storage
  Future<void> deleteProfilePhoto() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      final ref = _storage.ref().child('profile_photos/$userId.jpg');
      await ref.delete();
    } catch (e) {
      print('❌ Error deleting profile photo: $e');
    }
  }
}

