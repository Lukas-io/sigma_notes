import 'package:intl/intl.dart';
import 'package:sigma_notes/core/assets.dart';
import 'package:sigma_notes/models/voice_note.dart';

import 'check_list_item.dart';

class NoteModel {
  final int id;
  final String title;
  final String content;
  final String? imagePath;
  final String? label;
  final bool locked;
  final bool collaborators;
  final bool isPinned;
  final List<CheckListItemModel> checkList;
  final List<VoiceNoteModel> voiceNotes; // new
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userId;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    this.imagePath,
    this.label,
    this.locked = false,
    this.collaborators = false,
    this.isPinned = false,
    this.checkList = const [],
    this.voiceNotes = const [], // default empty
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

  String get formattedDate {
    return DateFormat('MMMM d, y').format(createdAt);
  }

  String get formattedDateTime {
    return DateFormat('EEE, MMMM d, y HH:mm').format(createdAt);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'imagePath': imagePath,
      'label': label,
      'locked': locked,
      'collaborators': collaborators,
      'isPinned': isPinned,
      'checkList': checkList.map((e) => e.toMap()).toList(),
      'voiceNotes': voiceNotes.map((e) => e.toMap()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'userId': userId,
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      imagePath: map['imagePath'],
      label: map['label'],
      locked: map['locked'] ?? false,
      collaborators: map['collaborators'] ?? false,
      isPinned: map['isPinned'] ?? false,
      checkList: List<CheckListItemModel>.from(
        (map['checkList'] as List).map((e) => CheckListItemModel.fromMap(e)),
      ),
      voiceNotes: map['voiceNotes'] != null
          ? List<VoiceNoteModel>.from(
              (map['voiceNotes'] as List).map((e) => VoiceNoteModel.fromMap(e)),
            )
          : [],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      userId: map['userId'],
    );
  }
}

final sampleNotes = [
  NoteModel(
    id: 1,
    title: "Morning Reflections",
    content: """
Today I learned about the power of consistency — small steps taken daily can build massive momentum over time.
I want to apply this in journaling and studying the Word, even if it’s just 10 minutes each morning.
""",
    label: "Reflection",
    locked: false,
    collaborators: false,
    isPinned: true,

    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    updatedAt: DateTime.now(),
    userId: "user_123",
  ),
  NoteModel(
    id: 2,
    title: "Grocery List",
    content: "Weekly groceries to buy and check discounts.",
    label: "Shopping",
    locked: false,
    collaborators: true,
    isPinned: false,
    checkList: [
      CheckListItemModel(title: "Bananas", isChecked: true),
      CheckListItemModel(title: "Spinach", isChecked: false),
      CheckListItemModel(title: "Almond milk", isChecked: false),
      CheckListItemModel(title: "Coffee", isChecked: true),
    ],
    voiceNotes: [
      VoiceNoteModel(
        id: "vn2",
        duration: const Duration(minutes: 1, seconds: 12),
        filePath: "assets/audio/grocery_reminder.mp3",
        title: "Shopping voice note",
      ),
    ],
    createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
    updatedAt: DateTime.now(),
    userId: "user_123",
  ),
  NoteModel(
    id: 3,
    title: "Project Ideas Brainstorm",
    content: """
1. Build a personal finance tracker app
2. Create a habit tracker with gamification
3. Explore AR-based interior design app
4. Start a blog on productivity tips
""",
    label: "Ideas",
    locked: true,
    collaborators: false,
    isPinned: false,
    checkList: [
      CheckListItemModel(title: "Validate ideas", isChecked: true),
      CheckListItemModel(title: "Prioritize 2–3 projects", isChecked: false),
    ],

    createdAt: DateTime.now().subtract(const Duration(hours: 12)),
    updatedAt: DateTime.now(),
    userId: "user_123",
  ),
  NoteModel(
    id: 4,
    title: "Workout Plan",
    content: "Weekly workout schedule for full-body fitness.",
    locked: false,

    createdAt: DateTime.now().subtract(const Duration(days: 3)),
    updatedAt: DateTime.now(),
    userId: "user_123",
  ),
  NoteModel(
    id: 5,
    title: "Birthday Gift Ideas",
    content: "Gift ideas under \$100 for friends and family.",
    label: "Personal",
    locked: false,
    imagePath: SigmaAssets.avatar3,

    collaborators: false,
    isPinned: false,
    checkList: [
      CheckListItemModel(title: "Wireless earbuds", isChecked: false),
      CheckListItemModel(title: "Leather journal", isChecked: true),
      CheckListItemModel(title: "Indoor plants", isChecked: false),
      CheckListItemModel(title: "Books by favorite author", isChecked: true),
      CheckListItemModel(title: "Personalized mug", isChecked: false),
    ],
    voiceNotes: [
      VoiceNoteModel(
        id: "vn5",
        duration: const Duration(minutes: 0, seconds: 45),
        filePath: "assets/audio/gift_ideas.mp3",
        title: "Gift brainstorming",
      ),
    ],
    createdAt: DateTime.now().subtract(const Duration(days: 5, hours: 4)),
    updatedAt: DateTime.now(),
    userId: "user_123",
  ),
];
