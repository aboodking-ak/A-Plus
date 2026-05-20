import 'package:flutter/material.dart';

class SurahScreen extends StatefulWidget {
  const SurahScreen({super.key});

  @override
  State<SurahScreen> createState() => _SurahScreenState();
}

class _SurahScreenState extends State<SurahScreen> {
  String? selectedSurah;
  bool isPlaying = false;

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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
            child: _buildSurahSelector(),
          ),
        ),
      ),
      body: _buildSurahContent(primaryColor),
    );
  }

  Widget _buildSurahSelector() {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.white.withAlpha(50)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: const Text("اختر السورة", style: TextStyle(fontSize: 13)),
          value: selectedSurah,
          items: surahs.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            );
          }).toList(),
          onChanged: (val) => setState(() => selectedSurah = val),
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
            Icon(Icons.menu_book_rounded, size: 80, color: primaryColor.withAlpha(40)),
            const SizedBox(height: 16),
            const Text("يرجى اختيار السورة للعرض والاستماع",
                style: TextStyle(color: Colors.blueGrey, fontSize: 15, fontWeight: FontWeight.w500)),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // لوحة التحكم بالصوت
          _buildAudioPlayer(primaryColor),
          const SizedBox(height: 30),
          // عرض نص السورة
          _buildSurahTextCard(primaryColor),
        ],
      ),
    );
  }

  Widget _buildAudioPlayer(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: primaryColor.withAlpha(40), offset: const Offset(0, 4), blurRadius: 0),
        ],
        border: Border.all(color: Colors.blueGrey[50]!),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_filled_rounded),
            iconSize: 50,
            color: primaryColor,
            onPressed: () => setState(() => isPlaying = !isPlaying),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("استماع إلى ${selectedSurah!}",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 5),
                LinearProgressIndicator(
                  value: 0.3,
                  backgroundColor: Colors.grey[200],
                  color: primaryColor,
                ),
              ],
            ),
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
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: primaryColor.withAlpha(40), offset: const Offset(0, 6), blurRadius: 0),
        ],
        border: Border.all(color: Colors.blueGrey[50]!),
      ),
      child: Column(
        children: [
          Text(selectedSurah!,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor)),
          const Divider(height: 40),
          const Text(
            "بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ\n\nالم (1) ذَلِكَ الْكِتَابُ لَا رَيْبَ فِيهِ هُدًى لِلْمُتَّقِينَ (2) الَّذِينَ يُؤْمِنُونَ بِالْغَيْبِ وَيُقِيمُونَ الصَّلَاةَ وَمِمَّا رَزَقْنَاهُمْ يُنْفِقُونَ (3) وَالَّذِينَ يُؤْمِنُونَ بِمَا أُنْزِلَ إِلَيْكَ وَمَا أُنْزِلَ مِنْ قَبْلِكَ وَبِالْآخِرَةِ هُمْ يُوقِنُونَ (4) أُولَئِكَ عَلَى هُدًى مِنْ رَبِّهِمْ وَأُولَئِكَ هُمُ الْمُفْلِحُونَ (5)",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, height: 2, fontWeight: FontWeight.w500, fontFamily: 'Traditional Arabic'),
          ),
        ],
      ),
    );
  }
}
