import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sigma_notes/models/user.dart';
import 'package:sigma_notes/services/database_service.dart';
import 'package:sigma_notes/services/repositories/user_repositories.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('UserRepository', () {
    late UserRepository userRepository;
    late MockDatabase mockDatabase;

    final testUser = User(
      id: 'user_123',
      email: 'test@example.com',
      username: 'testuser',
      isGuest: false,
    );

    setUp(() {
      mockDatabase = MockDatabase();
      final mockDatabaseService = MockDatabaseService();
      mockDatabaseService.mockDatabase = mockDatabase;
      userRepository = UserRepository(dbService: mockDatabaseService);
    });

    group('getUserByEmail', () {
      test('returns user when found by email', () async {
        final email = 'test@example.com';
        final mockResult = [
          {
            'id': testUser.id,
            'email': email,
            'username': testUser.username,
            'profilePicture': null,
            'isGuest': 0,
            'createdAt': DateTime.now().toIso8601String(),
            'updatedAt': null,
            'isAdmin': 0,
          },
        ];

        when(
          () => mockDatabase.query(
            any(),
            where: any(named: 'where'),
            whereArgs: any(named: 'whereArgs'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) async => mockResult);

        final user = await userRepository.getUserByEmail(email);

        expect(user, isNotNull);
        expect(user!.email, equals(email));
        expect(user.username, equals(testUser.username));
      });

      test('returns null when user not found by email', () async {
        final email = 'nonexistent@example.com';

        when(
          () => mockDatabase.query(
            any(),
            where: any(named: 'where'),
            whereArgs: any(named: 'whereArgs'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) async => []);

        final user = await userRepository.getUserByEmail(email);

        expect(user, isNull);
      });
    });

    group('getUserById', () {
      test('returns user when found by ID', () async {
        final userId = 'user_123';
        final mockResult = [
          {
            'id': userId,
            'email': testUser.email,
            'username': testUser.username,
            'profilePicture': null,
            'isGuest': 0,
            'createdAt': DateTime.now().toIso8601String(),
            'updatedAt': null,
            'isAdmin': 0,
          },
        ];

        when(
          () => mockDatabase.query(
            any(),
            where: any(named: 'where'),
            whereArgs: any(named: 'whereArgs'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) async => mockResult);

        final user = await userRepository.getUserById(userId);

        expect(user, isNotNull);
        expect(user!.id, equals(userId));
        expect(user.email, equals(testUser.email));
      });

      test('returns null when user not found by ID', () async {
        final userId = 'nonexistent';

        when(
          () => mockDatabase.query(
            any(),
            where: any(named: 'where'),
            whereArgs: any(named: 'whereArgs'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) async => []);

        final user = await userRepository.getUserById(userId);

        expect(user, isNull);
      });
    });

    group('saveUser', () {
      test('saves user to database', () async {
        when(
          () => mockDatabase.insert(
            any(),
            any(),
            conflictAlgorithm: any(named: 'conflictAlgorithm'),
          ),
        ).thenAnswer((_) async => 1);

        await userRepository.saveUser(testUser);

        verify(
          () => mockDatabase.insert(
            any(),
            any(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          ),
        ).called(1);
      });
    });

    group('userExists', () {
      test('returns true when user exists', () async {
        final userId = 'user_123';

        when(
          () => mockDatabase.query(
            any(),
            where: any(named: 'where'),
            whereArgs: any(named: 'whereArgs'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer(
          (_) async => [
            {
              'id': userId,
              'email': testUser.email,
              'username': testUser.username,
              'profilePicture': null,
              'isGuest': 0,
              'createdAt': DateTime.now().toIso8601String(),
              'updatedAt': null,
              'isAdmin': 0,
            },
          ],
        );

        final exists = await userRepository.userExists(userId);

        expect(exists, isTrue);
      });

      test('returns false when user does not exist', () async {
        final userId = 'nonexistent';

        when(
          () => mockDatabase.query(
            any(),
            where: any(named: 'where'),
            whereArgs: any(named: 'whereArgs'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) async => []);

        final exists = await userRepository.userExists(userId);

        expect(exists, isFalse);
      });
    });

    group('getAllUsers', () {
      test('returns list of all users', () async {
        final mockResult = [
          {
            'id': 'user_1',
            'email': 'user1@example.com',
            'username': 'user1',
            'profilePicture': null,
            'isGuest': 0,
            'createdAt': DateTime.now().toIso8601String(),
            'updatedAt': null,
            'isAdmin': 0,
          },
          {
            'id': 'user_2',
            'email': 'user2@example.com',
            'username': 'user2',
            'profilePicture': null,
            'isGuest': 1,
            'createdAt': DateTime.now().toIso8601String(),
            'updatedAt': null,
            'isAdmin': 0,
          },
        ];

        when(
          () => mockDatabase.query(any()),
        ).thenAnswer((_) async => mockResult);

        final users = await userRepository.getAllUsers();

        expect(users, isA<List<User>>());
        expect(users.length, equals(2));
      });

      test('returns empty list when no users exist', () async {
        when(() => mockDatabase.query(any())).thenAnswer((_) async => []);

        final users = await userRepository.getAllUsers();

        expect(users, isA<List<User>>());
        expect(users, isEmpty);
      });
    });

    group('deleteUser', () {
      test('deletes user by ID', () async {
        final userId = 'user_123';

        when(
          () => mockDatabase.delete(
            any(),
            where: any(named: 'where'),
            whereArgs: any(named: 'whereArgs'),
          ),
        ).thenAnswer((_) async => 1);

        await userRepository.deleteUser(userId);

        verify(
          () =>
              mockDatabase.delete(any(), where: 'id = ?', whereArgs: [userId]),
        ).called(1);
      });
    });
  });
}

class MockDatabaseService extends Mock implements DatabaseService {
  Database? mockDatabase;

  @override
  Future<Database> get database async => mockDatabase!;
}
