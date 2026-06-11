import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MinisterialsScreen extends StatefulWidget {
  final String subjectName;
  const MinisterialsScreen({super.key, required this.subjectName});

  @override
  State<MinisterialsScreen> createState() => _MinisterialsScreenState();
}

class _MinisterialsScreenState extends State<MinisterialsScreen> {
  String? selectedChapter;
  String? selectedTopic;
  bool isInitialLoading = true;
  
  Map<String, dynamic> subjectData = {}; 
  List<dynamic> filteredQuestions = [];

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    final Map<String, List<String>> subjectFiles = {
      'الإسلامية': [
        'tajweed_questions.json',
        'unit1_questions.json',
        'unit2_questions.json',
        'unit3_questions.json',
        'unit4_questions.json',
        'unit5_questions.json',
        'hadiths_questions.json'
      ],
      'العربية': [
        'rules/istifham_questions.json',
        'rules/nafi_questions.json',
        'rules/takdim_questions.json',
        'rules/tawkid_questions.json',
        'rules/nidaa_questions.json',
        'rules/taajjub_questions.json',
        'rules/madh_thamm_questions.json',
        'rules/tamanni_tarajji_questions.json',
        'rules/ard_tahdeed_questions.json',
        'rules/tahzeer_ighraa_questions.json',
        'literature/unit1_questions.json',
        'literature/unit2_questions.json',
        'literature/unit3_questions.json',
        'literature/unit4_questions.json',
        'literature/unit5_questions.json',
        'literature/unit6_questions.json',
        'literature/unit7_questions.json',
        'literature/unit8_questions.json',
        'literature/unit9_questions.json',
        'literature/unit10_questions.json',
      ],
    };

    try {
      final List<String> files = subjectFiles[widget.subjectName] ?? [];
      for (var file in files) {
        String path;
        if (widget.subjectName == 'الإسلامية') {
          path = 'assets/jsons/subjects/islamic/$file';
        } else {
          // For Arabic, file string includes 'rules/' or 'literature/'
          path = 'assets/jsons/subjects/arabic/$file';
        }

        final String response = await rootBundle.loadString(path);
        final data = json.decode(response);
        
        if (widget.subjectName == 'العربية') {
          String category = data['category'] ?? "القواعد";
          if (!subjectData.containsKey(category)) {
            subjectData[category] = {'lessons': []};
          }
          (subjectData[category]['lessons'] as List).add({
            'lesson_title': data['subject'],
            'data': data
          });
        } else {
          String chapterTitle = data['unit'] ?? data['topic'] ?? "قسم غير مسمى";
          subjectData[chapterTitle] = data;
        }
      }
      setState(() => isInitialLoading = false);
    } catch (e) {
      debugPrint("Error initializing data: $e");
      setState(() => isInitialLoading = false);
    }
  }

  void applyFilter() {
    if (selectedChapter == null) return;
    
    final chapterData = subjectData[selectedChapter];
    List<dynamic> questionsList = [];

    if (chapterData.containsKey('questions')) {
      questionsList = chapterData['questions'];
    } else if (chapterData.containsKey('lessons')) {
      final lessons = chapterData['lessons'] as List;
      final lesson = lessons.firstWhere((l) => l['lesson_title'] == selectedTopic, orElse: () => null);
      
      if (lesson != null) {
        if (widget.subjectName == 'العربية') {
          final data = lesson['data'];
          if (data.containsKey('parts')) {
            for (var part in data['parts']) {
              String partName = part['part'];
              if (part['questions'] != null) {
                for (var q in part['questions']) {
                  Map<String, dynamic> questionWithTag = Map<String, dynamic>.from(q);
                  questionWithTag['section_tag'] = partName;
                  questionsList.add(questionWithTag);
                }
              }
            }
          }
        } else {
          if (lesson['hadith_text'] != null) {
            questionsList.add({
              'question': "نص الحديث الشريف",
              'answer': lesson['hadith_text'],
              'isHeader': true 
            });
          }
          
          if (lesson['sections'] != null) {
            for (var section in lesson['sections']) {
              String sectionTitle = section['section_title'] ?? "";
              if (section['questions'] != null) {
                for (var q in section['questions']) {
                  q['section_tag'] = sectionTitle;
                  questionsList.add(q);
                }
              }
              if (section['discussion_questions'] != null) {
                for (var q in section['discussion_questions']) {
                  q['section_tag'] = "$sectionTitle - مناقشة";
                  questionsList.add(q);
                }
              }
              if (section['story_groups'] != null) {
                for (var group in section['story_groups']) {
                  if (group['questions'] != null) {
                    for (var q in group['questions']) {
                      q['section_tag'] = "${group['story_title']} - قصة";
                      questionsList.add(q);
                    }
                  }
                  if (group['discussion_questions'] != null) {
                    for (var q in group['discussion_questions']) {
                      q['section_tag'] = "${group['story_title']} - مناقشة";
                      questionsList.add(q);
                    }
                  }
                }
              }
            }
          }
        }
      }
    }

    setState(() {
      filteredQuestions = questionsList;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: Text("وزاريات ${widget.subjectName}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: isInitialLoading ? null : () => showSelectionSheet(context, primaryColor),
          ),
        ],
      ),
      body: isInitialLoading 
          ? const Center(child: CircularProgressIndicator()) 
          : buildQuestionsList(primaryColor, secondaryColor),
    );
  }

  Widget buildQuestionsList(Color primaryColor, Color secondaryColor) {
    if (filteredQuestions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20)],
              ),
              child: Icon(Icons.history_edu_rounded, size: 50, color: primaryColor.withValues(alpha: 0.3)),
            ),
            const SizedBox(height: 20),
            const Text("يرجى اختيار المادة لعرض الوزاريات", style: TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w600)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: filteredQuestions.length,
      separatorBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, Colors.blueGrey.withValues(alpha: 0.15), Colors.transparent],
            ),
          ),
        ),
      ),
      itemBuilder: (context, index) => buildMinisterialItem(filteredQuestions[index], index, primaryColor, secondaryColor),
    );
  }

  Widget buildMinisterialItem(Map<String, dynamic> item, int index, Color primaryColor, Color secondaryColor) {
    final List<dynamic> years = item['years'] ?? [];
    final String? tag = item['section_tag'];
    final bool isHeader = item['isHeader'] ?? false;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(Icons.history_edu_rounded, size: 18, color: primaryColor),
                const SizedBox(width: 10),
                Text(
                  tag ?? "سؤال وزاري ${index + 1}",
                  style: TextStyle(color: Colors.blueGrey[800], fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
          ),
          if (years.isNotEmpty) ...[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                spacing: 8, runSpacing: 8,
                children: years.map((year) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: secondaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                  child: Text(year.toString(), style: TextStyle(color: secondaryColor, fontSize: 11, fontWeight: FontWeight.bold)),
                )).toList(),
              ),
            ),
          ],
          if (item['verse'] != null && item['verse'].toString().isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Container(
                width: double.infinity, padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.withValues(alpha: 0.1)),
                ),
                child: Text(
                  item['verse'], textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF15803D), fontFamily: 'Amiri', height: 1.8),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
            child: Text(
              item['question'] ?? (item['word'] != null ? "ما معنى كلمة: ${item['word']}" : ""),
              style: TextStyle(fontSize: 16, fontWeight: isHeader ? FontWeight.bold : FontWeight.w600, height: 1.6, color: const Color(0xFF1E293B)),
            ),
          ),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Text("عرض الجواب النموذجي", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: secondaryColor)),
              iconColor: secondaryColor, collapsedIconColor: secondaryColor,
              tilePadding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                  child: Container(
                    width: double.infinity, padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (item['answers'] != null) buildTajweedTable(item['answers']),
                        if (item['answer'] != null || item['meaning'] != null)
                          Text(item['answer'] ?? item['meaning'], style: const TextStyle(fontSize: 14, height: 1.7, color: Colors.black87)),
                        if (item['note'] != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text("• ملاحظة: ${item['note']}", style: const TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                        if (item['extra_answer'] != null) ...[
                          const Divider(height: 25),
                          Text(item['extra_answer']['definition'] ?? item['extra_answer']['text'] ?? "", style: const TextStyle(fontSize: 14, height: 1.7)),
                        ]
                      ],
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

  void showSelectionSheet(BuildContext context, Color primaryColor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            List<String> chapters = subjectData.keys.toList();
            List<String> topics = [];
            if (selectedChapter != null && subjectData[selectedChapter]!.containsKey('lessons')) {
              topics = (subjectData[selectedChapter]['lessons'] as List).map((l) => l['lesson_title'].toString()).toList();
            }

            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("اختيار مادة الوزاريات", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  buildDropdown("الوحدة / القسم", Icons.folder_open_rounded, chapters, selectedChapter, (val) {
                    setModalState(() { selectedChapter = val; selectedTopic = null; });
                    setState(() { selectedChapter = val; selectedTopic = null; });
                  }),
                  if (topics.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    buildDropdown("الموضوع", Icons.topic_outlined, topics, selectedTopic, (val) {
                      setModalState(() => selectedTopic = val);
                      setState(() => selectedTopic = val);
                    }, isEnabled: selectedChapter != null),
                  ],
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity, height: 50,
                    child: ElevatedButton(
                      onPressed: (selectedChapter != null && (topics.isEmpty || selectedTopic != null))
                          ? () { Navigator.pop(context); applyFilter(); }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor, foregroundColor: Colors.white,
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

  Widget buildDropdown(String hint, IconData icon, List<String> items, String? value, ValueChanged<String?> onChanged, {bool isEnabled = true}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isEnabled ? Colors.grey[50] : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true, value: value,
          hint: Row(children: [Icon(icon, size: 20, color: Colors.grey[400]), const SizedBox(width: 12), Text(hint, style: TextStyle(color: Colors.grey[400]))]),
          items: isEnabled ? items.map((item) => DropdownMenuItem(value: item, child: Text(item, style: const TextStyle(fontSize: 13)))).toList() : null,
          onChanged: isEnabled ? onChanged : null,
        ),
      ),
    );
  }

  Widget buildTajweedTable(List<dynamic> answers) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 15, headingRowHeight: 35,
        columns: const [DataColumn(label: Text("الكلمة")), DataColumn(label: Text("الحكم")), DataColumn(label: Text("السبب"))],
        rows: answers.map((a) => DataRow(cells: [
          DataCell(Text(a['word']??"", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue))),
          DataCell(Text(a['ruling']??"")),
          DataCell(Text(a['reason']??"", style: const TextStyle(fontSize: 11))),
        ])).toList(),
      ),
    );
  }
}
