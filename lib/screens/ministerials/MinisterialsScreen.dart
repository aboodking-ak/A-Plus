import 'package:flutter/material.dart';

class MinisterialsScreen extends StatefulWidget {
  final String subjectName;
  const MinisterialsScreen({super.key, required this.subjectName});

  @override
  State<MinisterialsScreen> createState() => _MinisterialsScreenState();
}

class _MinisterialsScreenState extends State<MinisterialsScreen> {
  String? selectedChapter;
  final List<String> chapters = ["شامل", "الفصل الأول", "الفصل الثاني", "الفصل الثالث", "الفصل الرابع"];

  final List<Map<String, dynamic>> ministerialQuestions = List.generate(8, (index) => {
    'question': 'ما هو تعريف الثرموداينمك وما هي أهم القوانين المرتبطة به في هذه الحالة؟',
    'answer': 'الثرموداينمك هو علم يهتم بدراسة الطاقة وتحولاتها، ومن أهم قوانينه القانون الأول الذي ينص على أن الطاقة لا تفنى ولا تستحدث من العدم.',
    'year': '2023',
    'session': index % 3 == 0 ? 'الدور الأول' : (index % 3 == 1 ? 'الدور الثاني' : 'تمهيدي'),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;
    const backgroundColor = Color(0xFFF1F5F9);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text("وزاريات ${widget.subjectName}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
            child: _buildChapterSelector(secondaryColor),
          ),
        ),
      ),
      body: _buildQuestionsList(primaryColor, secondaryColor),
    );
  }

  Widget _buildChapterSelector(Color secondaryColor) {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.zero,
        border: Border.all(color: Colors.white.withAlpha(50)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: const Text("اختر الفصل لعرض الوزاريات", style: TextStyle(fontSize: 13)),
          value: selectedChapter,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: secondaryColor),
          items: chapters.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            );
          }).toList(),
          onChanged: (val) => setState(() => selectedChapter = val),
        ),
      ),
    );
  }

  Widget _buildQuestionsList(Color primaryColor, Color secondaryColor) {
    if (selectedChapter == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_balance_rounded, size: 80, color: primaryColor.withAlpha(40)),
            const SizedBox(height: 16),
            const Text("يرجى اختيار الفصل لعرض الأسئلة الوزارية",
                style: TextStyle(color: Colors.blueGrey, fontSize: 15, fontWeight: FontWeight.w500)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      itemCount: ministerialQuestions.length,
      itemBuilder: (context, index) {
        final item = ministerialQuestions[index];
        return _buildMinisterialCard(item, index, primaryColor, secondaryColor);
      },
    );
  }

  Widget _buildMinisterialCard(Map<String, dynamic> item, int index, Color primaryColor, Color secondaryColor) {
    return Container(
      margin: const EdgeInsets.fromLTRB(4, 0, 4, 30),
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
            // رأس البطاقة (التاريخ والدور)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(bottom: BorderSide(color: Colors.blueGrey[50]!, width: 1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: primaryColor.withAlpha(20),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(Icons.history_edu_rounded, size: 14, color: primaryColor),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "سؤال وزاري ${index + 1}",
                        style: TextStyle(
                          color: Colors.blueGrey[800],
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: secondaryColor, borderRadius: BorderRadius.circular(4)),
                    child: Text(
                      "${item['year']} - ${item['session']}",
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            // نص السؤال
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 15),
              child: Text(
                item['question'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.6,
                  color: Color(0xFF1E293B),
                ),
              ),
            ),
            // الجواب (قابل للطي)
            Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                title: Text(
                  "عرض الجواب النموذجي",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: secondaryColor),
                ),
                iconColor: secondaryColor,
                collapsedIconColor: secondaryColor,
                tilePadding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item['answer'],
                        style: const TextStyle(fontSize: 14, height: 1.7, color: Colors.black87),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
