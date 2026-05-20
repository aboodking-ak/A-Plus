import 'package:flutter/material.dart';

class EssaysScreen extends StatefulWidget {
  const EssaysScreen({super.key});

  @override
  State<EssaysScreen> createState() => _EssaysScreenState();
}

class _EssaysScreenState extends State<EssaysScreen> {
  String? selectedEssay;
  bool isPlaying = false;

  final List<String> essays = [
    "Unit 1: A cigarette commercial",
    "Unit 2: Applying for a job",
    "Unit 3: Benefits of studying English in the UK",
    "Unit 5: A wonderful holiday",
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;
    const backgroundColor = Color(0xFFF1F5F9);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Directionality(
          textDirection: TextDirection.ltr,
          child: Text("English Essays (الإنشاءات)",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
              child: _buildEssaySelector(),
            ),
          ),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.ltr,
        child: _buildEssayContent(primaryColor, secondaryColor),
      ),
    );
  }

  Widget _buildEssaySelector() {
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
          hint: const Text("Choose an Essay", style: TextStyle(fontSize: 13)),
          value: selectedEssay,
          items: essays.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            );
          }).toList(),
          onChanged: (val) => setState(() => selectedEssay = val),
        ),
      ),
    );
  }

  Widget _buildEssayContent(Color primaryColor, Color secondaryColor) {
    if (selectedEssay == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.edit_note_rounded, size: 80, color: primaryColor.withAlpha(40)),
            const SizedBox(height: 16),
            const Text("Please select an essay to view and listen",
                style: TextStyle(color: Colors.blueGrey, fontSize: 15, fontWeight: FontWeight.w500)),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Audio Player Controls
          _buildAudioPlayer(primaryColor),
          const SizedBox(height: 30),
          // Essay Text Card
          _buildEssayTextCard(primaryColor, secondaryColor),
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
                Text("Listen to: ${selectedEssay!}",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 5),
                LinearProgressIndicator(
                  value: 0.5,
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

  Widget _buildEssayTextCard(Color primaryColor, Color secondaryColor) {
    const String essayText = "Cigarette advertising should be illegal. Firstly, it encourages young people to start smoking, which is very harmful to their health. Secondly, the advertisements often make smoking look attractive and successful, which is misleading. Moreover, the government spends a lot of money on healthcare for smoking-related illnesses, so it is better to prevent smoking by banning these ads...";
    final int wordCount = essayText.split(' ').length;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(selectedEssay!,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: secondaryColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: secondaryColor, width: 1),
                ),
                child: Text(
                  "$wordCount Words",
                  style: TextStyle(color: secondaryColor, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          ),
          const Divider(height: 40),
          const Text(
            essayText,
            style: TextStyle(fontSize: 16, height: 1.8, fontWeight: FontWeight.w500, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
