import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LiteratureScreen extends StatefulWidget {
  const LiteratureScreen({super.key});

  @override
  State<LiteratureScreen> createState() => _LiteratureScreenState();
}

class _LiteratureScreenState extends State<LiteratureScreen> {
  Map<String, dynamic>? data;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final String response = await rootBundle.loadString('assets/jsons/subjects/english/literature.json');
      setState(() {
        data = json.decode(response);
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading literature data: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text("الأدب", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Tajawal')),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.auto_stories_rounded, size: 80, color: primaryColor.withAlpha(50)),
                  const SizedBox(height: 20),
                  const Text(
                    "سيتم إضافة المحتوى قريباً",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Tajawal', color: Colors.grey),
                  ),
                ],
              ),
            ),
    );
  }
}
