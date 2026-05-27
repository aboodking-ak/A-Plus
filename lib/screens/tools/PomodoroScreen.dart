import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

enum PomodoroMode { study, shortBreak, longBreak }

class _PomodoroScreenState extends State<PomodoroScreen> {
  Timer? _timer;
  int _remainingSeconds = 25 * 60;
  bool _isRunning = false;
  PomodoroMode _currentMode = PomodoroMode.study;
  
  int _totalRounds = 4;
  int _currentRound = 1;

  final Map<PomodoroMode, int> _modeDurations = {
    PomodoroMode.study: 25 * 60,
    PomodoroMode.shortBreak: 5 * 60,
    PomodoroMode.longBreak: 15 * 60,
  };

  @override
  void initState() {
    super.initState();
    _loadSettings().then((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showSetupDialog();
      });
    });
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _modeDurations[PomodoroMode.study] = (prefs.getInt('pomodoro_study') ?? 25) * 60;
      _modeDurations[PomodoroMode.shortBreak] = (prefs.getInt('pomodoro_short') ?? 5) * 60;
      _modeDurations[PomodoroMode.longBreak] = (prefs.getInt('pomodoro_long') ?? 15) * 60;
      _totalRounds = prefs.getInt('pomodoro_rounds') ?? 4;
      _remainingSeconds = _modeDurations[_currentMode]!;
    });
  }

  Future<void> _saveSettings(int study, int short, int rounds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('pomodoro_study', study);
    await prefs.setInt('pomodoro_short', short);
    await prefs.setInt('pomodoro_rounds', rounds);
    
    setState(() {
      _modeDurations[PomodoroMode.study] = study * 60;
      _modeDurations[PomodoroMode.shortBreak] = short * 60;
      _totalRounds = rounds;
      _currentRound = 1;
      _currentMode = PomodoroMode.study;
      _remainingSeconds = _modeDurations[PomodoroMode.study]!;
    });
  }

  void _startTimer() {
    if (_isRunning) return;

    setState(() {
      _isRunning = true;
    });
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _pauseTimer();
        _handleTimerEnd();
      }
    });
  }

  void _handleTimerEnd() {
    SystemSound.play(SystemSoundType.alert);
    HapticFeedback.heavyImpact();
    
    // تكرار التنبيه لضمان سماعه
    Future.delayed(const Duration(milliseconds: 500), () {
      SystemSound.play(SystemSoundType.alert);
      HapticFeedback.vibrate();
    });

    if (_currentMode == PomodoroMode.study) {
      if (_currentRound < _totalRounds) {
        _switchMode(PomodoroMode.shortBreak);
        _startTimer();
      } else {
        _resetSession();
      }
    } else {
      _currentRound++;
      _switchMode(PomodoroMode.study);
      _startTimer();
    }
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
  }

  void _resetTimer() {
    _pauseTimer();
    setState(() {
      _remainingSeconds = _modeDurations[_currentMode]!;
    });
  }

  void _resetSession() {
    _pauseTimer();
    setState(() {
      _currentRound = 1;
      _currentMode = PomodoroMode.study;
      _remainingSeconds = _modeDurations[PomodoroMode.study]!;
    });
  }

  void _switchMode(PomodoroMode mode) {
    _pauseTimer();
    setState(() {
      _currentMode = mode;
      _remainingSeconds = _modeDurations[mode]!;
    });
  }

  void _showSetupDialog() {
    final studyController = TextEditingController(text: (_modeDurations[PomodoroMode.study]! ~/ 60).toString());
    final shortController = TextEditingController(text: (_modeDurations[PomodoroMode.shortBreak]! ~/ 60).toString());
    final roundsController = TextEditingController(text: _totalRounds.toString());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          left: 20,
          right: 20,
          top: 20,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const Text(
                "إعداد جلسة الدراسة",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildSettingField("وقت الدراسة (دقائق)", studyController, Icons.menu_book_rounded),
              _buildSettingField("وقت الاستراحة (دقائق)", shortController, Icons.coffee_rounded),
              _buildSettingField("عدد الدورات", roundsController, Icons.loop_rounded),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    int study = int.tryParse(studyController.text) ?? 25;
                    int short = int.tryParse(shortController.text) ?? 5;
                    int rounds = int.tryParse(roundsController.text) ?? 4;
                    _saveSettings(study, short, rounds);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    elevation: 0,
                  ),
                  child: const Text("ابدأ الجلسة الآن", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingField(String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 20),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  void _showFinishedDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("تنبيه", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text(message, textAlign: TextAlign.center),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("حسناً"),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _timer?.cancel();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    double progress = 1 - (_remainingSeconds / _modeDurations[_currentMode]!);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _isRunning
          ? null
          : AppBar(
              title: const Text("مؤقت بومودورو", style: TextStyle(fontWeight: FontWeight.bold)),
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              centerTitle: false,
              actions: [
                IconButton(
                  onPressed: _showSetupDialog,
                  icon: const Icon(Icons.settings_rounded),
                ),
              ],
            ),
      body: Stack(
        children: [
          if (_isRunning)
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                onPressed: _pauseTimer,
                icon: const Icon(Icons.close_rounded, size: 32, color: Colors.grey),
              ),
            ),
          Column(
            children: [
              const SizedBox(height: 60),
              // عرض الدورات
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "الدورة: $_currentRound / $_totalRounds",
                  style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              const Spacer(),
              // الدائرة والمؤقت
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 280,
                    height: 280,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 12,
                      backgroundColor: primaryColor.withOpacity(0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _currentMode == PomodoroMode.study ? primaryColor : Colors.green,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(_remainingSeconds),
                        style: TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                          fontFamily: 'monospace',
                        ),
                      ),
                      Text(
                        _currentMode == PomodoroMode.study ? "وقت التركيز" : "وقت الراحة",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              // أزرار التحكم
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isRunning ? _pauseTimer : _startTimer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(_isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded),
                            const SizedBox(width: 8),
                            Text(
                              _isRunning ? "إيقاف مؤقت" : "ابدأ الآن",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: IconButton(
                        onPressed: _resetSession,
                        icon: const Icon(Icons.refresh_rounded),
                        color: primaryColor,
                        iconSize: 32,
                        padding: const EdgeInsets.all(15),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }

}
