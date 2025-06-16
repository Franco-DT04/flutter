// lib/models/mood_entry.dart
class MoodEntry {
  final int? id;
  final int userId;
  final int moodLevel;  // 1-5
  final DateTime date;

  MoodEntry({
    this.id,
    required this.userId,
    required this.moodLevel,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'moodLevel': moodLevel,
      'date': date.toIso8601String(),
    };
  }

  factory MoodEntry.fromMap(Map<String, dynamic> map) {
    return MoodEntry(
      id: map['id'],
      userId: map['userId'],
      moodLevel: map['moodLevel'],
      date: DateTime.parse(map['date']),
    );
  }
}