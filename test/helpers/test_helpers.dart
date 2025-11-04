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
  // Initialize FFI only once to avoid repeated sqflite warnings
  // about changing the default factory
  // ignore: prefer_const_declarations
  final String _marker = '_ffi_initialized_marker_';
  // Use a Zone-scoped marker via sqflite debugInfo to avoid globals
  // Fallback to a simple static-like approach with an environment check
  // For simplicity, use a top-level static via library private variable
  if (_ffiInitialized) {
    return;
  }
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  _ffiInitialized = true;
}

// Library-private flag to ensure one-time initialization
bool _ffiInitialized = false;
