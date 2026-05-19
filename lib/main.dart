import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/splash/SplashScreen.dart';
import 'screens/auth/SignUpScreen.dart';
import 'screens/auth/SignInScreen.dart';
import 'screens/stages/StagesScreen.dart';
import 'screens/home/HomePageScreen.dart';
import 'screens/pdf/pdf_viewer_screen.dart';

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
      theme: AppTheme.lightTheme,
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/signin': (context) => const SignInScreen(),
        '/stages': (context) => const StagesScreen(),
        '/home': (context) => const HomePageScreen(),
        '/pdf_viewer': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return PdfViewerScreen(
            title: args['title'],
            pdfPath: args['pdfPath'],
          );
        },
      },
    );
  }
}
