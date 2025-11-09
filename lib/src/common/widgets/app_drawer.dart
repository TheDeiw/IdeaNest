import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final String currentRoute;

  const AppDrawer({
    super.key,
    required this.currentRoute,
  });

  static const String _localLogo = 'assets/img/logo.png';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Container(
          width: 295,
          padding: const EdgeInsets.fromLTRB(20, 36, 20, 33),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'IdeaNest',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF101828),
                ),
              ),
              const SizedBox(height: 33),

              // Buttons column
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ideas button
                  _DrawerButton(
                    icon: Icons.lightbulb_outline,
                    label: 'Ideas',
                    isActive: currentRoute == '/home',
                    onTap: () {
                      if (currentRoute != '/home') {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/home',
                          (route) => false,
                        );
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),
                  const SizedBox(height: 8),

                  // Tags button
                  _DrawerButton(
                    icon: Icons.tag_outlined,
                    label: 'Tags',
                    isActive: currentRoute == '/tags',
                    onTap: () {
                      if (currentRoute != '/tags') {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/tags',
                          (route) => false,
                        );
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),

                  const SizedBox(height: 16),

                  // Simple divider matching the design stroke
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: const Color(0xFFCAC4D0),
                  ),

                  const SizedBox(height: 16),

                  // Settings button
                  _DrawerButton(
                    icon: Icons.settings_outlined,
                    label: 'Settings',
                    isActive: currentRoute == '/settings',
                    onTap: () {
                      if (currentRoute != '/settings') {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/settings',
                          (route) => false,
                        );
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),

              // small logo at bottom
              const Spacer(),
              SizedBox(
                width: 40,
                height: 40,
                child: Image.asset(
                  _localLogo,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _DrawerButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(isActive ? 28 : 14),
      onTap: onTap,
      child: Container(
        height: isActive ? 45 : 42,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? const Color(0x80B4D3E1) : Colors.transparent,
          borderRadius: BorderRadius.circular(isActive ? 28 : 14),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: const Color(0xFF364153),
            ),
            SizedBox(width: isActive ? 12 : 20),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF364153),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

