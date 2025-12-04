# Feature Implementation Plan

## Overview
This plan outlines the implementation of several key features for the IdeaNest application:
1. Display and edit user name in Settings (from Firebase)
2. Remember login state (stay logged in)
3. Ensure no hardcoded tags (already done, verify)
4. Firebase Storage integration for profile photos
5. Remove temporary markdown files
6. Text formatting functionality in notes

## Prerequisites

### Add Required Packages to pubspec.yaml

Add these dependencies after `cloud_firestore: ^6.1.0`:

```yaml
dependencies:
  # ...existing dependencies...
  firebase_storage: ^12.3.0
  image_picker: ^1.0.7
  shared_preferences: ^2.2.2
```

Then run:
```bash
flutter pub get
```

---

## Task 1: User Name in Settings (Edit Functionality)

### 1.1 Update UserProfile Model

**File:** `lib/src/features/settings/domain/user_profile.dart`

Add `photoURL` field and update methods:

```dart
class UserProfile {
  final String id;
  final String email;
  final String displayName;
  final String? photoURL;  // ADD THIS
  final DateTime createdAt;

  UserProfile({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoURL,  // ADD THIS
    required this.createdAt,
  });

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      id: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      photoURL: data['photoURL'],  // ADD THIS
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,  // ADD THIS
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  UserProfile copyWith({
    String? displayName,
    String? photoURL,  // ADD THIS
  }) {
    return UserProfile(
      id: id,
      email: email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,  // ADD THIS
      createdAt: createdAt,
    );
  }
}
```

### 1.2 Update Settings Screen

**File:** `lib/src/features/settings/presentation/screens/settings_screen.dart`

Convert to ConsumerStatefulWidget and implement name editing:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ideanest/src/features/settings/presentation/screens/faq_screen.dart';
import 'package:ideanest/src/common/widgets/app_drawer.dart';
import 'package:ideanest/src/features/settings/application/user_profile_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  
  Future<void> _editDisplayName() async {
    final controller = TextEditingController();
    final profileAsync = ref.read(userProfileProvider);
    
    if (profileAsync.value != null) {
      controller.text = profileAsync.value!.displayName;
    }

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Name'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Full Name',
            hintText: 'Enter your name',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result != null && result.trim().isNotEmpty) {
      try {
        await ref.read(userProfileProvider.notifier).updateDisplayName(result.trim());
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Name updated successfully!')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFEAEAEA),
      drawer: const AppDrawer(currentRoute: '/settings'),
      appBar: AppBar(
        // ...existing appBar code...
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: profileAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Error: $err')),
            data: (profile) {
              final displayName = profile?.displayName ?? 'User';
              final email = profile?.email ?? FirebaseAuth.instance.currentUser?.email ?? '';
              final photoURL = profile?.photoURL;

              return Column(
                children: [
                  // Account Info Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: Colors.grey[200]!, width: 1),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                    child: Column(
                      children: [
                        // User Avatar and Info
                        Row(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: const Color(0xFF101828),
                                shape: BoxShape.circle,
                                image: photoURL != null
                                    ? DecorationImage(
                                        image: NetworkImage(photoURL),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: photoURL == null
                                  ? const Icon(Icons.person, color: Colors.white, size: 32)
                                  : null,
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Your Account',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF101828),
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Manage your account settings',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF4A5565),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Container(height: 1, color: const Color(0xFFCAC4D0)),
                        const SizedBox(height: 24),
                        // Full Name - NOW EDITABLE
                        _buildInfoRow(
                          icon: Icons.person_outline,
                          label: 'Full Name',
                          value: displayName,
                          onEdit: _editDisplayName,
                        ),
                        const SizedBox(height: 16),
                        // Email - READ ONLY
                        _buildInfoRow(
                          icon: Icons.email_outlined,
                          label: 'Email Address',
                          value: email,
                          onEdit: null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 19),
                  // ...existing action buttons...
                  // Leave Button with proper logout
                  _buildActionButton(
                    icon: Icons.logout,
                    label: 'Leave',
                    color: const Color(0xFFE7000B),
                    backgroundColor: const Color(0xFFFFE2E2),
                    onTap: () async {
                      // Clear stay logged in preference
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('stay_logged_in', false);
                      
                      // Sign out from Firebase
                      await FirebaseAuth.instance.signOut();
                      
                      // Navigate to login
                      if (mounted) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/login',
                          (route) => false,
                        );
                      }
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // ...existing _buildInfoRow and _buildActionButton methods...
}
```

### 1.3 Update Signup Screen to Save Name

**File:** `lib/src/features/auth/presentation/screens/signup_screen.dart`

After creating user account, save the display name:

```dart
// In _signUp method after user creation:
if (userCredential.user != null) {
  // Trigger profile initialization
  ref.invalidate(userProfileProvider);
  
  // Wait a bit for profile to be created
  await Future.delayed(const Duration(milliseconds: 500));
  
  // Update display name if provided
  if (_nameController.text.trim().isNotEmpty) {
    await ref.read(userProfileProvider.notifier).updateDisplayName(
      _nameController.text.trim(),
    );
  }
}
```

---

## Task 2: Remember Login State (Stay Logged In)

### 2.1 Update Login Screen

**File:** `lib/src/features/auth/presentation/screens/login_screen.dart`

Add "Remember me" checkbox:

```dart
class _LoginScreenState extends ConsumerState<LoginScreen> {
  // ...existing fields...
  bool _rememberMe = true; // Default to true for better UX

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ...existing code...
      body: Form(
        // ...existing form fields...
        
        // ADD THIS BEFORE THE LOGIN BUTTON:
        CheckboxListTile(
          title: const Text('Remember me'),
          value: _rememberMe,
          onChanged: (value) {
            setState(() {
              _rememberMe = value ?? false;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
        
        // ...login button...
      ),
    );
  }

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Save "remember me" preference
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('stay_logged_in', _rememberMe);

        // Initialize profile
        ref.invalidate(userProfileProvider);

        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      } catch (e) {
        // ...error handling...
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }
}
```

### 2.2 Update Splash Screen

**File:** `lib/src/features/auth/presentation/screens/splash_screen.dart`

Check "stay logged in" preference:

```dart
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _initialize() async {
  try {
    await Future.delayed(const Duration(seconds: 1));
    
    if (!mounted) return;
    
    final user = FirebaseAuth.instance.currentUser;
    final prefs = await SharedPreferences.getInstance();
    final stayLoggedIn = prefs.getBool('stay_logged_in') ?? false;
    
    if (user != null && stayLoggedIn) {
      // User is logged in and wants to stay logged in
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      // Sign out if user doesn't want to stay logged in
      if (user != null && !stayLoggedIn) {
        await FirebaseAuth.instance.signOut();
      }
      
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  } catch (e) {
    // ...error handling...
  }
}
```

### 2.3 Update Signup Screen

**File:** `lib/src/features/auth/presentation/screens/signup_screen.dart`

Set "stay logged in" to true by default for new users:

```dart
// After successful signup:
final prefs = await SharedPreferences.getInstance();
await prefs.setBool('stay_logged_in', true); // Auto-enable for new users
```

---

## Task 3: Verify No Hardcoded Tags

### 3.1 Verify TagsProvider

**File:** `lib/src/features/tags/application/tags_provider.dart`

Ensure the build method does NOT call `initializeDefaultTags()`:

```dart
@override
Future<List<Tag>> build() async {
  _repository = ref.watch(tagsRepositoryProvider);
  
  // NO automatic initialization - should be empty
  return _repository.getTags();
}
```

### 3.2 Test with New Account

1. Create a new user account
2. Verify that no tags appear in the AddTagDialog
3. Create a tag manually
4. Verify it saves to Firestore under `users/{userId}/tags/`

**Expected behavior:** New users start with ZERO tags.

---

## Task 4: Firebase Storage for Profile Photos

### 4.1 Create StorageService

**File:** `lib/src/common/services/storage_service.dart`

```dart
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

      // Create reference to storage location
      final ref = _storage.ref().child('profile_photos/$userId.jpg');
      
      // Upload file
      await ref.putFile(
        imageFile,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      // Get download URL
      final downloadUrl = await ref.getDownloadURL();
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
```

### 4.2 Update UserProfileRepository

**File:** `lib/src/features/settings/data/repositories/user_profile_repository.dart`

Add methods for photo URL:

```dart
/// Update profile photo URL
Future<void> updatePhotoURL(String photoURL) async {
  final userId = _auth.currentUser?.uid;
  if (userId == null) throw Exception('User not authenticated');

  await _firestore.collection('users').doc(userId).update({
    'photoURL': photoURL,
  });
}

/// Remove profile photo URL
Future<void> removePhotoURL() async {
  final userId = _auth.currentUser?.uid;
  if (userId == null) throw Exception('User not authenticated');

  await _firestore.collection('users').doc(userId).update({
    'photoURL': FieldValue.delete(),
  });
}
```

### 4.3 Update UserProfileProvider

**File:** `lib/src/features/settings/application/user_profile_provider.dart`

Add methods for photo management:

```dart
import 'dart:io';
import 'package:ideanest/src/common/services/storage_service.dart';

/// Update profile photo
Future<void> updateProfilePhoto(File imageFile) async {
  try {
    final storageService = StorageService();
    
    // Upload to Firebase Storage
    final photoURL = await storageService.uploadProfilePhoto(imageFile);
    
    if (photoURL != null) {
      // Update in Firestore
      await _repository.updatePhotoURL(photoURL);
      
      // Refresh provider state
      ref.invalidateSelf();
      await future;
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
    
    // Refresh provider state
    ref.invalidateSelf();
    await future;
  } catch (e) {
    state = AsyncValue.error(e, StackTrace.current);
  }
}
```

### 4.4 Update Settings Screen for Photo Upload

**File:** `lib/src/features/settings/presentation/screens/settings_screen.dart`

Add image picker functionality:

```dart
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isUploadingPhoto = false;

  Future<void> _pickAndUploadPhoto() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() => _isUploadingPhoto = true);
      
      try {
        final file = File(image.path);
        await ref.read(userProfileProvider.notifier).updateProfilePhoto(file);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile photo updated!')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isUploadingPhoto = false);
        }
      }
    }
  }

  // In build method, update avatar:
  GestureDetector(
    onTap: _pickAndUploadPhoto,
    child: Stack(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0xFF101828),
            shape: BoxShape.circle,
            image: photoURL != null
                ? DecorationImage(
                    image: NetworkImage(photoURL),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: photoURL == null
              ? const Icon(Icons.person, color: Colors.white, size: 32)
              : null,
        ),
        if (_isUploadingPhoto)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              ),
            ),
          ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.camera_alt,
              size: 12,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
  ),
}
```

---

## Task 5: Remove Temporary Markdown Files

Delete these files from project root (keep only README.md):

```
UPDATED_STRUCTURE.md
TODO_CHECKLIST.md
USAGE_GUIDE.md
FIRESTORE_FIX_NOW.md
FIRESTORE_PERMISSION_FIX.md
IMPLEMENTATION_SUMMARY.md
FIREBASE_SETUP_GUIDE.md
CRUD_IMPLEMENTATION_COMPLETE.md
COMPLETION_SUMMARY.md
Black_Screen_Fixed.md
All_Errors_Fixed.md
Tags_Fixed_Summary.md
Signup_Fixed.md
Color_Diagnostic.md
Diagnostic_Step1.md
Restart_Instructions.md
Black_Screen_Final_Fix.md
DO_THIS_NOW.md
Quick_Permission_Fix.md
Firestore_Permission_Complete_Fix.md
All_Colors_Removed.md
Tags_Final_Fix.md
Splash_Screen_Fixed.md
```

**Command (PowerShell):**
```powershell
Remove-Item *.md -Exclude README.md
```

---

## Task 6: Text Formatting in Notes (Optional - Complex Feature)

### Option A: Use flutter_quill Package

**Add to pubspec.yaml:**
```yaml
dependencies:
  flutter_quill: ^9.0.0
```

### 6.1 Update Note Model

**File:** `lib/src/features/notes/domain/note.dart`

Change content storage to support rich text:

```dart
class Note {
  // ...existing fields...
  final String content; // Store as JSON string from Quill
  
  // Add helper to convert to/from Quill Delta
  Map<String, dynamic> getContentAsDelta() {
    try {
      return jsonDecode(content);
    } catch (_) {
      // Fallback for plain text
      return {
        'ops': [{'insert': content}]
      };
    }
  }
}
```

### 6.2 Update NoteEditScreen

**File:** `lib/src/features/notes/presentation/screens/note_edit_screen.dart`

Replace TextField with Quill editor:

```dart
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'dart:convert';

class _NoteEditScreenState extends ConsumerState<NoteEditScreen> {
  late quill.QuillController _quillController;

  @override
  void initState() {
    super.initState();
    
    // Initialize with existing content or empty
    if (widget.initialContent != null && widget.initialContent!.isNotEmpty) {
      try {
        final doc = quill.Document.fromJson(jsonDecode(widget.initialContent!));
        _quillController = quill.QuillController(
          document: doc,
          selection: const TextSelection.collapsed(offset: 0),
        );
      } catch (_) {
        // Fallback for plain text
        _quillController = quill.QuillController.basic();
        _quillController.document.insert(0, widget.initialContent!);
      }
    } else {
      _quillController = quill.QuillController.basic();
    }
  }

  @override
  void dispose() {
    _quillController.dispose();
    super.dispose();
  }

  String _getContentAsJson() {
    return jsonEncode(_quillController.document.toDelta().toJson());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ...existing code...
      body: Column(
        children: [
          // Title field (keep as is)
          TextField(
            controller: _titleController,
            // ...
          ),
          
          // Quill Toolbar
          quill.QuillToolbar.simple(
            configurations: quill.QuillSimpleToolbarConfigurations(
              controller: _quillController,
              multiRowsDisplay: false,
              showBoldButton: true,
              showItalicButton: true,
              showUnderLineButton: true,
              showStrikeThrough: false,
              showListBullets: true,
              showListNumbers: true,
              showCodeBlock: false,
              showQuote: false,
            ),
          ),
          
          // Quill Editor
          Expanded(
            child: quill.QuillEditor.basic(
              configurations: quill.QuillEditorConfigurations(
                controller: _quillController,
                readOnly: false,
                placeholder: 'Start writing your note...',
              ),
            ),
          ),
        ],
      ),
      
      // Update save method:
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final content = _getContentAsJson();
          await _handleSave(content);
        },
      ),
    );
  }
}
```

### Option B: Simple Markdown-style Formatting (Easier)

Keep plain text but add buttons for simple formatting:

```dart
// Add formatting buttons
Row(
  children: [
    IconButton(
      icon: const Icon(Icons.format_bold),
      onPressed: () => _wrapSelection('**', '**'),
    ),
    IconButton(
      icon: const Icon(Icons.format_italic),
      onPressed: () => _wrapSelection('*', '*'),
    ),
    IconButton(
      icon: const Icon(Icons.format_list_bulleted),
      onPressed: () => _addBulletPoint(),
    ),
  ],
)

void _wrapSelection(String prefix, String suffix) {
  final selection = _contentController.selection;
  if (selection.isValid) {
    final text = _contentController.text;
    final selectedText = text.substring(selection.start, selection.end);
    final newText = text.substring(0, selection.start) +
        prefix + selectedText + suffix +
        text.substring(selection.end);
    _contentController.text = newText;
    _contentController.selection = TextSelection(
      baseOffset: selection.start + prefix.length,
      extentOffset: selection.end + prefix.length,
    );
  }
}
```

---

## Implementation Order

1. **First:** Add packages to pubspec.yaml and run `flutter pub get`
2. **Second:** Update UserProfile model (Task 1.1)
3. **Third:** Implement "Remember me" functionality (Task 2)
4. **Fourth:** Update Settings screen with name editing (Task 1.2)
5. **Fifth:** Implement Firebase Storage for photos (Task 4)
6. **Sixth:** Clean up markdown files (Task 5)
7. **Seventh:** (Optional) Add text formatting (Task 6)

---

## Testing Checklist

### After Implementation:

- [ ] Create new account - verify name is saved
- [ ] Edit name in Settings - verify it updates in Firestore
- [ ] Login with "Remember me" checked - verify stays logged in after restart
- [ ] Login without "Remember me" - verify requires login after restart
- [ ] Upload profile photo - verify it appears in Settings and saves to Storage
- [ ] Create new account - verify NO default tags exist
- [ ] Create tag manually - verify it saves to Firestore
- [ ] Logout - verify clears "remember me" preference
- [ ] All markdown files removed except README.md
- [ ] (If implemented) Text formatting works in notes

---

## Firebase Console Setup

### Enable Firebase Storage:

1. Go to Firebase Console: https://console.firebase.google.com/project/ideanest-2026
2. Click "Storage" in left menu
3. Click "Get Started"
4. Choose "Start in production mode" (we'll use Security Rules)
5. Click "Done"

### Storage Security Rules:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /profile_photos/{userId}.jpg {
      // Allow read to anyone, write only to owner
      allow read: if true;
      allow write: if request.auth != null && request.auth.uid == userId;
      allow delete: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

---

## Notes

- Profile photos are stored as `profile_photos/{userId}.jpg` in Firebase Storage
- photoURL is stored in user document in Firestore
- "Remember me" preference stored in SharedPreferences as `stay_logged_in`
- Text formatting with flutter_quill is complex - consider starting with basic implementation
- All temporary markdown files should be deleted to clean up project

---

## Potential Issues & Solutions

### Issue: Image picker not working on iOS
**Solution:** Add to Info.plist:
```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>We need access to your photos to set profile picture</string>
<key>NSCameraUsageDescription</key>
<string>We need access to your camera to take profile picture</string>
```

### Issue: Image picker not working on Android
**Solution:** Add to AndroidManifest.xml:
```xml
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.CAMERA"/>
```

### Issue: SharedPreferences not persisting
**Solution:** Ensure you await the setBool call:
```dart
await prefs.setBool('stay_logged_in', true);
```

### Issue: Photo upload fails
**Solution:** Check Firebase Storage rules and ensure user is authenticated

---

## End of Plan

This plan covers all requested features with detailed implementation steps. Follow the implementation order for best results.

