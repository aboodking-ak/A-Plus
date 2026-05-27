import 'package:flutter/material.dart';

class SurahScreen extends StatefulWidget {
  const SurahScreen({super.key});

  @override
  State<SurahScreen> createState() => _SurahScreenState();
}

class _SurahScreenState extends State<SurahScreen> {
  String? selectedSurah;
  bool isPlaying = false;
  double audioPosition = 0.3; // قيمة تجريبية للشريط

  final List<String> surahs = ["سورة البقرة", "سورة آل عمران", "سورة النساء", "سورة المائدة"];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    const backgroundColor = Color(0xFFF1F5F9);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("سور الحفظ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
      body: Stack(
        children: [
          _buildSurahContent(primaryColor),
          if (selectedSurah != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildFloatingAudioPlayer(primaryColor),
            ),
        ],
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
                    "اختيار السورة",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  _buildModalDropdown(
                    "السورة",
                    Icons.menu_book_rounded,
                    surahs,
                    selectedSurah,
                    (val) {
                      setModalState(() => selectedSurah = val);
                      setState(() => selectedSurah = val);
                    },
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: (selectedSurah != null)
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

  Widget _buildSurahContent(Color primaryColor) {
    if (selectedSurah == null) {
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
              child: Icon(Icons.menu_book_rounded, size: 50, color: primaryColor.withValues(alpha: 0.3)),
            ),
            const SizedBox(height: 20),
            const Text(
              "يرجى اختيار السورة للعرض والاستماع",
              style: TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 140), // مساحة كافية للمشغل العائم الجديد
      child: Column(
        children: [
          _buildSectionHeader("سورة الحفظ", primaryColor),
          _buildSurahTextCard(primaryColor),
          
          const SizedBox(height: 10),
          _buildSectionHeader("الكلمة ومعناها", primaryColor),
          _buildVocabularyCard(primaryColor),
          
          const SizedBox(height: 10),
          _buildSectionHeader("المعنى العام", primaryColor),
          _buildGeneralMeaningCard(primaryColor),
        ],
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

  Widget _buildSurahTextCard(Color primaryColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), offset: const Offset(0, 2), blurRadius: 5),
        ],
      ),
      child: Column(
        children: [
          Text(selectedSurah!,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryColor)),
          const Divider(height: 40, thickness: 1),
          const Text(
            "بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ\n\nالم (1) ذَلِكَ الْكِتَابُ لَا رَيْبَ فِيهِ هُدًى لِلْمُتَّقِينَ (2) الَّذِينَ يُؤْمِنُونَ بِالْغَيْبِ وَيُقِيمُونَ الصَّلَاةَ وَمِمَّا رَزَقْنَاهُمْ يُنْفِقُونَ (3) وَالَّذِينَ يُؤْمِنُونَ بِمَا أُنْزِلَ إِلَيْكَ وَمَا أُنْزِلَ مِنْ قَبْلِكَ وَبِالْآخِرَةِ هُمْ يُوقِنُونَ (4) أُولَئِكَ عَلَى هُدًى مِنْ رَبِّهِمْ وَأُولَئِكَ هُمُ الْمُفْلِحُونَ (5)",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 19, height: 2, fontWeight: FontWeight.w500, fontFamily: 'Traditional Arabic'),
          ),
        ],
      ),
    );
  }

  Widget _buildVocabularyCard(Color primaryColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          _buildVocabRow("لا ريب فيه", "لا شك فيه", true),
          _buildVocabRow("هدى للمتقين", "رشاد للمؤمنين", false),
          _buildVocabRow("يقيمون الصلاة", "يؤدونها بشروطها", true),
          _buildVocabRow("ينفقون", "يتصدقون", false),
        ],
      ),
    );
  }

  Widget _buildVocabRow(String word, String meaning, bool isGray) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
      decoration: BoxDecoration(
        color: isGray ? Colors.grey[50] : Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(child: Text(word, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue))),
          const Icon(Icons.arrow_forward, size: 14, color: Colors.grey),
          const SizedBox(width: 15),
          Expanded(child: Text(meaning, style: const TextStyle(color: Color(0xFF475569)))),
        ],
      ),
    );
  }

  Widget _buildGeneralMeaningCard(Color primaryColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMeaningItem("الم (1)", "حروف مقطعة تدل على إعجاز القرآن الكريم الذي نزل بلغة العرب."),
          const SizedBox(height: 15),
          _buildMeaningItem("ذَلِكَ الْكِتَابُ لَا رَيْبَ فِيهِ (2)", "هذا القرآن هو الكتاب العظيم الذي لا يشك في كونه من عند الله."),
        ],
      ),
    );
  }

  Widget _buildMeaningItem(String verse, String explanation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(verse, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 15)),
        const SizedBox(height: 5),
        Text(explanation, style: const TextStyle(fontSize: 14, height: 1.6, color: Color(0xFF475569))),
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
            BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, 8)),
          ],
          border: Border.all(color: primaryColor.withValues(alpha: 0.08)),
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
                        selectedSurah!,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B)),
                      ),
                      const Text("03:45 / 00:00", style: TextStyle(fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 3,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
                      activeTrackColor: primaryColor,
                      inactiveTrackColor: primaryColor.withValues(alpha: 0.1),
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
