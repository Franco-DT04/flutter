// lib/screens/staff/staff_stats_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/user.dart';
import '../../models/mood_entry.dart';
import '../../services/database_helper.dart';
import '../../utils/constants.dart';

class StaffStatsScreen extends StatefulWidget {
  const StaffStatsScreen({super.key});

  @override
  State<StaffStatsScreen> createState() => _StaffStatsScreenState();
}

class _StaffStatsScreenState extends State<StaffStatsScreen> {
  late User student;
  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  List<MoodEntry> _moodEntries = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    student = ModalRoute.of(context)!.settings.arguments as User;
    _loadMoodEntries();
  }

  Future<void> _loadMoodEntries() async {
    final db = DatabaseHelper();
    final start = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
    final end = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0);
    final entries = await db.getMoodEntriesForUserAndMonth(student.id!, start, end);
    setState(() {
      _moodEntries = entries;
    });
  }

  void _pickMonth() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedMonth,
      firstDate: DateTime(now.year - 2, 1),
      lastDate: DateTime(now.year, now.month),
      helpText: 'Select Month',
      fieldLabelText: 'Month/Year',
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      selectableDayPredicate: (date) => date.day == 1,
    );
    if (picked != null) {
      setState(() {
        _selectedMonth = DateTime(picked.year, picked.month);
      });
      await _loadMoodEntries();
    }
  }

  @override
  Widget build(BuildContext context) {
    final monthLabel = DateFormat('MMMM yyyy').format(_selectedMonth);

    return Scaffold(
      appBar: AppBar(
        title: Text('Stats: ${student.name}'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Student info
            Text(
              '${student.name} (${student.className ?? "Staff"})',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              student.email,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            // Month selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  monthLabel,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('Choose Month'),
                  onPressed: _pickMonth,
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Histogram
            Expanded(
              flex: 2,
              child: _moodEntries.isEmpty
                  ? const Center(child: Text('No mood data for this month.'))
                  : _buildHistogram(),
            ),
            const SizedBox(height: 24),
            // Pie chart
            Expanded(
              flex: 2,
              child: _moodEntries.isEmpty
                  ? const SizedBox()
                  : _buildPieChart(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistogram() {
    final daysInMonth = DateUtils.getDaysInMonth(_selectedMonth.year, _selectedMonth.month);
    final moodMap = <int, int>{};
    for (final entry in _moodEntries) {
      moodMap[entry.date.day] = entry.moodLevel;
    }

    final barSpots = <BarChartGroupData>[];
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_selectedMonth.year, _selectedMonth.month, day);
      if (date.weekday >= 1 && date.weekday <= 5) {
        final mood = moodMap[day]?.toDouble() ?? 0.0;
        barSpots.add(
          BarChartGroupData(
            x: day,
            barRods: [
              BarChartRodData(
                toY: mood,
                color: mood > 0 ? Colors.blue : Colors.grey[300],
                width: 16,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        );
      }
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 5,
        minY: 0,
        barGroups: barSpots,
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (value, meta) {
                if (value < 1 || value > 5) return const SizedBox();
                return Text('${value.toInt()}');
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final day = value.toInt();
                if (day < 1 || day > 31) return const SizedBox();
                return Text('$day', style: const TextStyle(fontSize: 10));
              },
            ),
          ),
        ),
        gridData: FlGridData(show: true),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  Widget _buildPieChart() {
    final moodCounts = List<int>.filled(5, 0);
    for (final entry in _moodEntries) {
      if (entry.moodLevel >= 1 && entry.moodLevel <= 5) {
        moodCounts[entry.moodLevel - 1]++;
      }
    }
    final total = moodCounts.reduce((a, b) => a + b);
    if (total == 0) return const Center(child: Text('No mood data for this month.'));

    final colors = [
      Colors.red,
      Colors.orange,
      Colors.grey,
      Colors.lightGreen,
      Colors.green,
    ];

    return PieChart(
      PieChartData(
        sections: List.generate(5, (i) {
          final value = moodCounts[i].toDouble();
          return PieChartSectionData(
            color: colors[i],
            value: value,
            title: value > 0 ? '${((value / total) * 100).toStringAsFixed(0)}%' : '',
            radius: 50,
            titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          );
        }),
        sectionsSpace: 2,
        centerSpaceRadius: 32,
      ),
    );
  }
}