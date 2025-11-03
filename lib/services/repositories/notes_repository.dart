import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import '../../models/collaborator.dart';
import '../../models/note.dart';
import '../../models/content/content_model.dart';
import '../database_service.dart';

class NotesRepository {
  final DatabaseService _dbService = DatabaseService.instance;

  /// Convert NoteModel to SQLite-compatible map
  Map<String, dynamic> _noteToSQLiteMap(NoteModel note) {
    return {
      'id': note.id,
      'title': note.title,
      'thumbnail': note.thumbnail,
      'label': note.label,
      'isTemp': note.isTemp,
      'locked': note.locked ? 1 : 0,
      'isPinned': note.isPinned ? 1 : 0,
      // Serialize all content blocks
      'contents': jsonEncode(note.contents.map((c) => c.toJson()).toList()),
      // Serialize collaborators
      'collaborators': jsonEncode(
        note.collaborators.map((c) => c.toMap()).toList(),
      ),
      'createdAt': note.createdAt.toIso8601String(),
      'updatedAt': note.updatedAt.toIso8601String(),
      'userId': note.userId,
    };
  }

  /// Convert SQLite map to NoteModel
  NoteModel _sqliteMapToNote(Map<String, dynamic> map) {
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

  /// Get all notes for a user
  Future<List<NoteModel>> getAllNotes(String userId) async {
    final db = await _dbService.database;
    final result = await db.query(
      NOTE_DB_NAME,
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'isPinned DESC, updatedAt DESC',
    );
    return result.map((map) => _sqliteMapToNote(map)).toList();
  }

  /// Get a single note by ID
  Future<NoteModel?> getNoteById(String id) async {
    final db = await _dbService.database;
    final result = await db.query(
      NOTE_DB_NAME,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return _sqliteMapToNote(result.first);
  }

  /// Create a new note
  Future<NoteModel?> createNote(NoteModel note) async {
    final db = await _dbService.database;
    await db.insert(NOTE_DB_NAME, _noteToSQLiteMap(note));
    return await getNoteById(note.id);
  }

  /// Update an existing note
  Future<int> updateNote(NoteModel note) async {
    final db = await _dbService.database;
    return await db.insert(
      NOTE_DB_NAME,
      _noteToSQLiteMap(note),
      conflictAlgorithm:
          ConflictAlgorithm.replace, // will insert or replace existing
    );
  }

  /// Delete a note by ID
  Future<int> deleteNote(String id) async {
    final db = await _dbService.database;
    return await db.delete(NOTE_DB_NAME, where: 'id = ?', whereArgs: [id]);
  }

  /// Count all notes for a user
  Future<int> getNotesCount(String userId) async {
    final db = await _dbService.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $NOTE_DB_NAME WHERE userId = ?',
      [userId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
