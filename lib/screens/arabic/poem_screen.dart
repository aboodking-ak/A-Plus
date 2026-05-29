import 'package:flutter/material.dart';

class PoemScreen extends StatefulWidget {
  const PoemScreen({super.key});

  @override
  State<PoemScreen> createState() => _PoemScreenState();
}

class _PoemScreenState extends State<PoemScreen> {
  String? selectedPoem;
  bool isPlaying = false;
  double audioPosition = 0.0;

  final List<String> poems = [
    "قصيدة محمود سامي البارودي",
    "قصيدة الحبوبي (يا غزال الكرخ)",
    "قصيدة محمد سعيد الحبوبي",
    "قصيدة الجواهري (آمنت بالحسين)",
    "قصيدة إيليا أبو ماضي",
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    const backgroundColor = Color(0xFFF8FAFC);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: const Text("قصائد الأدب", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
          backgroundColor: primaryColor,
          elevation: 0,
          centerTitle: false,
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list_rounded),
              onPressed: () => _showSelectionBottomSheet(context, primaryColor),
            ),
          ],
        ),
        body: Stack(
          children: [
            _buildPoemContent(primaryColor),
            if (selectedPoem != null)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _buildFloatingAudioPlayer(primaryColor),
              ),
          ],
        ),
      ),
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
                    "اختيار القصيدة",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  _buildModalDropdown(
                    "القصيدة",
                    Icons.auto_stories_rounded,
                    poems,
                    selectedPoem,
                    (val) {
                      setModalState(() => selectedPoem = val);
                      setState(() => selectedPoem = val);
                    },
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: (selectedPoem != null)
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

  Widget _buildModalDropdown(String hint, IconData icon, List<String> items, String? value, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
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
          items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildPoemContent(Color primaryColor) {
    if (selectedPoem == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.library_books_rounded, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 20),
            const Text(
              "يرجى اختيار قصيدة للعرض والاستماع",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPoemHeader(primaryColor),
          const SizedBox(height: 30),
          _buildVersesSection(primaryColor),
          const SizedBox(height: 40),
          _buildMeaningsSection(primaryColor),
        ],
      ),
    );
  }

  Widget _buildPoemHeader(Color primaryColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: primaryColor.withAlpha(50), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        children: [
          Text(
            selectedPoem!,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(51),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "للشاعر: محمود سامي البارودي",
              style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVersesSection(Color primaryColor) {
    final List<Map<String, String>> verses = [
      {'sadr': 'أبيتُ في غربةٍ لا النفسُ راضيةٌ', 'ajuz': 'بها، ولا ملتقى من شيعتي كثبُ'},
      {'sadr': 'فلا رفيـقٌ تسرُّ النفسُ طلعتـهُ', 'ajuz': 'ولا صديقٌ يرى ما بي فيكتئبُ'},
      {'sadr': 'أقمتُ بالنيـلِ لا عن طوعِ معرفـةٍ', 'ajuz': 'بها، ولكنْ هو المقدارُ والغلبُ'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("أبيات القصيدة", primaryColor),
        const SizedBox(height: 20),
        ...verses.map((v) => _buildVerseItem(v['sadr']!, v['ajuz']!, primaryColor)),
      ],
    );
  }

  Widget _buildVerseItem(String sadr, String ajuz, Color primaryColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(sadr, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Tajawal')),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(ajuz, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Tajawal')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMeaningsSection(Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("معاني الكلمات", primaryColor),
        const SizedBox(height: 15),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              _buildMeaningRow("شيعتي", "أتباعي وأنصاري", true),
              _buildMeaningRow("كثب", "قرب", false),
              _buildMeaningRow("المقدار", "القضاء والقدر", true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMeaningRow(String word, String meaning, bool isGray) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
      decoration: BoxDecoration(
        color: isGray ? Colors.grey[50] : Colors.white,
      ),
      child: Row(
        children: [
          Expanded(child: Text(word, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue))),
          const Icon(Icons.arrow_left_rounded, size: 24, color: Colors.grey),
          const SizedBox(width: 15),
          Expanded(child: Text(meaning, style: const TextStyle(color: Colors.black87))),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color primaryColor) {
    return Row(
      children: [
        Container(width: 4, height: 20, decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 10),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildFloatingAudioPlayer(Color primaryColor) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(15, 0, 15, 10),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(25), blurRadius: 20, offset: const Offset(0, 8)),
          ],
          border: Border.all(color: primaryColor.withAlpha(20)),
        ),
        child: Row(
          children: [
            IconButton(
              icon: Transform.flip(
                flipX: true,
                child: Icon(isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_filled_rounded),
              ),
              iconSize: 48,
              color: primaryColor,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () => setState(() => isPlaying = !isPlaying),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedPoem!,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B)),
                      ),
                      const Text("03:20 / 00:00", style: TextStyle(fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 3,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
                      activeTrackColor: primaryColor,
                      inactiveTrackColor: primaryColor.withAlpha(25),
                      thumbColor: primaryColor,
                    ),
                    child: Slider(
                      value: audioPosition,
                      onChanged: (val) => setState(() => audioPosition = val),
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
