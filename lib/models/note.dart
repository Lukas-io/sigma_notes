import 'package:intl/intl.dart';

class NoteModel {
  final int id;
  final String title;
  final String content;
  final String? imagePath;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userId;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    this.imagePath,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

  String get formattedDate {
    return DateFormat('MMMM d, y').format(createdAt);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'imagePath': imagePath,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'userId': userId, // NEW
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      imagePath: map['imagePath'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      userId: map['userId'], // NEW
    );
  }
}

final sampleNote = NoteModel(
  id: 1,
  title: "Morning Reflections",
  content: """
Today I learned about the power of consistency — small steps taken daily can build massive momentum over time. 
I want to apply this in journaling and studying the Word, even if it’s just 10 minutes each morning.
""",
  imagePath: "assets/images/sample_note_bg.png",
  // optional, can be null
  createdAt: DateTime.now().subtract(const Duration(days: 2)),
  updatedAt: DateTime.now(),
  userId: "user_123",
);
