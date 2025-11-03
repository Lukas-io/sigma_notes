import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:sigma_notes/core/utils/note_utils.dart';
import 'package:uuid/uuid.dart';

import 'collaborator.dart';
import 'content/content_model.dart';

/// Represents a complete note with multiple content blocks
class NoteModel {
  final String id;
  final String title;
  final String? thumbnail;
  final String? label;
  final bool locked;
  final bool isTemp;
  final bool isPinned;
  final List<ContentModel> contents;
  final List<Collaborator> collaborators;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userId;

  NoteModel({
    String? id,
    required this.title,
    this.thumbnail,
    this.label,
    this.locked = false,
    this.isPinned = false,
    this.isTemp = false,
    List<ContentModel>? contents,
    this.collaborators = const [],
    DateTime? createdAt,
    DateTime? updatedAt,
    required this.userId,
  }) : id = id ?? const Uuid().v4(),
       contents = contents ?? [TextContent(order: 0, text: "")],
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  // Formatted date helpers
  String get formattedDate => DateFormat('MMMM d, y').format(updatedAt);

  String get formattedDateDayTime =>
      DateFormat('EEE, MMMM d, y HH:mm').format(updatedAt);

  String get formattedDateForPreview =>
      NoteUtils.formatSmartDateTime(updatedAt);

  String get formattedDateTime =>
      DateFormat('MMMM d, y HH:mm').format(updatedAt);

  // Helper to get all text content for search
  String get searchableText {
    final contentText = contents.map((c) => c.getSearchableText()).join(' ');
    return '$title $contentText';
  }

  // Check if note has any checklist
  bool get hasChecklist {
    return contents.any((c) => c.type == ContentType.checklist);
  }

  // Get all checklists
  List<ChecklistContent> get checklists {
    return contents.whereType<ChecklistContent>().toList();
  }

  // Get all audio/voice notes
  List<AudioContent> get voiceNotes {
    return contents.whereType<AudioContent>().toList();
  }

  // Get all images
  List<ImageContent> get images {
    return contents.whereType<ImageContent>().toList();
  }

  // Calculate overall completion if has checklists
  double get completionPercentage {
    final allChecklists = checklists;
    if (allChecklists.isEmpty) return 0;

    final totalItems = allChecklists.fold<int>(
      0,
      (sum, checklist) => sum + checklist.items.length,
    );

    if (totalItems == 0) return 0;

    final checkedItems = allChecklists.fold<int>(
      0,
      (sum, checklist) => sum + checklist.items.where((i) => i.checked).length,
    );

    return checkedItems / totalItems;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'thumbnail': thumbnail,
      'label': label,
      'locked': locked ? 1 : 0,
      'isPinned': isPinned ? 1 : 0,
      'isTemp': isTemp ? 1 : 0,
      'contents': jsonEncode(contents.map((c) => c.toJson()).toList()),
      'collaborators': jsonEncode(collaborators.map((c) => c.toMap()).toList()),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'userId': userId,
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'],
      title: map['title'],
      thumbnail: map['thumbnail'],
      label: map['label'],
      locked: map['locked'] == 1,
      isPinned: map['isPinned'] == 1,
      isTemp: map['isTemp'] == 1,
      contents: (jsonDecode(map['contents']) as List)
          .map((c) => ContentModel.fromJson(c))
          .toList(),
      collaborators: (jsonDecode(map['collaborators']) as List)
          .map((c) => Collaborator.fromMap(c))
          .toList(),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      userId: map['userId'],
    );
  }

  NoteModel copyWith({
    String? title,
    String? thumbnail,
    String? label,
    bool? locked,
    bool? isTemp,
    bool? isPinned,
    List<ContentModel>? contents,
    List<Collaborator>? collaborators,
    DateTime? updatedAt,
  }) {
    return NoteModel(
      id: id,
      title: title ?? this.title,
      thumbnail: thumbnail ?? this.thumbnail,
      label: label ?? this.label,
      locked: locked ?? this.locked,
      isPinned: isPinned ?? this.isPinned,
      isTemp: isTemp ?? this.isTemp,
      contents: contents ?? this.contents,
      collaborators: collaborators ?? this.collaborators,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      userId: userId,
    );
  }
}

// ============================================
// SAMPLE NOTES FOR TESTING
// ============================================

final sampleNotes = [
  NoteModel(
    title: "Morning Reflections",
    label: "Reflection",
    isPinned: true,
    contents: [
      TextContent(
        order: 0,
        text: "Today I learned about the power of consistency",
        style: TextStyleType.h2,
      ),
      TextContent(
        order: 1,
        text:
            "Small steps taken daily can build massive momentum over time. I want to apply this in journaling and studying the Word, even if it's just 10 minutes each morning.",
        style: TextStyleType.paragraph,
      ),
    ],
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    userId: "user_123",
  ),

  NoteModel(
    title: "Grocery List",
    label: "Shopping",
    contents: [
      TextContent(
        order: 0,
        text: "Weekly groceries to buy and check discounts.",
        style: TextStyleType.paragraph,
      ),
      ChecklistContent(
        order: 1,
        items: [
          ChecklistItem(text: "Bananas", checked: true),
          ChecklistItem(text: "Spinach", checked: false),
          ChecklistItem(text: "Almond milk", checked: false),
          ChecklistItem(text: "Coffee", checked: true),
        ],
      ),
      AudioContent(
        order: 2,
        url: "assets/audio/grocery_reminder.mp3",
        duration: const Duration(minutes: 1, seconds: 12),
      ),
    ],
    collaborators: [
      Collaborator(
        userId: "user_456",
        email: "partner@example.com",
        name: "Shopping Partner",
        role: CollaboratorRole.editor,
      ),
    ],
    createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
    userId: "user_123",
  ),

  NoteModel(
    title: "Project Ideas Brainstorm",
    label: "Ideas",
    locked: true,
    contents: [
      TextContent(
        order: 0,
        text: "Build a personal finance tracker app",
        style: TextStyleType.bullet,
      ),
      TextContent(
        order: 1,
        text: "Create a habit tracker with gamification",
        style: TextStyleType.bullet,
      ),
      TextContent(
        order: 2,
        text: "Explore AR-based interior design app",
        style: TextStyleType.bullet,
      ),
      TextContent(
        order: 3,
        text: "Start a blog on productivity tips",
        style: TextStyleType.bullet,
      ),
      ChecklistContent(
        order: 4,
        items: [
          ChecklistItem(text: "Validate ideas", checked: true),
          ChecklistItem(text: "Prioritize 2–3 projects", checked: false),
        ],
      ),
    ],
    createdAt: DateTime.now().subtract(const Duration(hours: 12)),
    userId: "user_123",
  ),

  NoteModel(
    title: "Workout Plan",
    contents: [
      TextContent(
        order: 0,
        text: "Weekly workout schedule for full-body fitness.",
        style: TextStyleType.paragraph,
      ),
    ],
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
    userId: "user_123",
  ),

  NoteModel(
    title: "Birthday Gift Ideas",
    label: "Personal",
    thumbnail: "assets/images/avatar3.png",
    contents: [
      TextContent(
        order: 0,
        text: "Gift ideas under \$100 for friends and family.",
        style: TextStyleType.paragraph,
      ),
      ChecklistContent(
        order: 1,
        items: [
          ChecklistItem(text: "Wireless earbuds", checked: false),
          ChecklistItem(text: "Leather journal", checked: true),
          ChecklistItem(text: "Indoor plants", checked: false),
          ChecklistItem(text: "Books by favorite author", checked: true),
          ChecklistItem(text: "Personalized mug", checked: false),
        ],
      ),
      AudioContent(
        order: 2,
        url: "assets/audio/gift_ideas.mp3",
        duration: const Duration(seconds: 45),
      ),
    ],
    createdAt: DateTime.now().subtract(const Duration(days: 5, hours: 4)),
    userId: "user_123",
  ),
];
