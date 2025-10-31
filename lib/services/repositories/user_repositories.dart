import 'package:sqflite/sqflite.dart';

import '../../models/user.dart';
import '../database_service.dart';

class UserRepository {
  final DatabaseService _dbService = DatabaseService.instance;

  // Get user by ID (email)
  Future<User?> getUserById(String userId) async {
    final db = await _dbService.database;
    final result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return User.fromMap(result.first);
  }

  // Create or update user
  Future<void> saveUser(User user) async {
    final db = await _dbService.database;
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace, // Update if exists
    );
  }

  // Check if user exists
  Future<bool> userExists(String userId) async {
    final db = await _dbService.database;
    final result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  // Get all users (for debugging)
  Future<List<User>> getAllUsers() async {
    final db = await _dbService.database;
    final result = await db.query('users');
    return result.map((map) => User.fromMap(map)).toList();
  }

  // Delete user and their notes (CASCADE will handle notes)
  Future<void> deleteUser(String userId) async {
    final db = await _dbService.database;
    await db.delete('users', where: 'id = ?', whereArgs: [userId]);
  }
}
