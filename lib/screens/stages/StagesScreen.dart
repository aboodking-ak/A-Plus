import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: CustomScrollView(
          slivers: [
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index >= 6) return null;
                  final stage = stages[index];
                  final isSelected = selectedStage == stage['label'];
                  return _buildStageCard(stage, isSelected);
                },
                childCount: 6,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 15)),
            SliverToBoxAdapter(
              child: _buildStageCard(
                stages[6],
                selectedStage == stages[6]['label'],
                isFullWidth: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStageCard(Map<String, String> stage, bool isSelected,
      {bool isFullWidth = false}) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedStage = stage['label'];
        });
      },
      child: Container(
        height: isFullWidth ? 70 : null,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? secondaryColor : Colors.grey[100]!,
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
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
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Image.asset(
                stage['icon']!,
                height: 35,
                width: 35,
                errorBuilder: (c, e, s) => Icon(Icons.book, color: primaryColor),
              ),
            ],
          ),
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
