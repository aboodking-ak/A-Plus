import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_assets.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _saveLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', true);
    // في تطبيق حقيقي، سنقوم بحفظ البريد الإلكتروني والاسم القادم من السيرفر هنا
    if (prefs.getString('user_email') == null) {
      await prefs.setString('user_email', _emailController.text.trim());
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      await _saveLoginStatus();
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/stages');
      }
    }
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
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                const SizedBox(height: 20),
                _buildHeader(primaryColor, secondaryColor),
                const SizedBox(height: 30),
                _buildForm(),
                const SizedBox(height: 10),
                _buildForgotPassword(secondaryColor),
                const SizedBox(height: 25),
                _buildSignInButton(context, primaryColor),
                const SizedBox(height: 40),
                _buildBottomLink(context, secondaryColor),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    ));
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
          "تسجيل الدخول",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor),
        ),
        Text(
          "مرحباً بك مجدداً في رحلتك التعليمية",
          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        _buildTextField(
          controller: _emailController,
          hint: "البريد الإلكتروني",
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          height: 65, // زيادة الارتفاع لاستيعاب رسالة الخطأ
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "يرجى إدخال البريد الإلكتروني";
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return "يرجى إدخال بريد إلكتروني صحيح";
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _passwordController,
          hint: "كلمة المرور",
          icon: Icons.lock_outline,
          isPassword: true,
          height: 65,
          obscureText: _obscurePassword,
          onToggleVisibility: () => setState(() => _obscurePassword = !_obscurePassword),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "يرجى إدخال كلمة المرور";
            }
            if (value.length < 6) {
              return "يجب أن تكون كلمة المرور 6 أحرف على الأقل";
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    double height = 45,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    VoidCallback? onToggleVisibility,
  }) {
    return SizedBox(
      height: height,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
          prefixIcon: Icon(icon, color: Colors.grey[400], size: 18),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: Colors.grey[400],
                    size: 18,
                  ),
                  onPressed: onToggleVisibility,
                )
              : null,
          filled: true,
          fillColor: const Color(0xFFF8F9FA),
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFF1F3F5)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFF1F3F5)),
          ),
          errorStyle: const TextStyle(fontSize: 11, height: 0.8),
        ),
      ),
    );
  }

  void _showForgotPasswordDialog(BuildContext context, Color primaryColor) {
    final resetEmailController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.lock_reset_rounded, size: 50, color: primaryColor),
              ),
              const SizedBox(height: 20),
              const Text(
                "استعادة كلمة المرور",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                "أدخل بريدك الإلكتروني لتلقي رابط إعادة تعيين كلمة المرور الخاصة بك.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
              ),
              const SizedBox(height: 24),
              _buildTextField(
                controller: resetEmailController,
                hint: "البريد الإلكتروني",
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                height: 52,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    // هنا سيتم إضافة منطق Firebase لاحقاً
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("سيتم إرسال رابط إعادة التعيين إلى بريدك الإلكتروني"),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text("إرسال الرابط", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  minimumSize: const Size(double.infinity, 40),
                ),
                child: const Text("إلغاء", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPassword(Color secondaryColor) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () => _showForgotPasswordDialog(context, Theme.of(context).primaryColor),
        child: Text(
          "نسيت كلمة المرور؟",
          style: TextStyle(
              color: secondaryColor, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildSignInButton(BuildContext context, Color primaryColor) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        onPressed: _submit,
        child: const Text("تسجيل الدخول",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildBottomLink(BuildContext context, Color secondaryColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("ليس لديك حساب؟ ", style: TextStyle(color: Colors.grey, fontSize: 13)),
        GestureDetector(
          onTap: () => Navigator.pushReplacementNamed(context, '/signup'),
          child: Text(
            "إنشاء حساب جديد",
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