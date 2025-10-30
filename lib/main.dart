// 1. Переконайтесь, що ви імпортуєте саме 'splash_screen.dart'
import 'package:flutter/material.dart';
import 'package:ideanest/src/features/auth/presentation/screens/splash_screen.dart'; // <-- ВАЖЛИВИЙ РЯДОК

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IdeaNest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      home: const SplashScreen(),
    );
  }
}