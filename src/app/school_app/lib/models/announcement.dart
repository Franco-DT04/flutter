// lib/models/announcement.dart
class Announcement {
  final int? id;
  final String title;
  final String content;
  final DateTime date;
  final int staffId;

  Announcement({
    this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.staffId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
      'staffId': staffId,
    };
  }

  factory Announcement.fromMap(Map<String, dynamic> map) {
    return Announcement(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      date: DateTime.parse(map['date']),
      staffId: map['staffId'],
    );
  }
}