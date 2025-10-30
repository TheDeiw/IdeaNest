
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  // Older/basic icons: use built-in Icons or local raster assets in assets/img/
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
                  // Active button (Ideas)
                  InkWell(
                    borderRadius: BorderRadius.circular(28),
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 45,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0x80B4D3E1), // rgba(180,211,225,0.5)
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // basic/built-in icon (keeps visual weight similar to original)
                          const Icon(
                            Icons.lightbulb_outline,
                            size: 16,
                            color: Color(0xFF364153),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Ideas',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF364153),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Tags button
                  InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 42,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.tag_outlined,
                            size: 16,
                            color: Color(0xFF364153),
                          ),
                          const SizedBox(width: 20),
                          const Text(
                            'Tags',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF364153),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Simple divider matching the design stroke
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: const Color(0xFFCAC4D0), // close to design stroke
                  ),

                  const SizedBox(height: 16),

                  // Settings button
                  InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.settings_outlined,
                            size: 16,
                            color: Color(0xFF364153),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Settings',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF364153),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // small logo at bottom (optional)
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