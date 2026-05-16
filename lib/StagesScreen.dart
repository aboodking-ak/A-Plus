import 'package:flutter/material.dart';

class StagesScreen extends StatefulWidget {
  const StagesScreen({super.key});

  @override
  State<StagesScreen> createState() => _StagesScreenState();
}

class _StagesScreenState extends State<StagesScreen> {
  String? selectedStage;

  final List<Map<String, String>> stages = [
    {'label': 'سادس علمي', 'icon': 'assets/icons/sixth_scientific.png'},
    {'label': 'سادس أدبي', 'icon': 'assets/icons/sixth_literary.png'},
    {'label': 'خامس علمي', 'icon': 'assets/icons/fifth_scientific.png'},
    {'label': 'خامس أدبي', 'icon': 'assets/icons/fifth_literary.png'},
    {'label': 'رابع علمي', 'icon': 'assets/icons/fourth_scientific.png'},
    {'label': 'رابع أدبي', 'icon': 'assets/icons/fourth_literary.png'},
    {'label': 'ثالث متوسط', 'icon': 'assets/icons/third.png'},
  ];

  Widget _buildStageCard(Map<String, String> stage, bool isSelected, {bool isFullWidth = false}) {
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
        height: isFullWidth ? 70 : null, // تحديد ارتفاع للبطاقة العريضة
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? secondaryColor : Colors.grey[100]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
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
            // الأشكال الخلفية
            Positioned(
              top: -60,
              left: -60,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: primaryColor,
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
                  color: primaryColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(180),
                  ),
                ),
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // اللوجو
                  Center(
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
                          'assets/icons/logo.png',
                          width: 80,
                          errorBuilder: (context, error, stackTrace) => Icon(Icons.school, size: 60, color: primaryColor),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 30),

                  // شبكة المراحل الدراسية
                  Expanded(
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
                                if (index >= 6) return null; // أول 6 عناصر فقط (علمي وأدبي)
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
                              stages[6], // الثالث متوسط
                              selectedStage == stages[6]['label'],
                              isFullWidth: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // زر متابعة
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: selectedStage == null ? null : () {
                          Navigator.pushReplacementNamed(
                            context, 
                            '/home', 
                            arguments: selectedStage
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          disabledBackgroundColor: Colors.grey[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
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
