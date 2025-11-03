import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final NOTE_DB_NAME = "notes";
final TEMP_DB_NAME = "temp_notes";
final USER_DB_NAME = "users";

/// Singleton service for managing SQLite database operations
class DatabaseService {
  static Database? _database;

  /// Singleton instance
  static final DatabaseService instance = DatabaseService._init();

  DatabaseService._init();

  /// Returns the active database connection, initializes if null
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('sigma_notes.db');
    return _database!;
  }

  /// Initializes the database at [filePath] and applies migrations
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  /// Creates database tables on first run
  Future _createDB(Database db, int version) async {
    // Users table
    await db.execute('''
CREATE TABLE IF NOT EXISTS $USER_DB_NAME (
        id TEXT PRIMARY KEY,
        email TEXT NOT NULL,
        username TEXT NOT NULL,
        profilePicture TEXT,
        isGuest INTEGER NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT,
        isAdmin INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Notes table
    await db.execute('''
CREATE TABLE IF NOT EXISTS $NOTE_DB_NAME (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        thumbnail TEXT,
        label TEXT,
        locked INTEGER NOT NULL DEFAULT 0,
        isPinned INTEGER NOT NULL DEFAULT 0,
        isTemp INTEGER NOT NULL DEFAULT 0,
        contents TEXT NOT NULL,
        collaborators TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        userId TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
  CREATE TABLE IF NOT EXISTS $TEMP_DB_NAME (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    thumbnail TEXT,
    label TEXT,
    locked INTEGER NOT NULL DEFAULT 0,
    isPinned INTEGER NOT NULL DEFAULT 0,
    isTemp INTEGER NOT NULL DEFAULT 1,
    contents TEXT NOT NULL,
    collaborators TEXT NOT NULL,
    createdAt TEXT NOT NULL,
    updatedAt TEXT NOT NULL,
    userId TEXT NOT NULL,
    FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE
  )
''');
  }

  /// Handles migrations between database versions
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add updatedAt column to users if missing
      await db.execute('ALTER TABLE users ADD COLUMN updatedAt TEXT');
      // Add isAdmin column
      await db.execute(
        'ALTER TABLE users ADD COLUMN isAdmin INTEGER NOT NULL DEFAULT 0',
      );
    }
  }

  /// Closes the database connection
  Future close() async {
    final db = await database;
    await db.close();
  }
}
