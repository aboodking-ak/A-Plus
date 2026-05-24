import 'package:flutter/material.dart';
import '../../core/constants/app_assets.dart';

class StagesScreen extends StatefulWidget {
  const StagesScreen({super.key});

  @override
  State<StagesScreen> createState() => _StagesScreenState();
}

class _StagesScreenState extends State<StagesScreen> {
  @override
  void initState() {
    super.initState();
  }

  String? selectedStage;

  final List<Map<String, String>> stages = [
    {'label': 'سادس علمي', 'icon': AppAssets.sixthScientific},
    {'label': 'سادس أدبي', 'icon': AppAssets.sixthLiterary},
    {'label': 'خامس علمي', 'icon': AppAssets.fifthScientific},
    {'label': 'خامس أدبي', 'icon': AppAssets.fifthLiterary},
    {'label': 'رابع علمي', 'icon': AppAssets.fourthScientific},
    {'label': 'رابع أدبي', 'icon': AppAssets.fourthLiterary},
    {'label': 'ثالث متوسط', 'icon': AppAssets.thirdIntermediate},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            _buildBackgroundShapes(primaryColor),
            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildLogo(primaryColor, secondaryColor),
                  const SizedBox(height: 20),
                  _buildHeader(primaryColor),
                  const SizedBox(height: 30),
                  _buildStagesGrid(),
                  _buildContinueButton(primaryColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundShapes(Color color) {
    return Stack(
      children: [
        Positioned(
          top: -60,
          left: -60,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(180),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -60,
          right: -60,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(180),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogo(Color primaryColor, Color secondaryColor) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[100]!, width: 1),
            ),
          ),
          SizedBox(
            width: 115,
            height: 115,
            child: CircularProgressIndicator(
              value: 0.35,
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
            ),
          ),
          Image.asset(
            AppAssets.logo,
            width: 80,
            errorBuilder: (context, error, stackTrace) =>
                Icon(Icons.school, size: 60, color: primaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(Color primaryColor) {
    return Column(
      children: [
        Text(
          "اختر مرحلتك الدراسية",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        Text(
          "لنقدم لك تجربة تعليمية تناسب احتياجاتك",
          style: TextStyle(fontSize: 13, color: Colors.grey[500]),
        ),
      ],
    );
  }

  Widget _buildStagesGrid() {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          // عرض أول 6 مراحل في صفوف (كل صف فيه مرحلتين)
          _buildRow(0, 1),
          const SizedBox(height: 15),
          _buildRow(2, 3),
          const SizedBox(height: 15),
          _buildRow(4, 5),
          const SizedBox(height: 15),
          
          // عرض المرحلة الأخيرة (ثالث متوسط) بعرض كامل
          _buildStageCard(stages[6], isFullWidth: true),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // دالة مساعدة لبناء صف يحتوي على كارتين بجانب بعضهما
  Widget _buildRow(int index1, int index2) {
    return Row(
      children: [
        Expanded(child: _buildStageCard(stages[index1])),
        const SizedBox(width: 15),
        Expanded(child: _buildStageCard(stages[index2])),
      ],
    );
  }

  Widget _buildStageCard(Map<String, String> stage, {bool isFullWidth = false}) {
    final isSelected = selectedStage == stage['label'];
    final primaryColor = Theme.of(context).colorScheme.primary;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    return GestureDetector(
      onTap: () => setState(() => selectedStage = stage['label']),
      child: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? secondaryColor : Colors.grey[200]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                stage['label']!,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? primaryColor : Colors.grey[700],
                ),
              ),
            ),
            Image.asset(stage['icon']!, height: 35, width: 35),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton(Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: selectedStage == null
              ? null
              : () {
                  Navigator.pushReplacementNamed(context, '/home',
                      arguments: selectedStage);
                },
          child: const Text(
            "متابعة",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}