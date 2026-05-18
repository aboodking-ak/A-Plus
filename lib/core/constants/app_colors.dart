import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF1A2238);
  static const Color secondary = Color(0xFFF5B82E);
  static const Color background = Color(0xFFFFFFFF);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Colors.grey;
  static const Color red = Colors.redAccent;
  
  // دالة مساعدة للحصول على الشفافية بنفس الأسلوب الجديد
  static Color withAlpha(Color color, int alpha) => color.withAlpha(alpha);
}
