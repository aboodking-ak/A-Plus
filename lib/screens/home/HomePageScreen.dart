import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/app_assets.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  // منطق العد التنازلي
  late Timer _timer;
  late Timer _tipTimer;
  Duration _timeLeft = const Duration(days: 45, hours: 12, minutes: 30);
  
  int _currentTipIndex = 0;
  final List<Map<String, String>> _tips = [
    {'type': 'نصيحة', 'text': 'ابدأ يومك بنية صادقة، فالتوفيق يبدأ بصدق العمل والاجتهاد المستمر للوصول إلى هدفك.'},
    {'type': 'دعاء', 'text': 'اللهم لا سهل إلا ما جعلته سهلاً، وأنت تجعل الحزن إذا شئت سهلاً.'},
    {'type': 'تحفيز', 'text': 'تذكر دائماً أن القمة تتسع للجميع، فلا تتوقف حتى تصل إلى هناك وتترك بصمتك.'},
    {'type': 'حلم', 'text': 'تخيل نفسك يوم النتائج وأنت ترفع رأس والديك فخراً، هذا الحلم يستحق كل لحظة سهر.'},
    {'type': 'نصيحة', 'text': 'تنظيم الوقت هو نصف النجاح، خصص وقتاً للراحة كما تخصص وقتاً للدراسة لتبدع أكثر.'},
    {'type': 'دعاء', 'text': 'اللهم اشرح لي صدري ويسر لي أمري واحلل عقدة من لساني يفقهوا قولي.'},
    {'type': 'تحفيز', 'text': 'الفشل ليس نهاية الطريق، بل هو فرصة لتبدأ من جديد بذكاء أكبر وخبرة أكثر.'},
    {'type': 'حلم', 'text': 'أحلامك الكبيرة تبدأ من هذه الصفحة ومن هذا الكتاب، لا تستهن بما تنجزه اليوم.'},
    {'type': 'نصيحة', 'text': 'ركز على فهم المادة لا حفظها، فالفهم هو الذي يبقى معك في قاعة الامتحان وفي الحياة.'},
    {'type': 'دعاء', 'text': 'ربي زدني علماً وأنر بصيرتي، واجعل علمي نافعاً لي ولأمتي.'},
  ];
  
  String userName = "الطالب";
  String userEmail = "user@email.com";
  String? _profileImagePath;

  String _getInitials(String name) {
    if (name.isEmpty) return "S";
    return name.trim().substring(0, 1).toUpperCase();
  }

  // Gemini AI Variables
  final TextEditingController _chatController = TextEditingController();
  final List<Map<String, dynamic>> _chatMessages = [];
  bool _isTyping = false;
  late GenerativeModel _model;
  late ChatSession _chat;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    _loadUserData();
    _startCountdown();
    _initGemini();
    
    // بدء مؤقت النصائح تلقائياً كل 6 ثوانٍ
    _tipTimer = Timer.periodic(const Duration(seconds: 6), (timer) {
      if (mounted) {
        setState(() {
          _currentTipIndex = (_currentTipIndex + 1) % _tips.length;
        });
      }
    });
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString('user_name');
    final savedEmail = prefs.getString('user_email');
    final savedImagePath = prefs.getString('profile_image_path');
    
    if (mounted) {
      setState(() {
        if (savedName != null && savedName.isNotEmpty) {
          userName = savedName;
        }
        userEmail = savedEmail ?? "user@email.com";
        _profileImagePath = savedImagePath;
      });
    }
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
                  color: primaryColor.withOpacity(0.1),
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
      // محاولة فتح المعرض بجودة عالية
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 2000, // رفع الحد الأقصى للعرض
        maxHeight: 2000, // رفع الحد الأقصى للطول
        imageQuality: 100, // الجودة الكاملة
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

  void _initGemini() {
    // ملاحظة: يجب وضع API Key صالح هنا ليعمل الذكاء الاصطناعي
    const apiKey = 'AIzaSyAc-fKE-o9DfoYciB0o2_UqaKUUFKuG2w0';
    _model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: apiKey);
    _chat = _model.startChat();
    
    // رسالة الترحيب
    _chatMessages.add({
      'text': 'مرحباً بك في A Plus! أنا مساعدك الذكي، كيف يمكنني مساعدتك في دراستك اليوم؟',
      'isMe': false,
    });
  }

  Future<void> _sendMessage() async {
    final message = _chatController.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _chatMessages.add({'text': message, 'isMe': true});
      _chatController.clear();
      _isTyping = true;
    });

    try {
      final response = await _chat.sendMessage(Content.text(message));
      setState(() {
        _chatMessages.add({
          'text': response.text ?? 'عذراً، لم أستطع فهم ذلك.',
          'isMe': false,
        });
      });
    } catch (e) {
      debugPrint("Gemini Error: $e");
      setState(() {
        _chatMessages.add({
          'text': 'حدث خطأ في الاتصال. يرجى التأكد من مفتاح API أو جودة الإنترنت. الخطأ: ${e.toString().split(':').first}',
          'isMe': false,
        });
      });
    } finally {
      setState(() {
        _isTyping = false;
      });
    }
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (_timeLeft.inMinutes > 0) {
        setState(() {
          _timeLeft = _timeLeft - const Duration(minutes: 1);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _tipTimer.cancel();
    super.dispose();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "صباح الخير";
    return "مساء الخير";
  }

  final List<Map<String, String>> _notifications = [
    {
      'title': 'مرحباً بك في A Plus',
      'body': 'نتمنى لك رحلة تعليمية ممتعة ومفيدة.',
      'time': 'منذ ساعة'
    },
    {
      'title': 'تحديث جديد',
      'body': 'تم إضافة مواد دراسية جديدة للمرحلة السادسة العلمي.',
      'time': 'منذ ساعتين'
    },
  ];

  final List<Map<String, dynamic>> subjects = [
    {
      'label': 'الإسلامية',
      'icon': AppAssets.islamic,
      'pdfs': [
        {'title': 'الكتاب', 'path': AppAssets.islamicPdf}
      ],
      'exams': [
        {'title': 'اختبار شامل - الفصل الأول'},
        {'title': 'اختبار شامل - الفصل الثاني'},
      ]
    },
    {
      'label': 'العربية',
      'icon': AppAssets.arabic,
      'pdfs': [
        {'title': 'الكتاب - الجزء الأول', 'path': AppAssets.arabicP1Pdf},
        {'title': 'الكتاب - الجزء الثاني', 'path': AppAssets.arabicP2Pdf},
      ],
      'exams': [
        {'title': 'اختبار الأدب - الفصل الأول'},
        {'title': 'اختبار القواعد - الفصل الأول'},
      ]
    },
    {
      'label': 'الإنكليزي',
      'icon': AppAssets.english,
      'pdfs': [
        {'title': 'الكتاب - كتاب الطالب', 'path': AppAssets.englishStudentPdf},
        {'title': 'الكتاب - كتاب النشاط', 'path': AppAssets.englishActivityPdf},
      ],
      'exams': [
        {'title': 'اختبار مفردات - Unit 1'},
        {'title': 'اختبار قواعد - Unit 1'},
      ]
    },
    {
      'label': 'الرياضيات',
      'icon': AppAssets.math,
      'pdfs': [
        {'title': 'الكتاب', 'path': AppAssets.mathPdf}
      ],
      'exams': [
        {'title': 'اختبار الأعداد المركبة'},
        {'title': 'اختبار القطوع المخروطية'},
      ]
    },
    {
      'label': 'الأحياء',
      'icon': AppAssets.biology,
      'pdfs': [
        {'title': 'الكتاب', 'path': AppAssets.biologyPdf}
      ],
      'exams': [
        {'title': 'اختبار الخلية'},
        {'title': 'اختبار الأنسجة'},
      ]
    },
    {
      'label': 'الكيمياء',
      'icon': AppAssets.chemistry,
      'pdfs': [
        {'title': 'الكتاب', 'path': AppAssets.chemistryPdf}
      ],
      'exams': [
        {'title': 'اختبار الثرموداينمك'},
        {'title': 'اختبار الاتزان الكيميائي'},
      ]
    },
    {
      'label': 'الفيزياء',
      'icon': AppAssets.physics,
      'pdfs': [
        {'title': 'الكتاب', 'path': AppAssets.physicsPdf}
      ],
      'exams': [
        {'title': 'اختبار المتسعات'},
        {'title': 'اختبار الحث الكهرومغناطيسي'},
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;
    final selectedStage =
        ModalRoute.of(context)?.settings.arguments as String? ?? "غير محدد";

    return DefaultTabController(
      length: 6,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false, // الحل الاحترافي: منع الشاشة من الانضغاط
          appBar: AppBar(
            toolbarHeight: 80,
            backgroundColor: primaryColor,
            elevation: 4, // رفع قيمة الظل ليكون حاداً وواضحاً
            shadowColor: Colors.black, // لون ظل أسود صريح ليكون حاداً
            surfaceTintColor: Colors.transparent, // منع تغير اللون عند التمرير في Material 3
            centerTitle: false,
            systemOverlayStyle: SystemUiOverlayStyle.light,

            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildAppBarGreeting(secondaryColor),
                  _buildAppBarLogo(secondaryColor),
                ],
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: Container(
                margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(30),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withAlpha(50), width: 1.5), // حواف بيضاء خفيفة وواضحة
                ),
                child: TabBar(
                  dividerColor: Colors.transparent,
                  indicatorColor: secondaryColor,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorWeight: 4,
                  labelColor: secondaryColor,
                  unselectedLabelColor: Colors.white70,
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(width: 4.0, color: secondaryColor),
                    insets: const EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  tabs: const [
                    Tab(icon: Icon(Icons.home_rounded, size: 26)),
                    Tab(icon: Icon(Icons.auto_awesome_rounded, size: 26)),
                    Tab(icon: Icon(Icons.handyman_rounded, size: 26)),
                    Tab(icon: Icon(Icons.notifications_none_rounded, size: 26)),
                    Tab(icon: Icon(Icons.emoji_events_rounded, size: 26)),
                    Tab(icon: Icon(Icons.person_outline_rounded, size: 26)),
                  ],
                ),
              ),
            ),
          ),
          body: SafeArea(
            bottom: true, // يضمن عدم تداخل المحتوى مع أزرار النظام في الأسفل
            child: TabBarView(
              // تم ترك خاصية physics افتراضية للسماح بالسحب بين التبويبات
              children: [
                _buildHomeView(),
                _buildAiChatView(primaryColor),
                _buildToolsView(primaryColor, secondaryColor),
                _buildNotificationsView(primaryColor, secondaryColor),
                _buildLeaderboardView(primaryColor, secondaryColor),
                _buildProfileView(selectedStage, primaryColor, secondaryColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBarGreeting(Color secondaryColor) {
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: Colors.white.withAlpha(40),
          backgroundImage: _profileImagePath != null ? FileImage(File(_profileImagePath!)) : null,
          child: _profileImagePath == null
              ? Text(
                  _getInitials(userName),
                  style: const TextStyle(
                      color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                )
              : null,
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_getGreeting(),
                style: const TextStyle(color: Colors.white70, fontSize: 12)),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                      text: "مرحباً، ",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: userName, // <--- المتغير هنا
                      style: TextStyle(
                          color: secondaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAppBarLogo(Color secondaryColor) {
    return Text.rich(
      TextSpan(
        children: [
          const TextSpan(
              text: "A ",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold)),
          TextSpan(
              text: "Plus",
              style: TextStyle(
                  color: secondaryColor,
                  fontSize: 32,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildHomeView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildMotivationalSection(),
          _buildSectionHeader("المواد الدراسية", "${subjects.length} مواد"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  clipBehavior: Clip.none,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.4, // العودة للنسبة الأصلية
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemCount: subjects.length,
                  itemBuilder: (context, index) {
                    return _buildSubjectCard(subjects[index]);
                  },
                ),
              ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildMotivationalSection() {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final secondaryColor = Theme.of(context).colorScheme.secondary;
    final currentTip = _tips[_currentTipIndex];

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      height: 140, // زيادة الطول قليلاً لاستيعاب النصوص المتغيرة
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, primaryColor.withAlpha(200)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withAlpha(60),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: -15,
            bottom: -15,
            child: Icon(Icons.auto_awesome_rounded,
                size: 100, color: Colors.white.withAlpha(20)),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: secondaryColor.withAlpha(40),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getTipIcon(currentTip['type']!),
                        color: secondaryColor,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: Text(
                        "${currentTip['type']} اليوم",
                        key: ValueKey<int>(_currentTipIndex),
                        style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 800),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: Text(
                      currentTip['text']!,
                      key: ValueKey<int>(_currentTipIndex),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.5),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getTipIcon(String type) {
    switch (type) {
      case 'دعاء': return Icons.star_rounded;
      case 'تحفيز': return Icons.bolt_rounded;
      case 'حلم': return Icons.auto_awesome_rounded;
      default: return Icons.lightbulb_rounded;
    }
  }

  Widget _buildAiChatView(Color primaryColor) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: _chatMessages.length + (_isTyping ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _chatMessages.length) {
                return _buildChatBubble("جاري الكتابة...", false, primaryColor);
              }
              final msg = _chatMessages[index];
              return _buildChatBubble(msg['text'], msg['isMe'], primaryColor);
            },
          ),
        ),
        _buildChatInput(primaryColor),
      ],
    );
  }

  Widget _buildChatInput(Color primaryColor) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom), // يرتفع يدوياً مع الكيبورد
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withAlpha(20),
                blurRadius: 10,
                offset: const Offset(0, -5)),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(25)),
                child: TextField(
                  controller: _chatController,
                  onSubmitted: (_) => _sendMessage(),
                  decoration: const InputDecoration(
                      hintText: "اكتب رسالتك هنا...",
                      border: InputBorder.none,
                      hintStyle: TextStyle(fontSize: 14)),
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: _sendMessage,
              child: CircleAvatar(
                backgroundColor: primaryColor,
                child: _isTyping 
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.send_rounded, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBubble(String message, bool isMe, Color primaryColor) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? primaryColor : Colors.grey[200],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(15),
            bottomLeft: Radius.circular(isMe ? 15 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 15),
          ),
        ),
        child: Text(
          message,
          style: TextStyle(
              color: isMe ? Colors.white : Colors.black87, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildToolsView(Color primaryColor, Color secondaryColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader("الأدوات التعليمية", "3 أدوات"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildToolListItem(
                    label: 'بومودورو',
                    icon: Icons.timer_outlined,
                    primaryColor: primaryColor,
                    secondaryColor: secondaryColor),
                _buildToolListItem(
                    label: 'ملاحظات',
                    icon: Icons.note_alt_rounded,
                    primaryColor: primaryColor,
                    secondaryColor: secondaryColor),
                _buildToolListItem(
                    label: 'العد التنازلي',
                    icon: Icons.timer_rounded,
                    primaryColor: primaryColor,
                    secondaryColor: secondaryColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsView(Color primaryColor, Color secondaryColor) {
    if (_notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_none_rounded,
                size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text("لا توجد إشعارات حالياً",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryColor)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: _notifications.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: Key(_notifications[index]['title']! + _notifications[index]['time']!),
          direction: DismissDirection.startToEnd,
          onDismissed: (direction) {
            setState(() {
              _notifications.removeAt(index);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("تم حذف الإشعار"),
                duration: Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          background: Container(
            margin: const EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(15),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete_sweep_rounded, color: Colors.white),
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withAlpha(50),
                    blurRadius: 10,
                    offset: const Offset(0, 0)),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(15),
              leading: CircleAvatar(
                backgroundColor: secondaryColor.withAlpha(25),
                child: Icon(Icons.notifications_active_outlined,
                    color: secondaryColor),
              ),
              title: Text(_notifications[index]['title']!,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                      fontSize: 16)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Text(_notifications[index]['body']!,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                  const SizedBox(height: 8),
                  Text(_notifications[index]['time']!,
                      style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLeaderboardView(Color primaryColor, Color secondaryColor) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildSectionHeader("المتصدرين", "هذا الأسبوع"),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPodiumUser(
                    name: "أحمد علي",
                    hours: "42 ساعة",
                    rank: 2,
                    height: 140,
                    primaryColor: primaryColor,
                    secondaryColor: secondaryColor),
                const SizedBox(width: 15),
                _buildPodiumUser(
                    name: "سارة محمد",
                    hours: "56 ساعة",
                    rank: 1,
                    height: 180,
                    hasCrown: true,
                    primaryColor: primaryColor,
                    secondaryColor: secondaryColor),
                const SizedBox(width: 15),
                _buildPodiumUser(
                    name: "ياسر حسن",
                    hours: "38 ساعة",
                    rank: 3,
                    height: 110,
                    primaryColor: primaryColor,
                    secondaryColor: secondaryColor),
              ],
            ),
          ),
          const SizedBox(height: 40),
          _buildLeaderList(primaryColor),
          const SizedBox(height: 100),
        ],
      ),
    );
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
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
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

  Widget _buildProfileView(
      String stage, Color primaryColor, Color secondaryColor) {
    return Padding(
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
                      radius: 55, // تكبير الحجم قليلاً
                      backgroundColor: secondaryColor.withAlpha(25),
                      backgroundImage: _profileImagePath != null ? FileImage(File(_profileImagePath!)) : null,
                      child: _profileImagePath == null
                          ? Text(
                              _getInitials(userName),
                              style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor),
                            )
                          : null,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white, // خلفية بيضاء
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(40),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(Icons.camera_alt_outlined, color: primaryColor, size: 20), // أيقونة تعديل ولون أساسي
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
          _buildProfileData("البريد الإلكتروني", userEmail, primaryColor), // <--- هنا الايميل
          const Divider(height: 30),
          _buildStageData(stage, primaryColor, secondaryColor),
          const Divider(height: 30),
          const Spacer(),
          _buildAccountActions(),
        ],
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

  Widget _buildStageData(
      String stage, Color primaryColor, Color secondaryColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildProfileData("المرحلة الدراسية والفرع", stage, primaryColor),
        TextButton.icon(
          onPressed: () => Navigator.pushReplacementNamed(context, '/stages'),
          icon: Icon(Icons.edit_note_rounded, color: secondaryColor, size: 20),
          label: Text("تبديل",
              style:
                  TextStyle(color: secondaryColor, fontWeight: FontWeight.bold)),
        ),
      ],
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
                  color: Colors.redAccent.withOpacity(0.1),
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
                      onPressed: () {
                        // منطق تسجيل الخروج
                        Navigator.pushNamedAndRemoveUntil(context, '/signin', (route) => false);
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
                  color: Colors.red.withOpacity(0.1),
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
                      onPressed: () {
                        // منطق حذف الحساب
                        Navigator.pushNamedAndRemoveUntil(context, '/signup', (route) => false);
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

  Widget _buildAccountActions() {
    return Row(
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
        _buildDeleteAccountButton(),
      ],
    );
  }

  Widget _buildDeleteAccountButton() {
    return Container(
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
    );
  }

  Widget _buildSectionHeader(String title, String trailing) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final secondaryColor = Theme.of(context).colorScheme.secondary;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 8),
              Text(title,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryColor)),
            ],
          ),
          Text(trailing,
              style: TextStyle(fontSize: 14, color: Colors.grey[500])),
        ],
      ),
    );
  }

  void _showSubjectDetails(BuildContext context, Map<String, dynamic> subject) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final secondaryColor = Theme.of(context).colorScheme.secondary;
    final List<Map<String, String>> pdfs =
        List<Map<String, String>>.from(subject['pdfs']);
    final List<Map<String, String>> exams =
        List<Map<String, String>>.from(subject['exams'] ?? []);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    subject['label']!,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  Image.asset(
                    subject['icon']!,
                    height: 45,
                    errorBuilder: (c, e, s) => Icon(
                      Icons.book,
                      color: secondaryColor,
                      size: 35,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // عرض الكتب (سواء كتاب واحد أو أجزاء)
              ...pdfs.map((pdf) {
                return _buildBottomSheetItem(
                  pdf['title']!,
                  Icons.menu_book_rounded,
                  primaryColor,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(
                      context,
                      '/pdf_viewer',
                      arguments: {
                        'title': pdf['title'],
                        'pdfPath': pdf['path'],
                      },
                    );
                  },
                );
              }),
              // زر الاختبارات الثابت
              _buildBottomSheetItem(
                "الاختبارات",
                Icons.assignment_turned_in_rounded,
                primaryColor,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(
                    context,
                    '/exams',
                    arguments: {
                      'subjectName': subject['label'],
                    },
                  );
                },
              ),
              // زر الوزاريات الثابت
              _buildBottomSheetItem(
                "الوزاريات",
                Icons.account_balance_rounded,
                primaryColor, // جعل لونه نفس لون الكتاب (primary)
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(
                    context,
                    '/ministerials',
                    arguments: {
                      'subjectName': subject['label'],
                    },
                  );
                },
              ),
              // قسم أحكام التلاوة (فقط لمادة الإسلامية)
              if (subject['label'] == 'الإسلامية')
                _buildBottomSheetItem(
                  "أحكام التلاوة",
                  Icons.menu_book_rounded,
                  primaryColor,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/tajweed_rules');
                  },
                ),
              // قسم سور الحفظ (فقط لمادة الإسلامية)
              if (subject['label'] == 'الإسلامية')
                _buildBottomSheetItem(
                  "سور الحفظ",
                  Icons.menu_book_outlined,
                  primaryColor,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/surahs');
                  },
              ),
              // قسم قصائد الأدب (فقط لمادة العربية)
              if (subject['label'] == 'العربية')
                _buildBottomSheetItem(
                  "قصائد الأدب",
                  Icons.auto_stories_rounded,
                  primaryColor,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/poems');
                  },
                ),
              // قسم الإنشاءات (فقط لمادة الإنكليزي)
              if (subject['label'] == 'الإنكليزي')
                _buildBottomSheetItem(
                  "الإنشاءات",
                  Icons.edit_note_rounded,
                  primaryColor,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/essays');
                  },
                ),
              // قسم رسومات الأحياء (فقط لمادة الأحياء)
              if (subject['label'] == 'الأحياء')
                _buildBottomSheetItem(
                  "رسومات الأحياء",
                  Icons.image_search_rounded,
                  primaryColor,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/biology_diagrams');
                  },
                ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSubHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheetItem(String title, IconData icon, Color color,
      {VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey[100]!)),
      child: ListTile(
        onTap: onTap ?? () => Navigator.pop(context),
        leading: CircleAvatar(
            backgroundColor: color.withAlpha(20),
            child: Icon(icon, color: color, size: 24)),
        title: Text(title,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color.withAlpha(200))),
        trailing: Icon(Icons.arrow_forward_ios_rounded,
            size: 16, color: Theme.of(context).colorScheme.secondary),
      ),
    );
  }

  Widget _buildPodiumUser({required String name, required String hours, required int rank, required double height, bool hasCrown = false, required Color primaryColor, required Color secondaryColor}) {
    return Column(
      children: [
        if (hasCrown) const Icon(Icons.workspace_premium_rounded, color: Colors.amber, size: 35),
        const SizedBox(height: 5),
        CircleAvatar(radius: 30, backgroundColor: secondaryColor.withAlpha(25), child: Icon(Icons.person, color: primaryColor)),
        const SizedBox(height: 10),
        Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        Text(hours, style: TextStyle(color: secondaryColor, fontSize: 11, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Container(
          width: 80, height: height,
          decoration: BoxDecoration(color: primaryColor, borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
          child: Center(child: Text("$rank", style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold))),
        ),
      ],
    );
  }

  Widget _buildLeaderList(Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(15)),
            child: Row(
              children: [
                Text("${index + 4}", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                const SizedBox(width: 15),
                const CircleAvatar(radius: 20, child: Icon(Icons.person)),
                const SizedBox(width: 15),
                const Expanded(child: Text("مستخدم متفوق", style: TextStyle(fontWeight: FontWeight.bold))),
                Text("30 ساعة", style: TextStyle(color: Colors.grey[600], fontSize: 13)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildToolListItem({required String label, required IconData icon, required Color primaryColor, required Color secondaryColor}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withAlpha(50),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15), // يجعل تأثير الضغط دائرياً بنفس حواف الحاوية
          onTap: () {
            if (label == 'العد التنازلي') {
              Navigator.pushNamed(context, '/countdown');
            } else if (label == 'ملاحظات') {
              Navigator.pushNamed(context, '/notes');
            } else if (label == 'بومودورو') {
              Navigator.pushNamed(context, '/pomodoro');
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.white.withAlpha(30),
                  child: Icon(icon, color: secondaryColor, size: 28),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubjectCard(Map<String, dynamic> subject) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    int sectionCount = 0;
    if (subject['pdfs'] != null) sectionCount += (subject['pdfs'] as List).length;
    sectionCount += 2; // الاختبارات + الوزاريات
    
    if (subject['label'] == 'الإسلامية') sectionCount += 2;
    else if (subject['label'] == 'العربية') sectionCount += 1;
    else if (subject['label'] == 'الإنكليزي') sectionCount += 1;
    else if (subject['label'] == 'الأحياء') sectionCount += 1;

    return GestureDetector(
      onTap: () => _showSubjectDetails(context, subject),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(50),
              blurRadius: 10,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject['label']!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "$sectionCount أقسام",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Image.asset(
                subject['icon']!,
                height: 45,
                errorBuilder: (c, e, s) => Icon(
                  Icons.book,
                  color: secondaryColor,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
