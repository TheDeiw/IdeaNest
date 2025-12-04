import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ideanest/src/features/settings/presentation/screens/faq_screen.dart';
import 'package:ideanest/src/features/settings/presentation/screens/change_password_screen.dart';
import 'package:ideanest/src/common/widgets/app_drawer.dart';
import 'package:ideanest/src/features/settings/application/user_profile_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isUploadingPhoto = false;

  Future<void> _pickAndUploadPhoto() async {
    print('📸 Starting photo picker...');

    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );

    if (image != null) {
      print('📸 Photo selected: ${image.path}');
      setState(() => _isUploadingPhoto = true);

      try {
        final file = File(image.path);
        print('📸 File size: ${await file.length()} bytes');

        print('📸 Calling updateProfilePhoto...');
        await ref.read(userProfileProvider.notifier).updateProfilePhoto(file);

        print('📸 Photo uploaded successfully!');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile photo updated!')),
          );
        }
      } catch (e, stackTrace) {
        print('❌ Error uploading photo: $e');
        print('❌ Stack trace: $stackTrace');

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
    } else {
      print('📸 No photo selected');
    }
  }

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
        backgroundColor: const Color(0xFFEAEAEA),
        elevation: 0,
        centerTitle: true,
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
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
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

              // Debug logging
              print('👤 Profile photoURL: $photoURL');
              print('👤 Profile object: ${profile?.toFirestore()}');

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
                                      image: (photoURL != null && photoURL.isNotEmpty)
                                          ? DecorationImage(
                                              image: NetworkImage(photoURL),
                                              fit: BoxFit.cover,
                                              onError: (error, stackTrace) {
                                                print('❌ Error loading image: $error');
                                              },
                                            )
                                          : null,
                                    ),
                                    child: (photoURL == null || photoURL.isEmpty)
                                        ? const Icon(Icons.person, color: Colors.white, size: 32)
                                        : null,
                                  ),
                                  if (_isUploadingPhoto)
                                    Positioned.fill(
                                      child: Container(
                                        decoration: const BoxDecoration(
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
                        Container(
                          height: 1,
                          color: const Color(0xFFCAC4D0),
                        ),
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
                  // Change Password Button
                  _buildActionButton(
                    icon: Icons.lock_outline,
                    label: 'Change password',
                    color: const Color(0xFF101828),
                    backgroundColor: Colors.grey[100]!,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ChangePasswordScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 19),
                  // FAQ Button
                  _buildActionButton(
                    icon: Icons.help_outline,
                    label: 'FAQ',
                    color: const Color(0xFF1447E6),
                    backgroundColor: const Color(0xFFDBEAFE),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const FAQScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 19),
                  // Leave Button with proper logout
                  _buildActionButton(
                    icon: Icons.logout,
                    label: 'Leave',
                    color: const Color(0xFFE7000B),
                    backgroundColor: const Color(0xFFFFE2E2),
                    onTap: () async {

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

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    VoidCallback? onEdit,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 20,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF364153),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF101828),
                ),
              ),
            ],
          ),
        ),
        if (onEdit != null)
          IconButton(
            icon: const Icon(Icons.edit, size: 16),
            onPressed: onEdit,
            color: Colors.grey[600],
          ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 16,
                    color: color,
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

