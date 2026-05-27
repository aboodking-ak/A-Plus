import 'package:flutter/material.dart';

class MindMapsScreen extends StatefulWidget {
  const MindMapsScreen({super.key});

  @override
  State<MindMapsScreen> createState() => _MindMapsScreenState();
}

class _MindMapsScreenState extends State<MindMapsScreen> {
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(
        title: const Text("خرائط ذهنية", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.hub_outlined, size: 100, color: primaryColor.withOpacity(0.2)),
            const SizedBox(height: 20),
            const Text("قريباً... أداة الخرائط الذهنية", 
                style: TextStyle(fontSize: 18, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
