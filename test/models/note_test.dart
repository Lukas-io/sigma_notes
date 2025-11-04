import 'package:flutter_test/flutter_test.dart';
import 'package:sigma_notes/models/collaborator.dart';
import 'package:sigma_notes/models/content/text.dart';
import 'package:sigma_notes/models/content/checklist.dart';
import 'package:sigma_notes/models/content/audio.dart';
import 'package:sigma_notes/models/content/image.dart';
import 'package:sigma_notes/models/note.dart';

void main() {
  group('NoteModel', () {
    final testNote = NoteModel(
      id: 'note_123',
      title: 'Test Note',
      label: 'test',
      locked: false,
      isPinned: true,
      isTemp: false,
      contents: [
        TextContent(order: 0, text: 'This is a test note'),
        TextContent(order: 1, text: 'With multiple content blocks'),
      ],
      collaborators: [
        Collaborator(
          userId: 'user_456',
          email: 'collaborator@example.com',
          name: 'Test Collaborator',
          role: CollaboratorRole.editor,
        ),
      ],
      userId: 'user_123',
    );

    group('Constructor', () {
      test('creates note with provided values', () {
        expect(testNote.id, equals('note_123'));
        expect(testNote.title, equals('Test Note'));
        expect(testNote.label, equals('test'));
        expect(testNote.locked, isFalse);
        expect(testNote.isPinned, isTrue);
        expect(testNote.isTemp, isFalse);
        expect(testNote.contents, isNotEmpty);
        expect(testNote.collaborators, isNotEmpty);
        expect(testNote.userId, equals('user_123'));
        expect(testNote.createdAt, isA<DateTime>());
        expect(testNote.updatedAt, isA<DateTime>());
      });

      test('generates ID and timestamps when not provided', () {
        final note = NoteModel(
          title: 'Auto-generated Note',
          userId: 'user_123',
        );

        expect(note.id, isNotNull);
        expect(note.id, isNotEmpty);
        expect(note.createdAt, isA<DateTime>());
        expect(note.updatedAt, isA<DateTime>());
      });

      test('defaults to empty text content when no contents provided', () {
        final note = NoteModel(
          title: 'Default Content Note',
          userId: 'user_123',
        );

        expect(note.contents, isNotEmpty);
        expect(note.contents.first, isA<TextContent>());
      });
    });

    group('Formatted Dates', () {
      test('returns formatted dates', () {
        expect(testNote.formattedDate, isA<String>());
        expect(testNote.formattedDateDayTime, isA<String>());
        expect(testNote.formattedDateForPreview, isA<String>());
        expect(testNote.formattedDateTime, isA<String>());
      });
    });

    group('Searchable Text', () {
      test('returns combined searchable text', () {
        final searchableText = testNote.searchableText;
        expect(searchableText, contains(testNote.title));
        expect(searchableText, contains(testNote.label));
        expect(searchableText, contains('This is a test note'));
        expect(searchableText, contains('With multiple content blocks'));
      });
    });

    group('Checklist Properties', () {
      test('correctly identifies if note has checklist', () {
        // Our test note doesn't have a checklist, so this should be false
        expect(testNote.hasChecklist, isFalse);
      });

      test('returns empty list when no checklists', () {
        expect(testNote.checklists, isEmpty);
      });

      test('returns checklists when present', () {
        final noteWithChecklist = NoteModel(
          id: 'note_checklist',
          title: 'Note with Checklist',
          userId: 'user_123',
          contents: [
            ChecklistContent(
              order: 0,
              items: [
                ChecklistItem(text: 'Item 1', checked: true),
                ChecklistItem(text: 'Item 2', checked: false),
              ],
            ),
          ],
        );

        expect(noteWithChecklist.checklists, isNotEmpty);
        expect(noteWithChecklist.checklists.length, equals(1));
        expect(noteWithChecklist.checklists.first.items.length, equals(2));
      });
    });

    group('Voice Notes', () {
      test('returns empty list when no voice notes', () {
        expect(testNote.voiceNotes, isEmpty);
      });

      test('returns voice notes when present', () {
        final noteWithAudio = NoteModel(
          id: 'note_audio',
          title: 'Note with Audio',
          userId: 'user_123',
          contents: [
            AudioContent(
              order: 0,
              url: 'test_audio.mp3',
              duration: Duration(seconds: 30),
            ),
          ],
        );

        expect(noteWithAudio.voiceNotes, isNotEmpty);
        expect(noteWithAudio.voiceNotes.length, equals(1));
        expect(noteWithAudio.voiceNotes.first.url, equals('test_audio.mp3'));
      });
    });

    group('Images', () {
      test('returns empty list when no images', () {
        expect(testNote.images, isEmpty);
      });

      test('returns images when present', () {
        final noteWithImage = NoteModel(
          id: 'note_image',
          title: 'Note with Image',
          userId: 'user_123',
          contents: [ImageContent(order: 0, url: 'test_image.jpg')],
        );

        expect(noteWithImage.images, isNotEmpty);
        expect(noteWithImage.images.length, equals(1));
        expect(noteWithImage.images.first.url, equals('test_image.jpg'));
      });
    });

    group('Completion Percentage', () {
      test('returns 0 when no checklists', () {
        expect(testNote.completionPercentage, equals(0.0));
      });

      test('calculates completion percentage when checklists present', () {
        final noteWithChecklist = NoteModel(
          id: 'note_checklist_complete',
          title: 'Note with Completed Checklist',
          userId: 'user_123',
          contents: [
            ChecklistContent(
              order: 0,
              items: [
                ChecklistItem(text: 'Item 1', checked: true),
                ChecklistItem(text: 'Item 2', checked: true),
                ChecklistItem(text: 'Item 3', checked: false),
              ],
            ),
          ],
        );

        // 2 out of 3 items checked = 66.67%
        expect(noteWithChecklist.completionPercentage, closeTo(0.667, 0.01));
      });
    });

    group('toMap', () {
      test('converts note to map correctly', () {
        final map = testNote.toMap();

        expect(map['id'], equals(testNote.id));
        expect(map['title'], equals(testNote.title));
        expect(map['label'], equals(testNote.label));
        expect(map['locked'], equals(testNote.locked ? 1 : 0));
        expect(map['isPinned'], equals(testNote.isPinned ? 1 : 0));
        expect(map['isTemp'], equals(testNote.isTemp ? 1 : 0));
        expect(map['userId'], equals(testNote.userId));
        expect(map['contents'], isA<String>());
        expect(map['collaborators'], isA<String>());
        expect(map['createdAt'], equals(testNote.createdAt.toIso8601String()));
        expect(map['updatedAt'], equals(testNote.updatedAt.toIso8601String()));
      });
    });

    group('fromMap', () {
      test('creates note from map correctly', () {
        final map = {
          'id': 'note_456',
          'title': 'Mapped Note',
          'label': 'mapped',
          'thumbnail': null,
          'locked': 1,
          'isPinned': 0,
          'isTemp': 1,
          'contents': '[{"type":"text","order":0,"text":"Mapped content"}]',
          'collaborators': '[]',
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
          'userId': 'user_456',
        };

        final note = NoteModel.fromMap(map);

        expect(note.id, equals(map['id']));
        expect(note.title, equals(map['title']));
        expect(note.label, equals(map['label']));
        expect(note.locked, isTrue);
        expect(note.isPinned, isFalse);
        expect(note.isTemp, isTrue);
        expect(note.contents, isNotEmpty);
        expect(note.userId, equals(map['userId']));
        expect(note.createdAt, isA<DateTime>());
        expect(note.updatedAt, isA<DateTime>());
      });
    });

    group('copyWith', () {
      test('creates new note with updated fields', () {
        final updatedNote = testNote.copyWith(
          title: 'Updated Note',
          locked: true,
          updatedAt: DateTime.now(),
        );

        expect(updatedNote.id, equals(testNote.id));
        expect(updatedNote.title, equals('Updated Note'));
        expect(updatedNote.locked, isTrue);
        expect(updatedNote.isPinned, equals(testNote.isPinned));
        expect(updatedNote.userId, equals(testNote.userId));
        // Check that the update time was changed
        expect(updatedNote.updatedAt, isNot(equals(testNote.updatedAt)));
      });
    });
  });
}
