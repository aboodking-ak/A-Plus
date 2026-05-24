import 'package:flutter/material.dart';
import '../../core/constants/app_assets.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  void initState() {
    super.initState();

  }

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
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                _buildHeader(primaryColor, secondaryColor),
                const SizedBox(height: 15),
                _buildForm(),
                const SizedBox(height: 8),
                _buildTermsCheckbox(secondaryColor),
                const SizedBox(height: 15),
                _buildSignUpButton(context, primaryColor),
                const SizedBox(height: 12),
                _buildDivider(),
                const SizedBox(height: 12),
                _buildSocialButtons(),
                const SizedBox(height: 30),
                _buildBottomLink(context, secondaryColor),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Color primaryColor, Color secondaryColor) {
    return Column(
      children: [
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
                AppAssets.logo,
                width: 120,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.school, size: 60, color: primaryColor),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "إنشاء حساب جديد",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor),
        ),
        Text(
          "ابدأ رحلتك التعليمية معنا",
          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        _buildTextField(hint: "الاسم الكامل", icon: Icons.person_outline),
        const SizedBox(height: 8),
        _buildTextField(hint: "البريد الإلكتروني", icon: Icons.email_outlined),
        const SizedBox(height: 8),
        _buildTextField(hint: "كلمة المرور", icon: Icons.lock_outline, isPassword: true),
        const SizedBox(height: 8),
        _buildTextField(hint: "تأكيد كلمة المرور", icon: Icons.lock_outline, isPassword: true),
      ],
    );
  }

  Widget _buildTextField({required String hint, required IconData icon, bool isPassword = false}) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFF1F3F5)),
      ),
      child: TextField(
        obscureText: isPassword,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
          prefixIcon: Icon(icon, color: Colors.grey[400], size: 18),
          suffixIcon: isPassword
              ? Icon(Icons.lock_outline, color: Colors.grey[400], size: 16)
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
        ),
      ),
    );
  }

  Widget _buildTermsCheckbox(Color secondaryColor) {
    return Row(
      children: [
        Checkbox(
          value: _agreeToTerms,
          activeColor: secondaryColor,
          onChanged: (v) => setState(() => _agreeToTerms = v!),
        ),
        const Expanded(
          child: Text.rich(
            TextSpan(
              text: "أوافق على ",
              style: TextStyle(fontSize: 11),
              children: [
                TextSpan(text: "الشروط والأحكام", style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: " و "),
                TextSpan(text: "سياسة الخصوصية", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpButton(BuildContext context, Color primaryColor) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        onPressed: () => Navigator.pushReplacementNamed(context, '/stages'),
        child: const Text("إنشاء حساب", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildDivider() {
    return const Row(
      children: [
        Expanded(child: Divider()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text("أو", style: TextStyle(color: Colors.grey, fontSize: 11)),
        ),
        Expanded(child: Divider()),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildSocialButton(
            label: "Google",
            iconPath: AppAssets.google,
            onTap: () {},
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildSocialButton(
            label: "Facebook",
            iconPath: AppAssets.facebook,
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton({required String label, required String iconPath, required VoidCallback onTap}) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFF1F3F5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A2238),
                ),
              ),
              Positioned(
                right: 12,
                child: Image.asset(
                  iconPath,
                  height: 22,
                  errorBuilder: (c, e, s) => const Icon(Icons.error_outline, size: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomLink(BuildContext context, Color secondaryColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("لديك حساب بالفعل؟ ", style: TextStyle(color: Colors.grey, fontSize: 13)),
        GestureDetector(
          onTap: () => Navigator.pushReplacementNamed(context, '/signin'),
          child: Text(
            "تسجيل الدخول",
            style: TextStyle(
                color: secondaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 13),
          ),
        ),
      ],
    );
  }
}