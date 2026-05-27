import 'package:flutter/material.dart';

class ExamsScreen extends StatefulWidget {
  final String subjectName;
  const ExamsScreen({super.key, required this.subjectName});

  @override
  State<ExamsScreen> createState() => _ExamsScreenState();
}

class _ExamsScreenState extends State<ExamsScreen> {
  String? selectedChapter;
  String? selectedTopic;

  final PageController _pageController = PageController();
  int _currentIndex = 0;
  bool _showAnswer = false;

  // هيكلية البيانات: كل فصل والمواضيع التابعة له
  final Map<String, List<String>> _data = {
    "الفصل الأول": ["الموضوع الأول", "الموضوع الثاني", "الموضوع الثالث"],
    "الفصل الثاني": ["الموضوع الأول", "الموضوع الثاني"],
    "الفصل الثالث": ["الموضوع الأول", "الموضوع الثاني", "الموضوع الثالث", "الموضوع الرابع"],
    "الفصل الرابع": ["الموضوع الأول"],
  };

  List<String> get chapters => _data.keys.toList();

  List<String> get currentTopics {
    if (selectedChapter == null) return [];
    return ["شامل", ..._data[selectedChapter]!];
  }

  final List<String> questions = List.generate(10, (index) => "هذا هو نص السؤال رقم ${index + 1} في مادة الاختبار؟ يمكن أن يكون السؤال طويلاً ليشغل أكثر من سطر.");

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    const backgroundColor = Color(0xFFF1F5F9); 

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text("اختبار ${widget.subjectName}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 70,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20), // سهم الرجوع في اليمين
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded), // أيقونة التصفية في اليسار
            onPressed: () => _showSelectionBottomSheet(context, primaryColor),
          ),
        ],
      ),
      body: _buildQuestionsList(primaryColor),
    );
  }

  void _showSelectionBottomSheet(BuildContext context, Color primaryColor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "اختيار مادة الاختبار",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  _buildModalDropdown(
                    "الفصل",
                    Icons.folder_open_rounded,
                    chapters,
                    selectedChapter,
                    (val) {
                      setModalState(() {
                        selectedChapter = val;
                        selectedTopic = null;
                      });
                      setState(() {
                        selectedChapter = val;
                        selectedTopic = null;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildModalDropdown(
                    "الموضوع",
                    Icons.topic_outlined,
                    currentTopics,
                    selectedTopic,
                    (val) {
                      setModalState(() => selectedTopic = val);
                      setState(() => selectedTopic = val);
                    },
                    isEnabled: selectedChapter != null,
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: (selectedChapter != null && selectedTopic != null)
                          ? () => Navigator.pop(context)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("تأكيد الاختيار", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildModalDropdown(String hint, IconData icon, List<String> items, String? value, ValueChanged<String?> onChanged, {bool isEnabled = true}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isEnabled ? Colors.grey[50] : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          hint: Row(
            children: [
              Icon(icon, size: 20, color: Colors.grey[400]),
              const SizedBox(width: 12),
              Text(hint, style: TextStyle(color: Colors.grey[400])),
            ],
          ),
          items: isEnabled ? items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList() : null,
          onChanged: isEnabled ? onChanged : null,
        ),
      ),
    );
  }

  Widget _buildQuestionsList(Color primaryColor) {
    if (selectedChapter == null || selectedTopic == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20),
                ],
              ),
              child: Icon(Icons.assignment_outlined, size: 50, color: primaryColor.withValues(alpha: 0.3)),
            ),
            const SizedBox(height: 20),
            const Text(
              "يرجى اختيار المادة لبدء الاختبار",
              style: TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // شريط التقدم
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "السؤال ${_currentIndex + 1} من ${questions.length}",
                    style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  Text(
                    "${((_currentIndex + 1) / questions.length * 100).toInt()}%",
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: (_currentIndex + 1) / questions.length,
                  minHeight: 8,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                ),
              ),
            ],
          ),
        ),

        // عرض الأسئلة (PageView)
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(), // منع السحب اليدوي لضمان استخدام الأزرار
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
                _showAnswer = false;
              });
            },
            itemCount: questions.length,
            itemBuilder: (context, index) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      questions[index],
                      style: const TextStyle(
                        fontSize: 18,
                        height: 1.8,
                        color: Color(0xFF334155),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_showAnswer) ...[
                      const SizedBox(height: 30),
                      const Divider(),
                      const SizedBox(height: 20),
                      const Text(
                        "الإجابة النموذجية:",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "هذا هو نص الإجابة النموذجية للسؤال المختار. يتم عرضه بعد ضغط زر 'عرض الجواب'.",
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.7,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),

        // أزرار التحكم في الأسفل
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5)),
            ],
          ),
          child: Row(
            children: [
              if (_currentIndex > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("السابق"),
                  ),
                ),
              if (_currentIndex > 0) const SizedBox(width: 15),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    if (!_showAnswer) {
                      setState(() => _showAnswer = true);
                    } else if (_currentIndex < questions.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      // نهاية الاختبار
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor, // توحيد اللون مع لون التطبيق الأساسي
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Text(
                    !_showAnswer 
                        ? "عرض الجواب" 
                        : (_currentIndex < questions.length - 1 ? "السؤال التالي" : "إنهاء الاختبار"),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
