import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExamsScreen extends StatefulWidget {
  final String subjectName;
  const ExamsScreen({super.key, required this.subjectName});

  @override
  State<ExamsScreen> createState() => _ExamsScreenState();
}

class _ExamsScreenState extends State<ExamsScreen> {
  String? selectedChapter;
  String? selectedTopic;
  bool isInitialLoading = true;

  final PageController _pageController = PageController();
  int _currentIndex = 0;
  bool _showAnswer = false;

  Map<String, dynamic> subjectData = {};
  List<dynamic> currentQuestions = [];

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
        'unit5_questions.json'
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
      'الإنجليزية': [
        'essays.json'
      ],
    };

    try {
      final List<String> files = subjectFiles[widget.subjectName] ?? [];
      for (var file in files) {
        String path;
        if (widget.subjectName == 'الإسلامية') {
          path = 'assets/jsons/subjects/islamic/$file';
        } else if (widget.subjectName == 'الإنجليزية') {
          path = 'assets/jsons/subjects/english/$file';
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
        } else if (widget.subjectName == 'الإنجليزية') {
          final List<dynamic> units = data['units'] ?? [];
          for (var unit in units) {
            String chapterTitle = unit['title'] ?? "قسم غير مسمى";
            subjectData[chapterTitle] = {
              'unit': unit['title'],
              'questions': unit['essays']
            };
          }
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
      questionsList = List.from(chapterData['questions']);
    } else if (chapterData.containsKey('lessons')) {
      final lessons = chapterData['lessons'] as List;
      final lesson = lessons.firstWhere((l) => l['lesson_title'] == selectedTopic, orElse: () => null);

      if (lesson != null) {
        if (widget.subjectName == 'العربية') {
          final data = lesson['data'];
          if (data.containsKey('parts')) {
            for (var part in data['parts']) {
              if (part['questions'] != null) {
                questionsList.addAll(List.from(part['questions']));
              }
            }
          }
        } else {
          if (lesson['sections'] != null) {
            for (var section in lesson['sections']) {
              if (section['questions'] != null) {
                questionsList.addAll(List.from(section['questions']));
              }
              if (section['discussion_questions'] != null) {
                questionsList.addAll(List.from(section['discussion_questions']));
              }
              if (section['story_groups'] != null) {
                for (var group in section['story_groups']) {
                  if (group['questions'] != null) {
                    questionsList.addAll(List.from(group['questions']));
                  }
                  if (group['discussion_questions'] != null) {
                    questionsList.addAll(List.from(group['discussion_questions']));
                  }
                }
              }
            }
          }
        }
      }
    }

    // خلط الأسئلة عشوائياً واختيار 10 فقط
    questionsList.shuffle();
    if (questionsList.length > 10) {
      questionsList = questionsList.take(10).toList();
    }

    setState(() {
      currentQuestions = questionsList;
      _currentIndex = 0;
      _showAnswer = false;
    });

    if (_pageController.hasClients) {
      _pageController.jumpToPage(0);
    }
  }

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
          : buildQuestionsList(primaryColor),
    );
  }

  void showSelectionSheet(BuildContext context, Color primaryColor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
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
                  const Text(
                    "اختيار مادة الاختبار",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  buildDropdown(
                    "الوحدة / القسم",
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
                  if (topics.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    buildDropdown(
                      "الموضوع",
                      Icons.topic_outlined,
                      topics,
                      selectedTopic,
                      (val) {
                        setModalState(() => selectedTopic = val);
                        setState(() => selectedTopic = val);
                      },
                      isEnabled: selectedChapter != null,
                    ),
                  ],
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: (selectedChapter != null && (topics.isEmpty || selectedTopic != null))
                          ? () {
                              Navigator.pop(context);
                              applyFilter();
                            }
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
          isExpanded: true,
          value: value,
          hint: Row(
            children: [
              Icon(icon, size: 20, color: Colors.grey[400]),
              const SizedBox(width: 12),
              Text(hint, style: TextStyle(color: Colors.grey[400])),
            ],
          ),
          items: isEnabled ? items.map((item) => DropdownMenuItem(value: item, child: Text(item, style: const TextStyle(fontSize: 13)))).toList() : null,
          onChanged: isEnabled ? onChanged : null,
        ),
      ),
    );
  }

  Widget buildQuestionsList(Color primaryColor) {
    if (currentQuestions.isEmpty) {
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
                    "السؤال ${_currentIndex + 1} من ${currentQuestions.length}",
                    style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  Text(
                    "${((_currentIndex + 1) / currentQuestions.length * 100).toInt()}%",
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: (_currentIndex + 1) / currentQuestions.length,
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
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
                _showAnswer = false;
              });
            },
            itemCount: currentQuestions.length,
            itemBuilder: (context, index) {
              final item = currentQuestions[index];
              final String questionText = item['question'] ?? (item['word'] != null ? "ما معنى كلمة: ${item['word']}" : "");
              final String answerText = item['answer'] ?? item['meaning'] ?? "لا يوجد جواب متاح";

              return SingleChildScrollView(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (item['verse'] != null && item['verse'].toString().isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
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
                    Text(
                      questionText,
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
                      if (item['answers'] != null) buildTajweedTable(item['answers']),
                      if (item['answers'] == null)
                        Text(
                          answerText,
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.7,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      if (item['note'] != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text("• ملاحظة: ${item['note']}", style: const TextStyle(color: Colors.redAccent, fontSize: 13, fontWeight: FontWeight.bold)),
                        ),
                      if (item['extra_answer'] != null) ...[
                        const Divider(height: 35),
                        Text(item['extra_answer']['definition'] ?? item['extra_answer']['text'] ?? "", style: const TextStyle(fontSize: 15, height: 1.7)),
                      ]
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
                    } else if (_currentIndex < currentQuestions.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Text(
                    !_showAnswer 
                        ? "عرض الجواب" 
                        : (_currentIndex < currentQuestions.length - 1 ? "السؤال التالي" : "إنهاء الاختبار"),
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
