import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_assets.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  // منطق العد التنازلي
  late Timer _timer;
  Duration _timeLeft = const Duration(days: 45, hours: 12, minutes: 30);
  var a = 1;
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    _startCountdown();
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
          appBar: AppBar(
            toolbarHeight: 80,
            backgroundColor: primaryColor,
            elevation: 12,
            shadowColor: primaryColor.withAlpha(120),
            centerTitle: false,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(35),
                bottomRight: Radius.circular(35),
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
                  border: Border.all(color: Colors.white.withAlpha(40), width: 1),
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
          body: TabBarView(
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
    );
  }

  Widget _buildAppBarGreeting(Color secondaryColor) {
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: Colors.white.withAlpha(40),
          child: const Icon(Icons.person_rounded, color: Colors.white, size: 26),
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
                      text: "اسم المستخدم",
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
                childAspectRatio: 1.4,
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

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      height: 130,
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
                      child: Icon(Icons.lightbulb_rounded,
                          color: secondaryColor, size: 18),
                    ),
                    const SizedBox(width: 10),
                    const Text("نصيحة اليوم",
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                const Expanded(
                  child: Text(
                    "ابدأ يومك بنية صادقة، فالتوفيق يبدأ بصدق العمل والاجتهاد المستمر للوصول إلى هدفك.",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        height: 1.5),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiChatView(Color primaryColor) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildChatBubble(
                  "مرحباً! أنا مساعدك الذكي في A Plus. كيف يمكنني مساعدتك اليوم؟",
                  false, primaryColor),
              _buildChatBubble(
                  "أريد مساعدة في مادة الرياضيات، فصل التكامل.", true, primaryColor),
              _buildChatBubble(
                  "بالتأكيد! التكامل هو أحد أهم فصول الرياضيات. ما هو السؤال الذي يواجهك؟",
                  false, primaryColor),
            ],
          ),
        ),
        _buildChatInput(primaryColor),
      ],
    );
  }

  Widget _buildChatInput(Color primaryColor) {
    return Container(
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
              child: const TextField(
                decoration: InputDecoration(
                    hintText: "اكتب رسالتك هنا...",
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 14)),
              ),
            ),
          ),
          const SizedBox(width: 10),
          CircleAvatar(
            backgroundColor: primaryColor,
            child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
          ),
        ],
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
          _buildSectionHeader("الأدوات التعليمية", "2 أداة"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildToolListItem(
                    label: 'العد التنازلي',
                    icon: Icons.timer_rounded,
                    primaryColor: primaryColor,
                    secondaryColor: secondaryColor),
                _buildToolListItem(
                    label: 'مذكرة المذاكرة',
                    icon: Icons.note_alt_rounded,
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
        return Container(
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

  Widget _buildProfileView(
      String stage, Color primaryColor, Color secondaryColor) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: secondaryColor.withAlpha(25),
              child: Icon(Icons.person, size: 60, color: primaryColor),
            ),
          ),
          const SizedBox(height: 40),
          _buildProfileData("الاسم الكامل", "اسم المستخدم", primaryColor),
          const Divider(height: 30),
          _buildProfileData("البريد الإلكتروني", "user@email.com", primaryColor),
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
                onTap: () {},
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
          onTap: () {},
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
      decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: primaryColor.withAlpha(50), blurRadius: 10, offset: const Offset(0, 5))]),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        title: Text(label, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        trailing: CircleAvatar(backgroundColor: Colors.white.withAlpha(30), child: Icon(icon, color: secondaryColor, size: 28)),
        onTap: () {},
      ),
    );
  }

  Widget _buildSubjectCard(Map<String, dynamic> subject) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

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
                child: Text(
                  subject['label']!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                  textAlign: TextAlign.right,
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
