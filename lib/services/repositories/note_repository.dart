import 'package:sqflite/sqflite.dart';

import '../../models/check_list_item.dart';
import '../../models/note.dart';
import '../../models/voice_note.dart';
import '../database_service.dart';
import 'dart:convert';

class NotesRepository {
  final DatabaseService _dbService = DatabaseService.instance;

  // Helper: Convert NoteModel to SQLite Map
  Map<String, dynamic> _noteToSQLiteMap(NoteModel note) {
    return {
      'id': note.id,
      'title': note.title,
      'content': note.content,
      'imagePath': note.imagePath,
      'label': note.label,
      'locked': note.locked ? 1 : 0,
      'collaborators': note.collaborators ? 1 : 0,
      'isPinned': note.isPinned ? 1 : 0,
      'checkList': jsonEncode(note.checkList.map((e) => e.toMap()).toList()),
      'voiceNotes': jsonEncode(note.voiceNotes.map((e) => e.toMap()).toList()),
      'createdAt': note.createdAt.toIso8601String(),
      'updatedAt': note.updatedAt.toIso8601String(),
      'userId': note.userId,
    };
  }

  // Helper: Convert SQLite Map to NoteModel
  NoteModel _sqliteMapToNote(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      imagePath: map['imagePath'],
      label: map['label'],
      locked: map['locked'] == 1,
      collaborators: map['collaborators'] == 1,
      isPinned: map['isPinned'] == 1,
      checkList: (jsonDecode(map['checkList']) as List)
          .map((e) => CheckListItemModel.fromMap(e))
          .toList(),
      voiceNotes: (jsonDecode(map['voiceNotes']) as List)
          .map((e) => VoiceNoteModel.fromMap(e))
          .toList(),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      userId: map['userId'],
    );
  }

  Future<List<NoteModel>> getAllNotes(String userId) async {
    final db = await _dbService.database;
    final result = await db.query(
      'notes',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'isPinned DESC, updatedAt DESC', // Pinned first, then by date
    );
    return result.map((map) => _sqliteMapToNote(map)).toList();
  }

  Future<NoteModel?> getNoteById(int id) async {
    final db = await _dbService.database;
    final result = await db.query(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return _sqliteMapToNote(result.first);
  }

  Future<int> createNote(NoteModel note) async {
    final db = await _dbService.database;
    return await db.insert('notes', _noteToSQLiteMap(note));
  }

  Future<int> updateNote(NoteModel note) async {
    final db = await _dbService.database;
    return await db.update(
      'notes',
      _noteToSQLiteMap(note),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await _dbService.database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> getNotesCount(String userId) async {
    final db = await _dbService.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM notes WHERE userId = ?',
      [userId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
