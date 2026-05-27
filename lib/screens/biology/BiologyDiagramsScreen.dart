import 'package:flutter/material.dart';

class BiologyDiagramsScreen extends StatefulWidget {
  const BiologyDiagramsScreen({super.key});

  @override
  State<BiologyDiagramsScreen> createState() => _BiologyDiagramsScreenState();
}

class _BiologyDiagramsScreenState extends State<BiologyDiagramsScreen> {
  String? selectedChapter;
  String? selectedDiagram;

  final List<String> chapters = [
    "الفصل الأول: الخلية",
    "الفصل الثاني: الأنسجة",
    "الفصل الثالث: التكاثر",
    "الفصل الرابع: التكوين الجنيني",
    "الفصل الخامس: الوراثة"
  ];

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

  List<String> get currentDiagrams {
    if (selectedChapter == null) return [];
    return diagramsData[selectedChapter]?.map((d) => d['title'] as String).toList() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    const backgroundColor = Color(0xFFF1F5F9);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("رسومات الأحياء", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 70,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () => _showSelectionBottomSheet(context, primaryColor),
          ),
        ],
      ),
      body: _buildContent(primaryColor),
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
                    "اختيار الرسمة",
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
                        selectedDiagram = null;
                      });
                      setState(() {
                        selectedChapter = val;
                        selectedDiagram = null;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildModalDropdown(
                    "الرسمة",
                    Icons.image_outlined,
                    currentDiagrams,
                    selectedDiagram,
                    (val) {
                      setModalState(() => selectedDiagram = val);
                      setState(() => selectedDiagram = val);
                    },
                    isEnabled: selectedChapter != null,
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: (selectedChapter != null && selectedDiagram != null)
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

  Widget _buildContent(Color primaryColor) {
    if (selectedChapter == null || selectedDiagram == null) {
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
              child: Icon(Icons.image_search_rounded, size: 50, color: primaryColor.withValues(alpha: 0.3)),
            ),
            const SizedBox(height: 20),
            const Text(
              "يرجى اختيار الرسمة للعرض",
              style: TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    }

    final diagram = diagramsData[selectedChapter]!.firstWhere((d) => d['title'] == selectedDiagram);
    final bool isHifth = diagram['type'] == 'حفظ';

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildSectionHeader(selectedChapter!, primaryColor),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.02), offset: const Offset(0, 2), blurRadius: 5),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      diagram['title'],
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isHifth ? Colors.red.withValues(alpha: 0.1) : Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: isHifth ? Colors.red : Colors.blue, width: 1),
                      ),
                      child: Text(
                        diagram['type'],
                        style: TextStyle(
                          color: isHifth ? Colors.red : Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 40, thickness: 1),
                // مساحة الصورة
                Container(
                  height: 400,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image_outlined, size: 80, color: Colors.grey[300]),
                      const SizedBox(height: 10),
                      Text("سيتم عرض صورة الرسمة هنا", style: TextStyle(color: Colors.grey[400], fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () => _openFullScreen(context, diagram['title']),
                icon: const Icon(Icons.zoom_in_rounded),
                label: const Text("عرض ملء الشاشة", style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 0,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  void _openFullScreen(BuildContext context, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenDiagram(title: title),
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color primaryColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          ),
        ],
      ),
    );
  }
}

class FullScreenDiagram extends StatelessWidget {
  final String title;
  const FullScreenDiagram({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(title, style: const TextStyle(fontSize: 16)),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 0.5,
          maxScale: 4.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image_outlined, size: 150, color: Colors.white.withValues(alpha: 0.2)),
              const SizedBox(height: 20),
              const Text(
                "عرض الصورة بملء الشاشة مع إمكانية الزووم",
                style: TextStyle(color: Colors.white54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
