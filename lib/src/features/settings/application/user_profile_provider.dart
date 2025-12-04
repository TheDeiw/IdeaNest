import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ideanest/src/features/settings/domain/user_profile.dart';
import 'package:ideanest/src/features/settings/data/repositories/user_profile_repository.dart';
import 'package:ideanest/src/common/providers/repository_providers.dart';
import 'package:ideanest/src/common/services/storage_service.dart';

/// Provider for user profile with Firestore integration
final userProfileProvider = AsyncNotifierProvider<UserProfileNotifier, UserProfile?>(
  UserProfileNotifier.new,
);

/// Notifier for managing user profile with Firestore
class UserProfileNotifier extends AsyncNotifier<UserProfile?> {
  late UserProfileRepository _repository;

  @override
  Future<UserProfile?> build() async {
    _repository = ref.watch(userProfileRepositoryProvider);

    try {
      // Initialize user profile if it doesn't exist
      final profile = await _repository.initializeUserProfile();

      // Listen to profile stream
      _repository.watchUserProfile().listen((updatedProfile) {
        state = AsyncValue.data(updatedProfile);
      }, onError: (error) {
        state = AsyncValue.error(error, StackTrace.current);
      });

      return profile;
    } catch (e) {
      // If user is not authenticated, return null
      return null;
    }
  }

  /// Update display name
  Future<void> updateDisplayName(String displayName) async {
    try {
      await _repository.updateDisplayName(displayName);

      // Force refresh
      state = const AsyncValue.loading();
      final updatedProfile = await _repository.getUserProfile();
      state = AsyncValue.data(updatedProfile);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// Update profile photo
  Future<void> updateProfilePhoto(File imageFile) async {
    try {
      final storageService = StorageService();

      // Upload to Firebase Storage
      final photoURL = await storageService.uploadProfilePhoto(imageFile);

      if (photoURL != null) {
        // Update in Firestore
        await _repository.updatePhotoURL(photoURL);

        // Force refresh to get updated profile
        state = const AsyncValue.loading();
        final updatedProfile = await _repository.getUserProfile();
        state = AsyncValue.data(updatedProfile);
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// Remove profile photo
  Future<void> removeProfilePhoto() async {
    try {
      final storageService = StorageService();

      // Delete from Storage
      await storageService.deleteProfilePhoto();

      // Remove from Firestore
      await _repository.removePhotoURL();

      // Force refresh
      state = const AsyncValue.loading();
      final updatedProfile = await _repository.getUserProfile();
      state = AsyncValue.data(updatedProfile);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// Save complete user profile
  Future<void> saveProfile(UserProfile profile) async {
    try {
      await _repository.saveUserProfile(profile);
      await refresh();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// Refresh user profile from Firestore
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getUserProfile());
  }

  /// Delete user profile
  Future<void> deleteProfile() async {
    try {
      await _repository.deleteUserProfile();
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

