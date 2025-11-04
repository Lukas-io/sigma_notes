import 'package:flutter_test/flutter_test.dart';
import 'package:sigma_notes/models/user.dart';

void main() {
  group('User', () {
    final testUser = User(
      id: 'user_123',
      email: 'test@example.com',
      username: 'testuser',
      profilePicture: 'https://example.com/avatar.png',
      isGuest: false,
      isAdmin: false,
    );

    group('Constructor', () {
      test('creates user with provided values', () {
        expect(testUser.id, equals('user_123'));
        expect(testUser.email, equals('test@example.com'));
        expect(testUser.username, equals('testuser'));
        expect(
          testUser.profilePicture,
          equals('https://example.com/avatar.png'),
        );
        expect(testUser.isGuest, isFalse);
        expect(testUser.isAdmin, isFalse);
        expect(testUser.createdAt, isA<DateTime>());
      });

      test('generates ID and createdAt when not provided', () {
        final user = User(email: 'test2@example.com', username: 'testuser2');

        expect(user.id, isNotNull);
        expect(user.id, isNotEmpty);
        expect(user.createdAt, isA<DateTime>());
      });
    });

    group('toMap', () {
      test('converts user to map correctly', () {
        final map = testUser.toMap();

        expect(map['id'], equals(testUser.id));
        expect(map['email'], equals(testUser.email));
        expect(map['username'], equals(testUser.username));
        expect(map['profilePicture'], equals(testUser.profilePicture));
        expect(map['isGuest'], equals(testUser.isGuest ? 1 : 0));
        expect(map['isAdmin'], equals(testUser.isAdmin ? 1 : 0));
        expect(map['createdAt'], equals(testUser.createdAt.toIso8601String()));
      });
    });

    group('fromMap', () {
      test('creates user from map correctly', () {
        final map = {
          'id': 'user_456',
          'email': 'test2@example.com',
          'username': 'testuser2',
          'profilePicture': 'https://example.com/avatar2.png',
          'isGuest': 1,
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
          'isAdmin': 1,
        };

        final user = User.fromMap(map);

        expect(user.id, equals(map['id']));
        expect(user.email, equals(map['email']));
        expect(user.username, equals(map['username']));
        expect(user.profilePicture, equals(map['profilePicture']));
        expect(user.isGuest, isTrue);
        expect(user.isAdmin, isTrue);
        expect(user.createdAt, isA<DateTime>());
      });
    });

    group('toJson and fromJson', () {
      test('converts to and from JSON correctly', () {
        final json = testUser.toJson();
        final userFromJson = User.fromJson(json);

        expect(userFromJson.id, equals(testUser.id));
        expect(userFromJson.email, equals(testUser.email));
        expect(userFromJson.username, equals(testUser.username));
      });
    });

    group('isValidEmail', () {
      test('returns true for valid email', () {
        final user = User(email: 'valid@example.com', username: 'validuser');

        expect(user.isValidEmail, isTrue);
      });

      test('returns false for invalid email', () {
        final user = User(email: 'invalid-email', username: 'invaliduser');

        expect(user.isValidEmail, isFalse);
      });
    });

    group('displayName', () {
      test('returns username when available', () {
        expect(testUser.displayName, equals('testuser'));
      });

      test('returns email prefix when username is empty', () {
        final user = User(email: 'test@example.com', username: '');

        expect(user.displayName, equals('test'));
      });
    });

    group('copyWith', () {
      test('creates new user with updated fields', () {
        final updatedUser = testUser.copyWith(
          username: 'updateduser',
          isGuest: true,
        );

        expect(updatedUser.id, equals(testUser.id));
        expect(updatedUser.email, equals(testUser.email));
        expect(updatedUser.username, equals('updateduser'));
        expect(updatedUser.isGuest, isTrue);
        expect(updatedUser.isAdmin, equals(testUser.isAdmin));
      });
    });

    group('Equality', () {
      test('users with same ID are equal', () {
        final user1 = User(
          id: 'same_id',
          email: 'user1@example.com',
          username: 'user1',
        );

        final user2 = User(
          id: 'same_id',
          email: 'user2@example.com',
          username: 'user2',
        );

        expect(user1, equals(user2));
      });

      test('users with different IDs are not equal', () {
        final user1 = User(
          id: 'id_1',
          email: 'user1@example.com',
          username: 'user1',
        );

        final user2 = User(
          id: 'id_2',
          email: 'user1@example.com',
          username: 'user1',
        );

        expect(user1, isNot(equals(user2)));
      });
    });

    group('toString', () {
      test('returns string representation', () {
        final stringRepresentation = testUser.toString();
        expect(stringRepresentation, contains('User'));
        expect(stringRepresentation, contains(testUser.id));
        expect(stringRepresentation, contains(testUser.email));
      });
    });
  });
}
