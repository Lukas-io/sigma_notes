import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// Mock classes for external dependencies
class MockDatabase extends Mock implements Database {}

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

class MockDatabaseFactory extends Mock implements DatabaseFactory {}

// Register fallback values for mocktail
void registerFallbackValues() {
  registerFallbackValue(OpenDatabaseOptions());
  registerFallbackValue(ConflictAlgorithm.rollback);
}

// Initialize FFI for testing
void initializeFfi() {
  // Initialize FFI for testing
  sqfliteFfiInit();
  // Change the default factory
  databaseFactory = databaseFactoryFfi;
}
