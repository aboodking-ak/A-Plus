import 'package:flutter/material.dart';

class EssaysScreen extends StatefulWidget {
  const EssaysScreen({super.key});

  @override
  State<EssaysScreen> createState() => _EssaysScreenState();
}

class _EssaysScreenState extends State<EssaysScreen> {
  String? selectedEssay;
  bool isPlaying = false;
  double audioPosition = 0.5; // قيمة تجريبية للشريط

  final List<String> essays = [
    "Unit 1: A cigarette commercial",
    "Unit 2: Applying for a job",
    "Unit 3: Benefits of studying English",
    "Unit 5: A wonderful holiday",
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    const backgroundColor = Color(0xFFF1F5F9);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("الإنشاءات الإنجليزية", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
          _buildEssayContent(primaryColor),
          if (selectedEssay != null)
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
                    "اختيار الإنشاء",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: _buildModalDropdown(
                      "Essay",
                      Icons.edit_note_rounded,
                      essays,
                      selectedEssay,
                      (val) {
                        setModalState(() => selectedEssay = val);
                        setState(() => selectedEssay = val);
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: (selectedEssay != null)
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
          items: isEnabled
              ? items
                  .map((item) => DropdownMenuItem(
                      value: item,
                      child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(item, textAlign: TextAlign.left))))
                  .toList()
              : null,
          onChanged: isEnabled ? onChanged : null,
        ),
      ),
    );
  }

  Widget _buildEssayContent(Color primaryColor) {
    if (selectedEssay == null) {
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
              child: Icon(Icons.edit_note_rounded, size: 50, color: primaryColor.withValues(alpha: 0.3)),
            ),
            const SizedBox(height: 20),
            const Text(
              "يرجى اختيار الإنشاء للعرض والاستماع",
              style: TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 140),
      child: Column(
        children: [
          _buildSectionHeader("نص الإنشاء (English)", primaryColor),
          _buildEssayTextCard(primaryColor),
          
          const SizedBox(height: 10),
          _buildSectionHeader("الترجمة (Translation)", primaryColor),
          _buildTranslationCard(primaryColor),
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

  Widget _buildEssayTextCard(Color primaryColor) {
    const String essayText = "Cigarette advertising should be illegal. Firstly, it encourages young people to start smoking, which is very harmful to their health. Secondly, the advertisements often make smoking look attractive and successful, which is misleading. Moreover, the government spends a lot of money on healthcare for smoking-related illnesses, so it is better to prevent smoking by banning these ads. In conclusion, banning cigarette commercials is a necessary step to protect public health and the younger generation.";
    final int wordCount = essayText.split(' ').length;

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
          Directionality(
            textDirection: TextDirection.ltr,
            child: Text(selectedEssay!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor)),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: primaryColor.withValues(alpha: 0.1)),
            ),
            child: Text(
              "$wordCount Words",
              style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 11),
            ),
          ),
          const Divider(height: 40, thickness: 1),
          const Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              essayText,
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 17, height: 1.8, fontWeight: FontWeight.w500, color: Color(0xFF334155)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTranslationCard(Color primaryColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: const Text(
        "يجب أن تكون إعلانات السجائر غير قانونية. أولاً، إنها تشجع الشباب على البدء بالتدخين، وهو أمر ضار جداً بصحتهم. ثانياً، غالباً ما تجعل الإعلانات التدخين يبدو جذاباً وناجحاً، وهو أمر مضلل. علاوة على ذلك، تنفق الحكومة الكثير من المال على الرعاية الصحية للأمراض المرتبطة بالتدخين، لذا فمن الأفضل منع التدخين عن طريق حظر هذه الإعلانات. في الختام، يعد حظر إعلانات السجائر خطوة ضرورية لحماية الصحة العامة وجيل الشباب.",
        textAlign: TextAlign.justify,
        style: TextStyle(fontSize: 17, height: 1.8, fontWeight: FontWeight.w500, color: Color(0xFF334155)),
      ),
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
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            children: [
              IconButton(
                icon: Icon(isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_filled_rounded),
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
                        Expanded(
                          child: Text(
                            selectedEssay!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text("02:15 / 00:00", style: TextStyle(fontSize: 10, color: Colors.grey)),
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
      ),
    );
  }
}
