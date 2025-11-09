// 1. Переконайтесь, що ви імпортуєте саме 'splash_screen.dart'
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:ideanest/src/features/auth/presentation/screens/splash_screen.dart';
import 'package:ideanest/src/features/notes/presentation/screens/home_screen.dart';
import 'package:ideanest/src/features/tags/presentation/screens/tags_screen.dart';
import 'package:ideanest/src/features/settings/presentation/screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

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
      routes: {
        '/home': (context) => const HomeScreen(),
        '/tags': (context) => const TagsScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}