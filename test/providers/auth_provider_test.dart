import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';
import 'package:sigma_notes/models/user.dart';
import 'package:sigma_notes/services/providers/auth_provider.dart';
import 'package:sigma_notes/services/providers/note_provider.dart';
import 'package:sigma_notes/services/repositories/user_repositories.dart';

import '../helpers/test_helpers.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  setUpAll(() {
    registerFallbackValues();
    // Needed for any<User>() in mocks
    registerFallbackValue(User(id: 'fallback', email: 'f@f.com', username: 'f'));
  });

  group('Auth Provider', () {
    late MockSecureStorage mockStorage;
    late MockUserRepository mockUserRepository;
    late ProviderContainer container;

    const validEmail = 'test@sigma-logic.gr';
    const validPassword = 'password123';

    final existingUser = User(
      id: 'user_existing',
      email: validEmail,
      username: 'existing_user',
      isGuest: false,
    );

    ProviderContainer createContainer() {
      return ProviderContainer(overrides: [
        secureStorageProvider.overrideWithValue(mockStorage),
        userRepositoryProvider.overrideWithValue(mockUserRepository),
        // Provide a benign notes notifier to swallow calls from auth
        notesProvider.overrideWith(NotesNotifier.new),
      ]);
    }

    setUp(() {
      mockStorage = MockSecureStorage();
      mockUserRepository = MockUserRepository();
      container = createContainer();
    });

    tearDown(() async {
      container.dispose();
    });

    test('should login successfully with valid credentials', () async {
      print('\n=== Testing: Login with valid credentials ===');
      print('Input: email=$validEmail, password=$validPassword');

      when(() => mockUserRepository.getUserByEmail(validEmail))
          .thenAnswer((_) async => existingUser);
      when(() => mockStorage.write(key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async {});

      final result = await container.read(authProvider.notifier).login(validEmail, validPassword);

      print('Expected: Login success = true');
      print('Actual: Login success = $result');
      expect(result, isTrue);

      final stateUser = container.read(authProvider).value;
      print('Expected: state user email = $validEmail');
      print('Actual: state user email = ${stateUser?.email}');
      expect(stateUser?.email, equals(validEmail));

      verify(() => mockStorage.write(key: 'auth_token', value: any(named: 'value'))).called(1);
      verify(() => mockStorage.write(key: 'user_id', value: existingUser.id)).called(1);
      print('✅ Test PASSED: Login succeeded with valid credentials\n');
    });

    test('should return false when email is invalid', () async {
      print('\n=== Testing: Login with invalid email ===');
      print('Input: email=wrong@email.com, password=$validPassword');

      // No repository calls expected
      final result = await container.read(authProvider.notifier).login('wrong@email.com', validPassword);

      print('Expected: Login success = false');
      print('Actual: Login success = $result');
      expect(result, isFalse);
      expect(container.read(authProvider).value, isNull);
      verifyNever(() => mockStorage.write(key: any(named: 'key'), value: any(named: 'value')));
      print('✅ Test PASSED: Invalid email rejected\n');
    });

    test('should return false when password is invalid', () async {
      print('\n=== Testing: Login with invalid password ===');
      print('Input: email=$validEmail, password=wrong');

      final result = await container.read(authProvider.notifier).login(validEmail, 'wrong');

      print('Expected: Login success = false');
      print('Actual: Login success = $result');
      expect(result, isFalse);
      expect(container.read(authProvider).value, isNull);
      verifyNever(() => mockStorage.write(key: any(named: 'key'), value: any(named: 'value')));
      print('✅ Test PASSED: Invalid password rejected\n');
    });

    test('should clear token from secure storage on logout', () async {
      print('\n=== Testing: Logout clears secure storage ===');

      when(() => mockUserRepository.getUserByEmail(validEmail))
          .thenAnswer((_) async => existingUser);
      when(() => mockStorage.write(key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async {});
      when(() => mockStorage.delete(key: any(named: 'key'))).thenAnswer((_) async {});

      await container.read(authProvider.notifier).login(validEmail, validPassword);
      print('Before logout: state user exists = ${container.read(authProvider).value != null}');

      await container.read(authProvider.notifier).logout();

      verify(() => mockStorage.delete(key: 'auth_token')).called(1);
      verify(() => mockStorage.delete(key: 'user_id')).called(1);
      print('After logout: state user exists = ${container.read(authProvider).value != null}');
      expect(container.read(authProvider).value, isNull);
      print('✅ Test PASSED: Logout cleared tokens and state\n');
    });

    test('should create new user on first login', () async {
      print('\n=== Testing: Create new user on first login ===');
      when(() => mockUserRepository.getUserByEmail(validEmail)).thenAnswer((_) async => null);
      when(() => mockUserRepository.saveUser(any())).thenAnswer((_) async {});
      when(() => mockStorage.write(key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async {});

      final result = await container.read(authProvider.notifier).login(validEmail, validPassword);
      expect(result, isTrue);
      verify(() => mockUserRepository.saveUser(any())).called(1);
      print('✅ Test PASSED: New user created and saved\n');
    });

    test('should load existing user on subsequent login', () async {
      print('\n=== Testing: Load existing user on login ===');
      when(() => mockUserRepository.getUserByEmail(validEmail))
          .thenAnswer((_) async => existingUser);
      when(() => mockStorage.write(key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async {});

      final result = await container.read(authProvider.notifier).login(validEmail, validPassword);
      expect(result, isTrue);
      verifyNever(() => mockUserRepository.saveUser(any()));
      print('✅ Test PASSED: Existing user loaded (no save)\n');
    });

    test('should persist auth token in secure storage', () async {
      print('\n=== Testing: Persist auth token in secure storage ===');
      when(() => mockUserRepository.getUserByEmail(validEmail))
          .thenAnswer((_) async => existingUser);
      when(() => mockStorage.write(key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async {});

      await container.read(authProvider.notifier).login(validEmail, validPassword);
      verify(() => mockStorage.write(key: 'auth_token', value: any(named: 'value'))).called(1);
      verify(() => mockStorage.write(key: 'user_id', value: existingUser.id)).called(1);
      print('✅ Test PASSED: Token and user_id persisted\n');
    });

    test('should restore user session from stored token on app start', () async {
      print('\n=== Testing: Restore session from stored token ===');
      when(() => mockStorage.read(key: 'auth_token')).thenAnswer((_) async => 'mock_token_${existingUser.id}');
      when(() => mockStorage.read(key: 'user_id')).thenAnswer((_) async => existingUser.id);
      when(() => mockUserRepository.getUserById(existingUser.id))
          .thenAnswer((_) async => existingUser);

      // Recreate container so provider build() runs and checks storage
      container.dispose();
      container = ProviderContainer(overrides: [
        secureStorageProvider.overrideWithValue(mockStorage),
        userRepositoryProvider.overrideWithValue(mockUserRepository),
        notesProvider.overrideWith(NotesNotifier.new),
      ]);

      // Force build() path
      final user = await container.read(authProvider.notifier).build();
      print('Expected: Restored user email = $validEmail');
      print('Actual: Restored user email = ${user?.email}');
      expect(user?.email, equals(validEmail));
      print('✅ Test PASSED: Session restored from storage\n');
    });

    test('should create guest user with generated username and not require password', () async {
      print('\n=== Testing: Guest user login ===');
      when(() => mockUserRepository.saveUser(any())).thenAnswer((_) async {});
      when(() => mockStorage.write(key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async {});

      await container.read(authProvider.notifier).loginAsGuest();
      final user = container.read(authProvider).value;
      print('Expected: isGuest = true');
      print('Actual: isGuest = ${user?.isGuest}');
      expect(user, isNotNull);
      expect(user!.isGuest, isTrue);
      verify(() => mockStorage.write(key: 'auth_token', value: any(named: 'value'))).called(1);
      verify(() => mockStorage.write(key: 'user_id', value: any(named: 'value'))).called(1);
      print('✅ Test PASSED: Guest user created without password\n');
    });
  });
}
