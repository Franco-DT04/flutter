// lib/screens/student/home_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/database_helper.dart';
import '../../models/mood_entry.dart';
import '../../services/shared_prefs_helper.dart';
import '../../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? _selectedMood; // 1-5
  bool _hasSubmitted = false;
  String? _studentName;
  int? _userId;

  @override
  void initState() {
    super.initState();
    _loadStudentInfo();
  }

  Future<void> _loadStudentInfo() async {
    final prefs = SharedPrefsHelper();
    final userId = await prefs.getUserId();
    final userName = await prefs.getUserName();
    setState(() {
      _userId = userId;
      _studentName = userName;
    });
    if (userId != null) {
      await _checkMoodForToday(userId);
    }
  }

  Future<void> _checkMoodForToday(int userId) async {
    final db = DatabaseHelper();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final mood = await db.getMoodEntryForDate(userId, today);
    if (mood != null) {
      setState(() {
        _selectedMood = mood.moodLevel;
        _hasSubmitted = true;
      });
    }
  }

  Future<void> _submitMood() async {
    if (_selectedMood == null || _userId == null) return;
    final db = DatabaseHelper();
    final entry = MoodEntry(
      userId: _userId!,
      moodLevel: _selectedMood!,
      date: DateTime.now(),
    );
    await db.insertMoodEntry(entry);
    setState(() {
      _hasSubmitted = true;
    });
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mood submitted!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final moodIcons = [
      Icons.sentiment_very_dissatisfied,
      Icons.sentiment_dissatisfied,
      Icons.sentiment_neutral,
      Icons.sentiment_satisfied,
      Icons.sentiment_very_satisfied,
    ];
    final moodLabels = [
      'Very Low',
      'Low',
      'Neutral',
      'Good',
      'Excellent',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_studentName != null)
              Text(
                'Welcome, $_studentName!',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 32),
            const Text(
              'How are you feeling today?',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) {
                final moodValue = index + 1;
                final isSelected = _selectedMood == moodValue;
                return Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        moodIcons[index],
                        color: isSelected ? Colors.blue : Colors.grey,
                        size: isSelected ? 48 : 36,
                      ),
                      onPressed: _hasSubmitted
                          ? null
                          : () => setState(() => _selectedMood = moodValue),
                    ),
                    Text(
                      moodLabels[index],
                      style: TextStyle(
                        color: isSelected ? Colors.blue : Colors.grey,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                );
              }),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (_hasSubmitted || _selectedMood == null)
                    ? null
                    : _submitMood,
                child: Text(
                  _hasSubmitted ? 'Mood Submitted' : 'Submit',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
            if (_hasSubmitted)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  'You have already submitted your mood for today.',
                  style: TextStyle(color: Colors.green[700]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}