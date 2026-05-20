import 'package:flutter/material.dart';

class BiologyDiagramsScreen extends StatefulWidget {
  const BiologyDiagramsScreen({super.key});

  @override
  State<BiologyDiagramsScreen> createState() => _BiologyDiagramsScreenState();
}

class _BiologyDiagramsScreenState extends State<BiologyDiagramsScreen> {
  String? selectedChapter;

  final List<String> chapters = [
    "الفصل الأول: الخلية",
    "الفصل الثاني: الأنسجة",
    "الفصل الثالث: التكاثر",
    "الفصل الرابع: التكوين الجنيني",
    "الفصل الخامس: الوراثة"
  ];

  // بيانات تجريبية لمحاكاة البيانات من قاعدة البيانات
  final Map<String, List<Map<String, dynamic>>> diagramsData = {
    "الفصل الأول: الخلية": [
      {"title": "الخلية البدائية", "type": "حفظ", "imageUrl": ""},
      {"title": "الغشاء البلازمي", "type": "حفظ", "imageUrl": ""},
      {"title": "الميتوكوندريا", "type": "اطلاع", "imageUrl": ""},
      {"title": "جهاز كولجي", "type": "اطلاع", "imageUrl": ""},
    ],
    "الفصل الثاني: الأنسجة": [
      {"title": "النسيج الظهاري المطبق", "type": "حفظ", "imageUrl": ""},
      {"title": "نسيج العظم", "type": "حفظ", "imageUrl": ""},
    ]
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;
    const backgroundColor = Color(0xFFF1F5F9);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("رسومات الأحياء", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
            child: _buildChapterSelector(),
          ),
        ),
      ),
      body: _buildDiagramsList(primaryColor, secondaryColor),
    );
  }

  Widget _buildChapterSelector() {
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
          hint: const Text("اختر الفصل لعرض الرسومات", style: TextStyle(fontSize: 13)),
          value: selectedChapter,
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

  Widget _buildDiagramsList(Color primaryColor, Color secondaryColor) {
    if (selectedChapter == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_search_rounded, size: 80, color: primaryColor.withAlpha(40)),
            const SizedBox(height: 16),
            const Text("يرجى اختيار الفصل لعرض الرسومات",
                style: TextStyle(color: Colors.blueGrey, fontSize: 15, fontWeight: FontWeight.w500)),
          ],
        ),
      );
    }

    final diagrams = diagramsData[selectedChapter] ?? [];

    if (diagrams.isEmpty) {
      return const Center(
        child: Text("قريباً... يتم العمل على إضافة الرسومات", style: TextStyle(color: Colors.grey)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: diagrams.length,
      itemBuilder: (context, index) {
        final item = diagrams[index];
        return _buildDiagramCard(item, primaryColor, secondaryColor);
      },
    );
  }

  Widget _buildDiagramCard(Map<String, dynamic> item, Color primaryColor, Color secondaryColor) {
    final bool isHifth = item['type'] == 'حفظ';

    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: primaryColor.withAlpha(40), blurRadius: 0, offset: const Offset(0, 6)),
          BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 15, offset: const Offset(0, 10)),
        ],
        border: Border.all(color: Colors.blueGrey[50]!),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // مساحة الصورة (سيتم استبدالها بصورة من الانترنت لاحقاً)
            Container(
              height: 250, // طول ثابت للصورة في وضع القائمة
              width: double.infinity,
              color: Colors.grey[100],
              child: Icon(Icons.image_outlined, size: 80, color: Colors.grey[300]),
            ),
            // تفاصيل الرسمة
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item['title'],
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isHifth ? Colors.red.withAlpha(20) : Colors.blue.withAlpha(20),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: isHifth ? Colors.red : Colors.blue, width: 1),
                    ),
                    child: Text(
                      item['type'],
                      style: TextStyle(
                        color: isHifth ? Colors.red : Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
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
