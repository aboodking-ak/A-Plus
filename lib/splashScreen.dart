import 'dart:async' show Timer;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // إخفاء شريط الإشعارات
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    Timer(const Duration(seconds: 3), () {
    });
  }

  @override
  void dispose() {
    // إعادة إظهار شريط الإشعارات عند الخروج من الشاشة
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // الأشكال الخلفية - الزاوية العلوية اليسرى
            Positioned(
              top: -50,
              left: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(200),
                  ),
                ),
              ),
            ),
            // الأشكال الخلفية - الزاوية السفلية اليمنى
            Positioned(
              bottom: -50,
              right: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(200),
                  ),
                ),
              ),
            ),
            // دوائر تزيينية
            Positioned(
              top: 80,
              right: 80,
              child: _buildDot(secondaryColor, 15),
            ),
            Positioned(
              bottom: 200,
              right: 40,
              child: _buildDot(secondaryColor, 12),
            ),
            Positioned(
              bottom: 350,
              left: 30,
              child: _buildDot(primaryColor.withAlpha(230), 20),
            ),

            // المحتوى المركزي
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // الشعار مع الدائرة
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: secondaryColor.withAlpha(100),
                            width: 2,
                          ),
                        ),
                      ),
                      // الدائرة البرتقالية المحيطة بالشعار (جزء منها)
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: CircularProgressIndicator(
                          value: 0.7,
                          strokeWidth: 4,
                          valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
                        ),
                      ),
                      Image.asset(
                        'assets/icons/logo.png',
                        width: 125,
                        height: 125,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.school,
                          size: 100,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  // النصوص
                  Text(
                    "تعلم بذكاء، تقدم بثقة",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "كل ما تحتاجه لتتفوق في مكان واحد",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 60),
                  // شريط التحميل
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            minHeight: 8,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "جاري التحميل...",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
