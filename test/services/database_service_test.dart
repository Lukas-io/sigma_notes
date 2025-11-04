import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sigma_notes/services/database_service.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('DatabaseService', () {
    setUp(() {
      print('\n=== Setting up sqflite_ffi for tests ===');
      initializeFfi();
    });

    test('should initialize database successfully', () async {
      print('\n=== Testing: Initialize database ===');
      final db = await DatabaseService.instance.database;
      // Execute a simple pragma to prove the connection is live
      final pragma = await db.rawQuery('PRAGMA user_version');
      print('PRAGMA user_version result: $pragma');
      expect(pragma, isA<List<Map<String, Object?>>>());
      print('✅ Test PASSED: Database initialized');
    });

    test('should create users table with correct schema', () async {
      print('\n=== Testing: Users table schema ===');
      final db = await DatabaseService.instance.database;
      final columns = await db.rawQuery('PRAGMA table_info(users)');
      final names = columns.map((c) => c['name']).toList();
      print('Users columns: $names');
      expect(names, containsAll(['id', 'email', 'username', 'profilePicture', 'isGuest', 'createdAt', 'updatedAt', 'isAdmin']));
      print('✅ Test PASSED: Users table schema OK');
    });

    test('should create notes table with correct schema', () async {
      print('\n=== Testing: Notes table schema ===');
      final db = await DatabaseService.instance.database;
      final columns = await db.rawQuery('PRAGMA table_info(notes)');
      final names = columns.map((c) => c['name']).toList();
      print('Notes columns: $names');
      expect(names, containsAll(['id', 'title', 'thumbnail', 'label', 'locked', 'isPinned', 'isTemp', 'contents', 'collaborators', 'createdAt', 'updatedAt', 'userId']));
      print('✅ Test PASSED: Notes table schema OK');
    });

    test('should create foreign key constraint between notes and users', () async {
      print('\n=== Testing: Foreign key notes(userId) -> users(id) ===');
      final db = await DatabaseService.instance.database;
      final fk = await db.rawQuery('PRAGMA foreign_key_list(notes)');
      print('Foreign keys: $fk');
      // Look for parent table 'users' and from column 'userId'
      final hasFk = fk.any((row) => row['table'] == 'users');
      expect(hasFk, isTrue);
      print('✅ Test PASSED: Foreign key exists');
    });

    test('should return same database instance on multiple calls (singleton)', () async {
      print('\n=== Testing: Singleton database instance ===');
      final a = await DatabaseService.instance.database;
      final b = await DatabaseService.instance.database;
      print('Expected: identical instances, Actual: ${identical(a, b)}');
      expect(identical(a, b), isTrue);
      print('✅ Test PASSED: Singleton DB instance');
    });

    test('should handle database path resolution and file creation', () async {
      print('\n=== Testing: Database path resolution and file creation ===');
      final dbPath = await getDatabasesPath();
      final fullPath = p.join(dbPath, 'sigma_notes.db');
      await DatabaseService.instance.database;
      final exists = File(fullPath).existsSync();
      print('DB Path: $fullPath, Exists: $exists');
      expect(exists, isTrue);
      print('✅ Test PASSED: Database file created at resolved path');
    });
  });
}
