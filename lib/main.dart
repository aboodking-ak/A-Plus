import 'package:flutter/material.dart';
import 'SplashScreen.dart';
import 'SignUpScreen.dart';
import 'SignInScreen.dart';
import 'StagesScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'A Plus',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Tajawal',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A2238),
          primary: const Color(0xFF1A2238),
          secondary: const Color(0xFFF5B82E),
          surface: const Color(0xFFFFFFFF),
        ),
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A2238),
          foregroundColor: Color(0xFFFFFFFF),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/signin': (context) => const SignInScreen(),
        '/stages': (context) => const StagesScreen(),
      },
    );
  }
}
