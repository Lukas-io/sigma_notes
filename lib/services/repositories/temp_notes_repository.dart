import 'dart:convert';
import 'package:sqflite/sqflite.dart';

import '../../models/note.dart';
import '../../models/content/content_model.dart';
import '../database_service.dart';

/// Repository for managing temporary autosaved note edits.
///
/// This repository stores transient note data in a separate SQLite table (`temp_notes`)
/// so that user edits can be preserved even if they haven’t been manually saved yet.
///
/// **Key Points:**
/// - Does not interfere with the main `notes` table.
/// - Each entry in `temp_notes` corresponds to a note being edited.
/// - Autosave operations overwrite the same temp note based on `noteId`.
/// - Can hold multiple temp notes for different note sessions.
class TempNotesRepository {
  final DatabaseService _dbService = DatabaseService.instance;

  /// Converts a [NoteModel] to a SQLite-compatible map for the `temp_notes` table.
  Map<String, dynamic> _noteToSQLiteMap(NoteModel note) {
    return {
      'id': note.id, // Same ID as the original note
      'title': note.title,
      'thumbnail': note.thumbnail,
      'label': note.label,
      'locked': note.locked ? 1 : 0,
      'isPinned': note.isPinned ? 1 : 0,
      'isTemp': note.isTemp ? 1 : 0,
      'contents': jsonEncode(note.contents.map((c) => c.toJson()).toList()),
      'collaborators': jsonEncode(
        note.collaborators.map((c) => c.toJson()).toList(),
      ),
      'createdAt': note.createdAt.toIso8601String(),
      'updatedAt': note.updatedAt.toIso8601String(),
      'userId': note.userId,
    };
  }

  /// Converts a SQLite map from `temp_notes` into a [NoteModel].
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
      collaborators: const [],
      // temp notes do not track collaborators
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      userId: map['userId'],
    );
  }

  /// Retrieves all temporary notes for a specific user.
  ///
  /// Useful for restoring unsaved sessions across app restarts or crashes.
  Future<List<NoteModel>> getAllTempNotes(String userId) async {
    final db = await _dbService.database;
    final result = await db.query(
      TEMP_DB_NAME,
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'updatedAt DESC',
    );
    return result.map((map) => _sqliteMapToNote(map)).toList();
  }

  /// Retrieves a temporary note by its original note ID.
  ///
  /// Returns `null` if there is no temporary version of the note.
  Future<NoteModel?> getTempNoteById(String noteId) async {
    final db = await _dbService.database;
    final result = await db.query(
      TEMP_DB_NAME,
      where: 'id = ?',
      whereArgs: [noteId],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return _sqliteMapToNote(result.first);
  }

  /// Creates or updates a temporary note record.
  ///
  /// If a temp note already exists for the given note ID, it is replaced.
  /// This method is typically called during autosave cycles.
  Future<void> upsertTempNote(NoteModel note) async {
    final db = await _dbService.database;
    await db.insert(
      TEMP_DB_NAME,
      _noteToSQLiteMap(note),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Deletes a temporary note entry.
  ///
  /// Typically called when the user explicitly saves or discards changes.
  Future<int> deleteTempNote(String noteId) async {
    final db = await _dbService.database;
    return await db.delete(TEMP_DB_NAME, where: 'id = ?', whereArgs: [noteId]);
  }

  /// Clears all temporary notes for a specific user.
  ///
  /// Use carefully — this wipes all autosaved edits for that user.
  Future<int> clearAllTempNotes(String userId) async {
    final db = await _dbService.database;
    return await db.delete(
      TEMP_DB_NAME,
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }
}
