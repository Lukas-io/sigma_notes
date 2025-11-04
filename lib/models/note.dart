import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:sigma_notes/core/assets.dart';
import 'package:sigma_notes/core/utils/note_utils.dart';
import 'package:sigma_notes/core/utils/username_generator.dart';
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteModel && id == other.id && updatedAt == other.updatedAt;

  @override
  int get hashCode => Object.hash(id, updatedAt);

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
    return '$title $label $contentText';
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
  // PINNED - Important swim meet
  NoteModel(
    title: "STATE CHAMPIONSHIP SCHEDULE",
    label: "Swimming",
    isPinned: true,
    contents: [
      TextContent(order: 0, text: "DO NOT MISS THIS", style: TextStyleType.h2),
      TextContent(
        order: 1,
        text:
            "Bus leaves Friday 4am sharp. Coach said if you're late you're CUT. Prelims Friday 9am, Finals Saturday 2pm. 200 Free, 100 Fly, 4x100 relay.",
        style: TextStyleType.paragraph,
      ),
      ChecklistContent(
        order: 2,
        items: [
          ChecklistItem(text: "Pack suit, goggles, towels", checked: true),
          ChecklistItem(text: "Carb load Thursday night", checked: false),
          ChecklistItem(text: "Get 8+ hours sleep", checked: false),
          ChecklistItem(text: "Shave down Wednesday", checked: false),
          ChecklistItem(text: "Tell Mia I'll be gone weekend", checked: false),
        ],
      ),
      TextContent(
        order: 3,
        text:
            "Dad said he'd try to come but \"we'll see\" aka probably not. Whatever. Time to prove I can do this without his approval.",
        style: TextStyleType.paragraph,
      ),
    ],
    createdAt: DateTime.now().subtract(const Duration(hours: 18)),
    userId: "user_123",
  ),

  // LOCKED - Private note about girlfriend
  NoteModel(
    title: "things i can't say out loud",
    label: "Personal",
    locked: true,
    contents: [
      TextContent(order: 0, text: "Mia", style: TextStyleType.h2),
      TextContent(
        order: 1,
        text:
            "We fought again tonight. She says I care more about the guys than her. Maybe she's right? Idk man. I just... when she looks at me like I'm not enough, it kills me. Same way dad used to look at me.\n\nBut then she laughs at my stupid jokes and I remember why I'm crazy about her. She's the only one who sees through the party guy act. She knows I'm terrified of failing. Of disappointing everyone.\n\nI prayed about us last night. Asked God if we're supposed to work through this or if I'm just holding on because I'm scared to be alone. No answer yet. Just silence and this knot in my chest.\n\nI need to be better for her. For me. For God. But I don't even know where to start.",
        style: TextStyleType.paragraph,
      ),
      TextContent(
        order: 2,
        text:
            "\"He heals the brokenhearted and binds up their wounds\" - Psalm 147:3",
        style: TextStyleType.paragraph,
      ),
    ],
    createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
    userId: "user_123",
  ),

  // Class notes - messy CS notes
  NoteModel(
    title: "Data Structures Exam Cram",
    label: "School",
    thumbnail: "assets/images/code_thumbnail.jpg",
    contents: [
      TextContent(
        order: 0,
        text: "Midterm Monday 8am WHY SO EARLY",
        style: TextStyleType.h2,
      ),
      TextContent(
        order: 1,
        text: "Big O Notation:",
        style: TextStyleType.bullet,
      ),
      TextContent(
        order: 2,
        text: "O(1) - constant time, like array access",
        style: TextStyleType.bullet,
      ),
      TextContent(
        order: 3,
        text: "O(n) - linear, loops through everything",
        style: TextStyleType.bullet,
      ),
      TextContent(
        order: 4,
        text: "O(log n) - binary search, divide and conquer vibes",
        style: TextStyleType.bullet,
      ),
      TextContent(
        order: 5,
        text: "O(n²) - nested loops, BAD but sometimes necessary",
        style: TextStyleType.bullet,
      ),
      TextContent(
        order: 6,
        text:
            "Prof Wu said this is 40% of exam. Also need to know linked lists, stacks, queues, trees. Might actually have to study for this one lol. Coffee study session with Marcus at library Sunday night??",
        style: TextStyleType.paragraph,
      ),
      ChecklistContent(
        order: 7,
        items: [
          ChecklistItem(text: "Review lecture slides 6-12", checked: false),
          ChecklistItem(
            text: "Practice problems from textbook",
            checked: false,
          ),
          ChecklistItem(
            text: "Watch those YouTube videos Marcus sent",
            checked: true,
          ),
          ChecklistItem(
            text: "Actually go to review session Friday",
            checked: false,
          ),
        ],
      ),
    ],
    createdAt: DateTime.now().subtract(const Duration(days: 3, hours: 7)),
    userId: "user_123",
    collaborators: [
      Collaborator(
        userId: "user_789",
        email: "trevor@university.edu",
        name: "Trevor",
        profileImageUrl: SigmaAssets.avatar2,
        role: CollaboratorRole.editor,
      ),
      Collaborator(
        userId: "user_789",
        email: "trevor@university.edu",
        name: "Trevor",
        profileImageUrl: SigmaAssets.avatar1,
        role: CollaboratorRole.editor,
      ),
    ],
  ),

  // Party planning
  NoteModel(
    title: "OMEGA PSI RAGER THIS SATURDAY",
    label: "Social",
    contents: [
      TextContent(
        order: 0,
        text: "Theme: Beach Party (in November because we're idiots)",
        style: TextStyleType.h2,
      ),
      TextContent(
        order: 1,
        text:
            "Trevor's handling the kegs, I'm on music. Someone needs to make sure Jake doesn't invite his weird cousin again.",
        style: TextStyleType.paragraph,
      ),
      ChecklistContent(
        order: 2,
        items: [
          ChecklistItem(text: "Update Spotify party playlist", checked: true),
          ChecklistItem(
            text: "Get extra speakers from AV club",
            checked: false,
          ),
          ChecklistItem(
            text: "Bring acoustic guitar for late night",
            checked: false,
          ),
          ChecklistItem(text: "Hide anything valuable in room", checked: false),
          ChecklistItem(
            text: "Text Mia about coming (wish me luck)",
            checked: false,
          ),
          ChecklistItem(text: "Buy solo cups, ping pong balls", checked: true),
          ChecklistItem(
            text: "Make sure someone stays sober for cleanup",
            checked: false,
          ),
        ],
      ),
      AudioContent(
        order: 3,
        url: "assets/audio/party_playlist_sample.mp3",
        duration: const Duration(minutes: 2, seconds: 34),
      ),
      TextContent(
        order: 4,
        text:
            "Note to self: pace yourself this time. Last party was... rough. God doesn't need to see me hugging a toilet at 2am again.",
        style: TextStyleType.paragraph,
      ),
    ],
    collaborators: [
      Collaborator(
        userId: "user_789",
        email: "trevor@university.edu",
        name: "Trevor",
        profileImageUrl: SigmaAssets.avatar1,
        role: CollaboratorRole.editor,
      ),
      Collaborator(
        userId: "user_789",
        email: "trevor@university.edu",
        name: "Trevor",
        profileImageUrl: SigmaAssets.avatar3,
        role: CollaboratorRole.editor,
      ),
      Collaborator(
        userId: "user_789",
        email: "trevor@university.edu",
        name: "Trevor",
        profileImageUrl: SigmaAssets.avatar2,
        role: CollaboratorRole.editor,
      ),
    ],
    createdAt: DateTime.now().subtract(const Duration(hours: 36)),
    userId: "user_123",
  ),

  // Swim training log
  NoteModel(
    title: "Training Log - Week 12",
    label: "Swimming",
    thumbnail: "assets/images/pool_thumbnail.jpg",
    contents: [
      TextContent(order: 0, text: "Monday AM:", style: TextStyleType.h2),
      TextContent(
        order: 1,
        text:
            "6x400 free on 5:30, felt strong. 200 fly felt like death but hit 2:08 which is PR territory. Coach pulled me aside after - said scouts from Stanford might be at States. No pressure or anything.\n\nBody feels good. Shoulder a little tight but nothing major.",
        style: TextStyleType.paragraph,
      ),
      TextContent(order: 2, text: "Wednesday PM:", style: TextStyleType.h2),
      TextContent(
        order: 3,
        text:
            "Sprint sets. 20x50 on :45. Legs are DEAD. Skipped weights because honestly can barely walk. Need to ice tonight.",
        style: TextStyleType.paragraph,
      ),
      TextContent(order: 4, text: "Friday AM:", style: TextStyleType.h2),
      TextContent(
        order: 5,
        text:
            "Easy 3000 recovery swim. Worked on turns and underwaters. Marcus beat me in the last 50 and won't shut up about it 🙄",
        style: TextStyleType.paragraph,
      ),
      ChecklistContent(
        order: 6,
        items: [
          ChecklistItem(text: "Foam roll every night", checked: false),
          ChecklistItem(
            text: "Protein within 30 min after practice",
            checked: true,
          ),
          ChecklistItem(text: "Stretch hip flexors", checked: false),
          ChecklistItem(text: "Schedule sports massage", checked: false),
        ],
      ),
    ],
    createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 14)),
    userId: "user_123",
  ),

  // Bible study reflection
  NoteModel(
    title: "thursday night bible study thoughts",
    label: "Faith",
    contents: [
      TextContent(order: 0, text: "Romans 8:28", style: TextStyleType.h2),
      TextContent(
        order: 1,
        text:
            "\"And we know that in all things God works for the good of those who love him, who have been called according to his purpose.\"",
        style: TextStyleType.paragraph,
      ),
      TextContent(
        order: 2,
        text:
            "Pastor Mike asked us to think about where we've seen this in our lives. Honestly had me messed up for a minute.\n\nLike... dad leaving pushed me harder in swimming. Meeting Mia happened because I failed that first CS exam and had to go to tutoring. Even the parties and mistakes - they're teaching me who I don't want to be.\n\nBut it's hard to believe God's working when everything feels chaotic. When me and Mia fight. When I disappoint Coach. When I party too hard and wake up feeling empty.\n\nMaybe that's the point though? The chaos is where the growth happens. The tension between who I am and who God wants me to be.\n\nI led worship tonight. Guitar felt good in my hands. Felt closer to God in those 15 minutes than I have all week. Need more of that. Less of the noise.",
        style: TextStyleType.paragraph,
      ),
      TextContent(
        order: 3,
        text:
            "Prayer: Help me trust the process. Even when it hurts. Especially when it hurts.",
        style: TextStyleType.paragraph,
      ),
    ],
    createdAt: DateTime.now().subtract(const Duration(days: 4, hours: 9)),
    userId: "user_123",
  ),

  // Song lyrics in progress
  NoteModel(
    title: "Song idea - untitled",
    label: "Music",
    contents: [
      TextContent(order: 0, text: "Verse 1:", style: TextStyleType.h2),
      TextContent(
        order: 1,
        text:
            "3am and I'm still awake\nThinking bout the choices that I make\nYou say I'm running from something real\nBut I don't even know what I feel\n\n(Chorus - needs work)\nMaybe I'm just\nMaybe I'm just trying to find\nSomething that looks like peace of mind\nIn the chaos and the noise\nTrying to hear that still small voice",
        style: TextStyleType.paragraph,
      ),
      TextContent(order: 2, text: "Verse 2 (rough):", style: TextStyleType.h2),
      TextContent(
        order: 3,
        text:
            "Swimming laps but going nowhere fast\nTrying to outrun my past\nYou see right through my confident smile\nKnow I've been faking it all the while",
        style: TextStyleType.paragraph,
      ),
      AudioContent(
        order: 4,
        url: "assets/audio/song_demo_acoustic.mp3",
        duration: const Duration(minutes: 1, seconds: 47),
      ),
      TextContent(
        order: 5,
        text:
            "Bridge needs something about redemption? Grace? Idk it's not there yet. Played it for Mia and she cried so maybe I'm onto something.",
        style: TextStyleType.paragraph,
      ),
    ],
    createdAt: DateTime.now().subtract(const Duration(hours: 52)),
    userId: "user_123",
  ),

  // Grocery/practical stuff
  NoteModel(
    title: "Stuff to grab from Target",
    label: "Shopping",
    contents: [
      TextContent(
        order: 0,
        text: "Actual necessities (don't forget this time):",
        style: TextStyleType.paragraph,
      ),
      ChecklistContent(
        order: 1,
        items: [
          ChecklistItem(text: "Protein powder (vanilla)", checked: false),
          ChecklistItem(text: "Instant ramen (the good kind)", checked: true),
          ChecklistItem(text: "Energy drinks", checked: false),
          ChecklistItem(text: "Body wash", checked: false),
          ChecklistItem(
            text: "Phone charger (3rd one this semester)",
            checked: false,
          ),
          ChecklistItem(text: "Snacks for late night studying", checked: true),
          ChecklistItem(text: "Laundry detergent", checked: false),
          ChecklistItem(
            text: "New swim goggles (current ones are scratched)",
            checked: false,
          ),
          ChecklistItem(
            text: "Birthday card for Mia (IMPORTANT)",
            checked: false,
          ),
        ],
      ),
      TextContent(
        order: 2,
        text:
            "Budget: like \$80 max. Already spent too much this month on going out.",
        style: TextStyleType.paragraph,
      ),
    ],
    createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 16)),
    userId: "user_123",
  ),

  // Poem about faith/struggle
  NoteModel(
    title: "A Poem (or whatever this is)",
    label: "Reflection",
    thumbnail: "assets/images/journal_thumbnail.jpg",
    contents: [
      TextContent(
        order: 0,
        text: "wrote this at 2am couldn't sleep",
        style: TextStyleType.h2,
      ),
      TextContent(
        order: 1,
        text:
            "I am the prodigal son at a frat party\nRed cup in hand, worship song in my heart\nThe tension between who I was\nWho I am\nWho I'm becoming\nStretched across Friday night and Sunday morning\n\nI chase approval in chlorinated water\nIn my father's eyes that never quite see me\nIn a girl who loves me despite myself\nIn the cheers of brothers who don't know\nI'm barely holding it together\n\nBut maybe that's the point\nMaybe grace lives in the gap\nBetween my mistakes and His mercy\nBetween the party and the prayer\nBetween drowning and learning to swim\n\nI am both and neither\nSaint and sinner\nLost and found\nAnd somehow that's exactly where He meets me",
        style: TextStyleType.paragraph,
      ),
      TextContent(
        order: 2,
        text:
            "(not sure if this is good or just pretentious late night rambling but it felt true when I wrote it)",
        style: TextStyleType.paragraph,
      ),
    ],
    createdAt: DateTime.now().subtract(const Duration(days: 6, hours: 2)),
    userId: "user_123",
    collaborators: [
      Collaborator(
        userId: "user_789",
        email: "trevor@university.edu",
        name: "Trevor",
        profileImageUrl: SigmaAssets.avatar3,
        role: CollaboratorRole.editor,
      ),
    ],
  ),

  // Random thoughts/stream of consciousness
  NoteModel(
    title: "random thursday thoughts",
    contents: [
      TextContent(
        order: 0,
        text:
            "Is it weird that I feel most like myself when I'm in the water? Like everything else is just noise but when I dive in it all goes quiet. Just me and the lane line and the rhythm of breathing every third stroke.\n\nMia texted during econ. She wants to talk. That's never good. \"We need to talk\" is the four words of death.\n\nSaw dad's name pop up on my phone this morning. Didn't answer. Probably just calling to criticize my technique or ask why I'm not swimming faster times. Never calls just to say hi. Never calls to say he's proud.\n\nWhatever. Don't need his validation. (Writing that doesn't make it feel true but maybe if I say it enough times it will be.)\n\nTrevor asked me to lead the prayer before practice tomorrow. Said the team needs to hear from me. Funny how they think I have it together. If they knew how much I'm struggling they'd probably pick someone else.\n\nBut maybe that's who should lead? The broken ones. The ones still figuring it out. The ones who need grace as much as anyone.\n\nJesus picked twelve random dudes and one literally betrayed him so like... I'm probably fine.\n\nOkay this is getting too deep. Need to finish that CS assignment and hit the gym.",
        style: TextStyleType.paragraph,
      ),
    ],
    createdAt: DateTime.now().subtract(const Duration(hours: 28)),
    userId: "user_123",
  ),
];
