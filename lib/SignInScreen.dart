import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
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
                      const SizedBox(height: 20),
                      // اللوجو
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
                        "تسجيل الدخول",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor),
                      ),
                      Text(
                        "مرحباً بك مجدداً في رحلتك التعليمية",
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                      const SizedBox(height: 30),

                      // حقول الإدخال
                      _buildTextField("البريد الإلكتروني", Icons.email_outlined),
                      const SizedBox(height: 12),
                      _buildTextField("كلمة المرور", Icons.lock_outline, isPassword: true),

                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "نسيت كلمة المرور؟",
                          style: TextStyle(color: secondaryColor, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),

                      const SizedBox(height: 25),
                      // زر تسجيل الدخول
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pushReplacementNamed(context, '/stages'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 0,
                          ),
                          child: const Text("تسجيل الدخول", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                        ),
                      ),

                      const SizedBox(height: 20),
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

                      const SizedBox(height: 20),
                      // أزرار جوجل وفيسبوك
                      Row(
                        children: [
                          Expanded(child: _buildSocialButton("Google", "assets/icons/google.png")),
                          const SizedBox(width: 15),
                          Expanded(child: _buildSocialButton("Facebook", "assets/icons/facebook.png")),
                        ],
                      ),

                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("ليس لديك حساب؟ ", style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                          GestureDetector(
                            onTap: () => Navigator.pushReplacementNamed(context, '/signup'),
                            child: Text(
                              "إنشاء حساب جديد",
                              style: TextStyle(color: secondaryColor, fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
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
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFF1F3F5)),
      ),
      child: TextField(
        obscureText: isPassword,
        style: const TextStyle(fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          prefixIcon: Icon(icon, color: Colors.grey[400], size: 20),
          suffixIcon: isPassword ? Icon(Icons.lock_outline, color: Colors.grey[400], size: 18) : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
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
