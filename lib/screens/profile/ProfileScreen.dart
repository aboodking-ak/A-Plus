import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = "الطالب";
  String userEmail = "user@email.com";
  String? _profileImagePath;
  String selectedStage = "غير محدد";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString('user_name');
    final savedEmail = prefs.getString('user_email');
    final savedImagePath = prefs.getString('profile_image_path');
    final savedStage = prefs.getString('user_stage'); // Assuming this exists or passed
    
    if (mounted) {
      setState(() {
        if (savedName != null && savedName.isNotEmpty) {
          userName = savedName;
        }
        userEmail = savedEmail ?? "user@email.com";
        _profileImagePath = savedImagePath;
        selectedStage = savedStage ?? "غير محدد";
      });
    }
  }

  String _getInitials(String name) {
    if (name.isEmpty) return "S";
    return name.trim().substring(0, 1).toUpperCase();
  }

  Future<void> _editNameDialog() async {
    final TextEditingController nameController = TextEditingController(text: userName);
    final primaryColor = Theme.of(context).colorScheme.primary;

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
                  color: primaryColor.withAlpha(25),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.edit_note_rounded, size: 40, color: primaryColor),
              ),
              const SizedBox(height: 20),
              const Text(
                "تعديل الاسم",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  hintText: "أدخل اسمك الجديد",
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("إلغاء", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final newName = nameController.text.trim();
                        if (newName.isNotEmpty) {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString('user_name', newName);
                          setState(() {
                            userName = newName;
                          });
                          if (mounted) Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text("حفظ", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 2000,
        maxHeight: 2000,
        imageQuality: 100,
      );
      
      if (image != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('profile_image_path', image.path);
        setState(() {
          _profileImagePath = image.path;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("تم تحديث الصورة الشخصية بنجاح")),
          );
        }
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("فشل الوصول إلى المعرض، يرجى منح الإذن من إعدادات الهاتف")),
        );
      }
    }
  }

  void _showFullImageDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          alignment: Alignment.center,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black87,
              ),
            ),
            Hero(
              tag: 'profile_pic',
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: _profileImagePath != null
                    ? DecorationImage(image: FileImage(File(_profileImagePath!)), fit: BoxFit.cover)
                    : null,
                  color: Theme.of(context).colorScheme.primary.withAlpha(25),
                ),
                child: _profileImagePath == null
                    ? Center(
                        child: Text(
                          _getInitials(userName),
                          style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      )
                    : null,
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.white, size: 35),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            if (_profileImagePath != null)
              Positioned(
                top: 40,
                left: 20,
                child: IconButton(
                  icon: const Icon(Icons.delete_forever_rounded, color: Colors.redAccent, size: 35),
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('profile_image_path');
                    setState(() {
                      _profileImagePath = null;
                    });
                    if (mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("تم حذف الصورة الشخصية")),
                      );
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
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
                  color: Colors.redAccent.withAlpha(25),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.logout_rounded, size: 50, color: Colors.redAccent),
              ),
              const SizedBox(height: 20),
              const Text(
                "تسجيل الخروج",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                "هل أنت متأكد من رغبتك في تسجيل الخروج؟",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("إلغاء", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('is_logged_in', false);
                        if (context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(context, '/signin', (route) => false);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text("خروج", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
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
                  color: Colors.red.withAlpha(25),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.delete_forever_rounded, size: 50, color: Colors.red),
              ),
              const SizedBox(height: 20),
              const Text(
                "حذف الحساب نهائياً",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
              ),
              const SizedBox(height: 12),
              const Text(
                "سيؤدي هذا الإجراء إلى حذف كافة بياناتك وملاحظاتك ولا يمكن التراجع عنه. هل أنت متأكد؟",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("تراجع", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.clear(); // حذف كافة البيانات (الاسم، الإيميل، الصورة، حالة الدخول)
                        if (context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(context, '/signup', (route) => false);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text("حذف الآن", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("الملف الشخصي", style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Center(
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: _showFullImageDialog,
                              child: Hero(
                                tag: 'profile_pic',
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundColor: secondaryColor.withAlpha(25),
                                  backgroundImage: _profileImagePath != null ? FileImage(File(_profileImagePath!)) : null,
                                  child: _profileImagePath == null
                                      ? Text(
                                          _getInitials(userName),
                                          style: TextStyle(
                                              fontSize: 40,
                                              fontWeight: FontWeight.bold,
                                              color: primaryColor),
                                        )
                                      : null,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 5,
                              right: 5,
                              child: GestureDetector(
                                onTap: _pickImage,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withAlpha(40),
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(Icons.camera_alt_outlined, color: primaryColor, size: 20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      InkWell(
                        onTap: _editNameDialog,
                        borderRadius: BorderRadius.circular(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildProfileData("الاسم الكامل", userName, primaryColor),
                            Icon(Icons.edit_note_rounded, color: secondaryColor, size: 24),
                          ],
                        ),
                      ),
                      const Divider(height: 30),
                      _buildProfileData("البريد الإلكتروني", userEmail, primaryColor),
                      const Divider(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildProfileData("المرحلة الدراسية والفرع", selectedStage, primaryColor),
                          TextButton.icon(
                            onPressed: () => Navigator.pushNamed(context, '/stages'),
                            icon: Icon(Icons.edit_note_rounded, color: secondaryColor, size: 20),
                            label: Text("تبديل",
                                style: TextStyle(color: secondaryColor, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const Divider(height: 30),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withAlpha(50),
                                blurRadius: 5,
                                offset: const Offset(0, 0)),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _showLogoutDialog(context),
                            borderRadius: BorderRadius.circular(15),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: Center(
                                child: Text("تسجيل الخروج",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.redAccent,
                                        fontSize: 16)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withAlpha(50),
                              blurRadius: 5,
                              offset: const Offset(0, 0)),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _showDeleteAccountDialog(context),
                          borderRadius: BorderRadius.circular(15),
                          child: const Padding(
                            padding: EdgeInsets.all(15),
                            child: Icon(Icons.delete_outline_rounded,
                                color: Colors.white, size: 24),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileData(String hint, String value, Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(hint, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor)),
      ],
    );
  }
}
