class NoteModel {
  final int id;
  final String title;
  final String content;
  final String? imagePath;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userId; // NEW - links note to a user

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    this.imagePath,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

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
