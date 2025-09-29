// Імпортуємо бібліотеку Material, щоб отримати доступ до готових віджетів.
import 'package:flutter/material.dart';
import 'package:ideanest/src/features/auth/presentation/screens/login_screen.dart';

// Створюємо наш віджет для екрана.
// Він є StatefulWidget, тому що його стан (в нашому випадку, таймер) буде змінюватися.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  // Цей метод викликається один раз, коли віджет вперше з'являється на екрані.
  @override
  void initState() {
    super.initState();
    // Запускаємо таймер, який перенаправить нас на інший екран через 3 секунди.
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      // Navigator - це менеджер екранів у Flutter.
      // pushReplacement замінює поточний екран (SplashScreen) новим (LoginScreen).
      // Це означає, що користувач не зможе повернутися назад на екран завантаження.
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  // Метод build відповідає за те, як наш віджет буде виглядати.
  // Він "малює" інтерфейс.
  @override
  Widget build(BuildContext context) {
    // Scaffold - це базовий віджет для створення екрана в стилі Material.
    // Він дає нам білий фон, можливість додати верхню панель (AppBar) тощо.
    return Scaffold(
      // Center - це віджет, який центрує свого "нащадка" (child) по горизонталі та вертикалі.
      body: Center(
        // Column дозволяє розмістити декілька віджетів один під одним, вертикально.
        child: Column(
          // mainAxisAlignment - вирівнює віджети всередині Column.
          // .center - розміщує їх по центру.
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: Тут ми додамо ваше лого. Поки що використаємо стандартну іконку.
            const Icon(
              Icons.lightbulb_outline,
              size: 100,
              color: Colors.amber,
            ),
            // Робимо невеликий відступ між іконкою та індикатором завантаження.
            const SizedBox(height: 24),
            // А ось і наш індикатор завантаження з Material бібліотеки.
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}