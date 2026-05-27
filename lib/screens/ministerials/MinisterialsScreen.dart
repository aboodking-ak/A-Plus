import 'package:flutter/material.dart';

class MinisterialsScreen extends StatefulWidget {
  final String subjectName;
  const MinisterialsScreen({super.key, required this.subjectName});

  @override
  State<MinisterialsScreen> createState() => _MinisterialsScreenState();
}

class _MinisterialsScreenState extends State<MinisterialsScreen> {
  String? selectedChapter;
  String? selectedTopic;

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
        scrolledUnderElevation: 4, // يرتفع ويظهر ظل عند السكرول
        surfaceTintColor: primaryColor, // يتغير اللون بشكل طفيف عند السكرول ليعطي طابع Material 3
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
      body: _buildQuestionsList(primaryColor, secondaryColor),
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
                    "اختيار مادة الوزاريات",
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

  Widget _buildQuestionsList(Color primaryColor, Color secondaryColor) {
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
              child: Icon(Icons.history_edu_rounded, size: 50, color: primaryColor.withValues(alpha: 0.3)),
            ),
            const SizedBox(height: 20),
            const Text(
              "يرجى اختيار المادة لعرض الوزاريات",
              style: TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: ministerialQuestions.length,
      separatorBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Colors.blueGrey.withValues(alpha: 0.15),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
      itemBuilder: (context, index) {
        final item = ministerialQuestions[index];
        return _buildMinisterialItem(item, index, primaryColor, secondaryColor);
      },
    );
  }

  Widget _buildMinisterialItem(Map<String, dynamic> item, int index, Color primaryColor, Color secondaryColor) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // رأس السؤال (السنة والدور)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.history_edu_rounded, size: 18, color: primaryColor),
                    const SizedBox(width: 10),
                    Text(
                      "سؤال وزاري ${index + 1}",
                      style: TextStyle(
                        color: Colors.blueGrey[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: secondaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "${item['year']} - ${item['session']}",
                    style: TextStyle(color: secondaryColor, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          // نص السؤال
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
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
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
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
    );
  }
}
