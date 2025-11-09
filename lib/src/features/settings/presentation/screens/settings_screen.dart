import 'package:flutter/material.dart';
import 'package:ideanest/src/features/settings/presentation/screens/faq_screen.dart';
import 'package:ideanest/src/common/widgets/app_drawer.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          child: Column(
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
                          decoration: const BoxDecoration(
                            color: Color(0xFF101828),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 32,
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
                    // Full Name
                    _buildInfoRow(
                      icon: Icons.person_outline,
                      label: 'Full Name',
                      value: 'Alex Johnson',
                      onEdit: () {},
                    ),
                    const SizedBox(height: 16),
                    // Email
                    _buildInfoRow(
                      icon: Icons.email_outlined,
                      label: 'Email Address',
                      value: 'alex.johnson@example.com',
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
                  // TODO: Navigate to change password
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
              // Leave Button
              _buildActionButton(
                icon: Icons.logout,
                label: 'Leave',
                color: const Color(0xFFE7000B),
                backgroundColor: const Color(0xFFFFE2E2),
                onTap: () {
                  // TODO: Logout logic
                },
              ),
            ],
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

