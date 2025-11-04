import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import '../../models/user.dart';
import '../database_service.dart';

class UserRepository {
  final DatabaseService _dbService;

  UserRepository({DatabaseService? dbService}) : _dbService = dbService ?? DatabaseService.instance;

  /// Get a user by their email
  Future<User?> getUserByEmail(String email) async {
    try {
      final db = await _dbService.database;
      final result = await db.query(
        USER_DB_NAME,
        where: 'email = ?',
        whereArgs: [email],
        limit: 1,
      );
      if (result.isEmpty) return null;
      return User.fromMap(result.first);
    } catch (e, st) {
      log('Error getting user by email: $e\n$st');
      return null;
    }
  }

  /// Get a user by their ID
  Future<User?> getUserById(String userId) async {
    try {
      final db = await _dbService.database;
      final result = await db.query(
        USER_DB_NAME,
        where: 'id = ?',
        whereArgs: [userId],
        limit: 1,
      );
      if (result.isEmpty) return null;
      return User.fromMap(result.first);
    } catch (e, st) {
      log('Error getting user by ID: $e\n$st');
      return null;
    }
  }

  /// Create a new user or update an existing one
  Future<void> saveUser(User user) async {
    try {
      final db = await _dbService.database;
      await db.insert(
        USER_DB_NAME,
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace, // Update if exists
      );
    } catch (e, st) {
      log('Error saving user: $e\n$st');
    }
  }

  /// Check if a user exists
  Future<bool> userExists(String userId) async {
    try {
      final db = await _dbService.database;
      final result = await db.query(
        USER_DB_NAME,
        where: 'id = ?',
        whereArgs: [userId],
        limit: 1,
      );
      return result.isNotEmpty;
    } catch (e, st) {
      log('Error checking if user exists: $e\n$st');
      return false;
    }
  }

  /// Get all users (for debugging)
  Future<List<User>> getAllUsers() async {
    try {
      final db = await _dbService.database;
      final result = await db.query('users');
      return result.map((map) => User.fromMap(map)).toList();
    } catch (e, st) {
      log('Error getting all users: $e\n$st');
      return [];
    }
  }

  /// Delete a user (CASCADE handles their notes)
  Future<void> deleteUser(String userId) async {
    try {
      final db = await _dbService.database;
      await db.delete('users', where: 'id = ?', whereArgs: [userId]);
    } catch (e, st) {
      log('Error deleting user: $e\n$st');
    }
  }
}
