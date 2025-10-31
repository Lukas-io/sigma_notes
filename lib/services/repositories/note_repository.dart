import 'package:sqflite/sqflite.dart';

import '../../models/note.dart';
import '../database_service.dart';

class NotesRepository {
  final DatabaseService _dbService = DatabaseService.instance;

  // Get all notes for a specific user
  Future<List<NoteModel>> getAllNotes(String userId) async {
    final db = await _dbService.database;
    final result = await db.query(
      'notes',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'updatedAt DESC',
    );
    return result.map((map) => NoteModel.fromMap(map)).toList();
  }

  // Get single note by ID
  Future<NoteModel?> getNoteById(int id) async {
    final db = await _dbService.database;
    final result = await db.query(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return NoteModel.fromMap(result.first);
  }

  // Create a note
  Future<int> createNote(NoteModel note) async {
    final db = await _dbService.database;
    return await db.insert('notes', note.toMap());
  }

  // Update a note
  Future<int> updateNote(NoteModel note) async {
    final db = await _dbService.database;
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  // Delete a note
  Future<int> deleteNote(int id) async {
    final db = await _dbService.database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  // Get notes count for a user
  Future<int> getNotesCount(String userId) async {
    final db = await _dbService.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM notes WHERE userId = ?',
      [userId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
