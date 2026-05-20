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

  final List<String> chapters = ["شامل", "الفصل الأول", "الفصل الثاني", "الفصل الثالث", "الفصل الرابع"];
  final List<String> topics = ["شامل", "الموضوع الأول", "الموضوع الثاني", "الموضوع الثالث"];

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
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: Row(
              children: [
                Expanded(
                  child: _buildAppBarDropdown("الفصل", Icons.folder_open_rounded, chapters, selectedChapter, (val) {
                    setState(() => selectedChapter = val);
                  }),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildAppBarDropdown("الموضوع", Icons.topic_outlined, topics, selectedTopic, (val) {
                    setState(() => selectedTopic = val);
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _buildQuestionsList(primaryColor),
    );
  }

  Widget _buildAppBarDropdown(String hint, IconData icon, List<String> items, String? value, ValueChanged<String?> onChanged) {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(240),
        borderRadius: BorderRadius.zero, // حواف مستقيمة كما في الواجهة
        border: Border.all(color: Colors.white.withAlpha(50), width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          dropdownColor: Colors.white,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.blueGrey[700], size: 18),
          hint: Row(
            children: [
              Icon(icon, size: 14, color: Colors.blueGrey[400]),
              const SizedBox(width: 8),
              Text(hint, style: TextStyle(fontSize: 12, color: Colors.blueGrey[400], fontWeight: FontWeight.bold)),
            ],
          ),
          value: value,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
            );
          }).toList(),
          onChanged: onChanged,
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
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(Icons.auto_awesome_motion_rounded, size: 50, color: primaryColor.withAlpha(40)),
            ),
            const SizedBox(height: 20),
            Text("يرجى اختيار الفصل والموضوع",
                style: TextStyle(color: Colors.blueGrey[400], fontSize: 15, fontWeight: FontWeight.w600)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 30),
      itemCount: questions.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withAlpha(40),
                blurRadius: 0,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: Colors.black.withAlpha(15),
                blurRadius: 15,
                offset: const Offset(0, 10),
              ),
            ],
            border: Border.all(color: Colors.blueGrey[50]!, width: 1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    border: Border(bottom: BorderSide(color: Colors.blueGrey[50]!, width: 1)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: primaryColor.withAlpha(20),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(Icons.stars_rounded, size: 14, color: primaryColor),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "السؤال ${index + 1}",
                        style: TextStyle(
                          color: Colors.blueGrey[800],
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 25, 20, 30),
                  child: Text(
                    questions[index],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.6,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
