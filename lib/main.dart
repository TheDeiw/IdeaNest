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
      // Відключаємо банер "Debug" у кутку
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Ви можете налаштувати тему тут
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      // 2. Переконайтесь, що в 'home:' вказано саме SplashScreen()
      //    а НЕ MyHomePage(...) або щось інше.
      home: const SplashScreen(), // <-- НАЙВАЖЛИВІШИЙ РЯДОК
    );
  }
}