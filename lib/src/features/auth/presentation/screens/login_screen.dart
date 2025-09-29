import 'package:flutter/material.dart';
import 'package:ideanest/src/features/notes/presentation/screens/home_screen.dart';

// Поки що ми не будемо підключати екран реєстрації, тому залишаємо це коментарем.
// import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold - це наш базовий "холст" для екрана.
    return Scaffold(
      // SafeArea гарантує, що наш контент не залізе на системні елементи
      // (наприклад, "чубчик" на iPhone або статус-бар на Android).
      body: SafeArea(
        // SingleChildScrollView дозволяє екрану прокручуватися,
        // якщо контенту забагато (наприклад, коли з'являється клавіатура).
        child: SingleChildScrollView(
          // Padding додає відступи з усіх боків.
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center вирівнює все по центру вертикально.
              // crossAxisAlignment: CrossAxisAlignment.stretch розтягує дочірні елементи по ширині.
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Відступ зверху
                const SizedBox(height: 80),

                // Наше зображення, яке ми додали як асет.
                Image.asset(
                  'assets/img/logo.png',
                  height: 150, // Можна задати висоту, щоб воно не було завеликим.
                ),
                const SizedBox(height: 48),

                // Заголовок "Welcome Back"
                const Text(
                  'Welcome Back',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Підзаголовок
                Text(
                  'Sign in to access your ideas',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 40),

                // Поле для вводу email
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Enter email or name',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Поле для вводу пароля
                TextField(
                  obscureText: true, // Приховує текст (для паролів)
                  decoration: InputDecoration(
                    labelText: 'Enter password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: const Icon(Icons.visibility_off_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Кнопка Sign In
                ElevatedButton(
                  onPressed: () {
                    // Логіка буде тут пізніше. Поки що кнопка просто натискається.
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                          (Route<dynamic> route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: const Color(0xFF3A425F), // Приблизний колір з макета
                  ),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 24),

                // Текст для переходу на екран реєстрації
                Text.rich(
                  TextSpan(
                    text: "Don't have an account? ",
                    style: TextStyle(color: Colors.grey[600]),
                    children: [
                      TextSpan(
                        text: 'Sign Up',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.bold,
                        ),
                        // Тут ми додамо навігацію пізніше
                        // recognizer: TapGestureRecognizer()..onTap = () { ... }
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}