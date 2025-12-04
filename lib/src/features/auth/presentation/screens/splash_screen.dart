import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ideanest/src/features/auth/presentation/screens/login_screen.dart';
import 'package:ideanest/src/features/notes/presentation/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      // Wait a bit to show splash screen
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // User is logged in
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to initialize: $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _initialize();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              'assets/img/logo.png',
              height: 150,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.lightbulb_outline,
                  size: 100,
                  color: Colors.amber,
                );
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'IdeaNest',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Organize your thoughts',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}