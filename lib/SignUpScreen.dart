import 'dart:async';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _agreeToTerms = false;

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

            SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 10), // تقليل المسافة العلوية
                      // اللوجو مصغر أكثر
                      Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 175,
                              height: 175,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey[100]!, width: 1),
                              ),
                            ),
                            SizedBox(
                              width: 175,
                              height: 175,
                              child: CircularProgressIndicator(
                                value: 0.35,
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
                              ),
                            ),
                            Image.asset(
                              'assets/icons/logo.png',
                              width: 120,
                              errorBuilder: (context, error, stackTrace) => Icon(Icons.school, size: 60, color: primaryColor),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "إنشاء حساب جديد",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor),
                      ),
                      Text(
                        "ابدأ رحلتك التعليمية معنا",
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                      const SizedBox(height: 15),

                      // حقول الإدخال مصغرة جداً (الارتفاع 38)
                      _buildTextField("الاسم الكامل", Icons.person_outline),
                      const SizedBox(height: 8),
                      _buildTextField("البريد الإلكتروني", Icons.email_outlined),
                      const SizedBox(height: 8),
                      _buildTextField("كلمة المرور", Icons.lock_outline, isPassword: true),
                      const SizedBox(height: 8),
                      _buildTextField("تأكيد كلمة المرور", Icons.lock_outline, isPassword: true),

                      const SizedBox(height: 8),
                      // شروط الاستخدام
                      Row(
                        children: [
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: Checkbox(
                              value: _agreeToTerms,
                              activeColor: secondaryColor,
                              onChanged: (v) => setState(() => _agreeToTerms = v!),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                text: "أوافق على ",
                                style: const TextStyle(fontSize: 11),
                                children: [
                                  TextSpan(text: "الشروط والأحكام", style: TextStyle(color: secondaryColor, fontWeight: FontWeight.bold)),
                                  const TextSpan(text: " و "),
                                  TextSpan(text: "سياسة الخصوصية", style: TextStyle(color: secondaryColor, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),
                      // زر إنشاء الحساب مصغر
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 0,
                          ),
                          child: const Text("إنشاء حساب", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                        ),
                      ),

                      const SizedBox(height: 12),
                      // فاصل "أو"
                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey[200])),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text("أو", style: TextStyle(color: Colors.grey[400], fontSize: 11)),
                          ),
                          Expanded(child: Divider(color: Colors.grey[200])),
                        ],
                      ),

                      const SizedBox(height: 12),
                      // أزرار جوجل وفيسبوك مصغرة
                      Row(
                        children: [
                          Expanded(child: _buildSocialButton("Google", "assets/icons/google.png")),
                          const SizedBox(width: 15),
                          Expanded(child: _buildSocialButton("Facebook", "assets/icons/facebook.png")),
                        ],
                      ),

                      const SizedBox(height: 20,), // استبدال Spacer بمسافة ثابتة
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("لديك حساب بالفعل؟ ", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                          Text("تسجيل الدخول", style: TextStyle(color: secondaryColor, fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, IconData icon, {bool isPassword = false}) {
    return Container(
      height: 45, // تم تصغير الارتفاع أكثر
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFF1F3F5)),
      ),
      child: TextField(
        obscureText: isPassword,
        style: const TextStyle(fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          prefixIcon: Icon(icon, color: Colors.grey[400], size: 18),
          suffixIcon: isPassword ? Icon(Icons.lock_outline, color: Colors.grey[400], size: 16) : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
        ),
      ),
    );
  }

  Widget _buildSocialButton(String label, String iconPath) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFF1F3F5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A2238),
                ),
              ),
              const SizedBox(width: 12),
              Image.asset(
                iconPath,
                height: 22,
                errorBuilder: (c, e, s) => const Icon(Icons.error_outline, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
