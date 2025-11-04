import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sigma_notes/models/collaborator.dart';
import 'package:sigma_notes/models/content/text.dart';
import 'package:sigma_notes/models/note.dart';
import 'package:sigma_notes/services/database_service.dart';
import 'package:sigma_notes/services/repositories/notes_repository.dart';

import '../helpers/test_helpers.dart';

class MockDatabaseService extends Mock implements DatabaseService {
  Database? mockDatabase;

  @override
  Future<Database> get database async => mockDatabase!;
}

void main() {
  group('NotesRepository', () {
    late NotesRepository notesRepository;
    late MockDatabase mockDatabase;

    final testNote = NoteModel(
      id: 'test_id',
      title: 'Test Note',
      contents: [TextContent(order: 0, text: 'Test content')],
      collaborators: [
        Collaborator(
          userId: 'user_1',
          email: 'test@example.com',
          name: 'Test User',
          role: CollaboratorRole.viewer,
        ),
      ],
      userId: 'user_123',
    );

    setUp(() {
      mockDatabase = MockDatabase();
      final mockDatabaseService = MockDatabaseService();
      mockDatabaseService.mockDatabase = mockDatabase;
      notesRepository = NotesRepository(dbService: mockDatabaseService);
    });

    group('getAllNotes', () {
      test('returns list of notes for a user', () async {
        final userId = 'user_123';
        final mockResult = [
          {
            'id': 'note_1',
            'title': 'Note 1',
            'thumbnail': null,
            'label': null,
            'locked': 0,
            'isPinned': 0,
            'isTemp': 0,
            'contents': jsonEncode([]),
            'collaborators': jsonEncode([]),
            'createdAt': DateTime.now().toIso8601String(),
            'updatedAt': DateTime.now().toIso8601String(),
            'userId': userId,
          },
        ];

        when(
          () => mockDatabase.query(
            any(),
            where: any(named: 'where'),
            whereArgs: any(named: 'whereArgs'),
            orderBy: any(named: 'orderBy'),
          ),
        ).thenAnswer((_) async => mockResult);

        final notes = await notesRepository.getAllNotes(userId);

        expect(notes, isA<List<NoteModel>>());
        expect(notes, isNotEmpty);
        // Note: This will include sampleNotes, so we check if at least one matches
        expect(notes.any((note) => note.userId == userId), isTrue);
      });
    });

    group('getNoteById', () {
      test('returns note when found', () async {
        final noteId = 'note_123';
        final mockResult = [
          {
            'id': noteId,
            'title': 'Test Note',
            'thumbnail': null,
            'label': null,
            'locked': 0,
            'isPinned': 0,
            'isTemp': 0,
            'contents': jsonEncode([]),
            'collaborators': jsonEncode([]),
            'createdAt': DateTime.now().toIso8601String(),
            'updatedAt': DateTime.now().toIso8601String(),
            'userId': 'user_123',
          },
        ];

        when(
          () => mockDatabase.query(
            any(),
            where: any(named: 'where'),
            whereArgs: any(named: 'whereArgs'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) async => mockResult);

        final note = await notesRepository.getNoteById(noteId);

        expect(note, isNotNull);
        expect(note!.id, equals(noteId));
      });

      test('returns null when note not found', () async {
        final noteId = 'nonexistent';

        when(
          () => mockDatabase.query(
            any(),
            where: any(named: 'where'),
            whereArgs: any(named: 'whereArgs'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) async => []);

        final note = await notesRepository.getNoteById(noteId);

        expect(note, isNull);
      });
    });

    group('createNote', () {
      test('inserts note and returns created note', () async {
        when(
          () => mockDatabase.insert(any(), any()),
        ).thenAnswer((_) async => 1);

        when(
          () => mockDatabase.query(
            any(),
            where: any(named: 'where'),
            whereArgs: any(named: 'whereArgs'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer(
          (_) async => [
            {
              'id': testNote.id,
              'title': testNote.title,
              'thumbnail': null,
              'label': null,
              'locked': 0,
              'isPinned': 0,
              'isTemp': 0,
              'contents': jsonEncode([]),
              'collaborators': jsonEncode([]),
              'createdAt': DateTime.now().toIso8601String(),
              'updatedAt': DateTime.now().toIso8601String(),
              'userId': testNote.userId,
            },
          ],
        );

        final result = await notesRepository.createNote(testNote);

        expect(result, isNotNull);
        expect(result!.id, equals(testNote.id));
        verify(() => mockDatabase.insert(any(), any())).called(1);
      });
    });

    group('updateNote', () {
      test('updates existing note', () async {
        when(
          () => mockDatabase.insert(
            any(),
            any(),
            conflictAlgorithm: any(named: 'conflictAlgorithm'),
          ),
        ).thenAnswer((_) async => 1);

        final result = await notesRepository.updateNote(testNote);

        expect(result, equals(1));
        verify(
          () => mockDatabase.insert(
            any(),
            any(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          ),
        ).called(1);
      });
    });

    group('deleteNote', () {
      test('deletes note by id', () async {
        final noteId = 'note_123';
        when(
          () => mockDatabase.delete(
            any(),
            where: any(named: 'where'),
            whereArgs: any(named: 'whereArgs'),
          ),
        ).thenAnswer((_) async => 1);

        final result = await notesRepository.deleteNote(noteId);

        expect(result, equals(1));
        verify(
          () =>
              mockDatabase.delete(any(), where: 'id = ?', whereArgs: [noteId]),
        ).called(1);
      });
    });

    group('getNotesCount', () {
      test('returns count of notes for user', () async {
        final userId = 'user_123';
        final mockResult = [
          {'count': 5},
        ];

        when(
          () => mockDatabase.rawQuery(any(), any()),
        ).thenAnswer((_) async => mockResult);

        final count = await notesRepository.getNotesCount(userId);

        expect(count, equals(5));
        verify(
          () => mockDatabase.rawQuery(
            'SELECT COUNT(*) as count FROM $NOTE_DB_NAME WHERE userId = ?',
            [userId],
          ),
        ).called(1);
      });
    });
  });
}
