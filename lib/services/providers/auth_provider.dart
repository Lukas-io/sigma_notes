import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

import '../../core/utils/username_generator.dart';
import '../../models/user.dart';
import '../repositories/user_repositories.dart';
import 'note_provider.dart';

part 'auth_provider.g.dart';

// Secure storage provider - keep alive since it's a lightweight singleton
@Riverpod(keepAlive: true)
FlutterSecureStorage secureStorage(Ref ref) {
  return const FlutterSecureStorage();
}

// User repository provider - keep alive since it's a lightweight singleton
@Riverpod(keepAlive: true)
UserRepository userRepository(Ref ref) {
  return UserRepository();
}

// Auth state notifier
@riverpod
class Auth extends _$Auth {
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _validEmail = 'test@sigma-logic.gr';
  static const String _validPassword = 'password123';

  @override
  Future<User?> build() async {
    // Check if user is already logged in on app start
    return await _checkExistingAuth();
  }

  // Check if user is already authenticated
  Future<User?> _checkExistingAuth() async {
    try {
      final storage = ref.read(secureStorageProvider);
      final token = await storage.read(key: _tokenKey);
      final userId = await storage.read(key: _userIdKey);

      if (token != null && userId != null) {
        // User is logged in, fetch their data
        final userRepo = ref.read(userRepositoryProvider);
        return await userRepo.getUserById(userId);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Login with email and password
  Future<bool> login(String email, String password) async {
    state = const AsyncValue.loading();

    try {
      // Validate credentials
      if (email != _validEmail || password != _validPassword) {
        state = const AsyncValue.data(null);
        return false;
      }

      // Check if user exists in database
      final userRepo = ref.read(userRepositoryProvider);
      User? user = await userRepo.getUserByEmail(email);

      // If user doesn't exist, create new user
      if (user == null) {
        user = User(
          email: email,
          username: UsernameGenerator.generateUsername(),
          profilePicture: UsernameGenerator.generateAvatar(),
          isGuest: false,
        );
        await userRepo.saveUser(user);
      }

      // Store auth token and user ID
      final storage = ref.read(secureStorageProvider);
      await storage.write(key: _tokenKey, value: 'mock_token_${user.id}');
      await storage.write(key: _userIdKey, value: user.id);

      // Update state
      state = AsyncValue.data(user);

      // Load notes for this user
      // Use a try-catch block to prevent errors from propagating
      try {
        await ref.read(notesProvider.notifier).loadNotesForCurrentUser();
      } catch (e) {
        // Log the error but don't let it break the login flow
        log('Error loading notes for user: $e');
      }

      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  // Create guest user
  Future<void> loginAsGuest() async {
    state = const AsyncValue.loading();

    try {
      final userRepo = ref.read(userRepositoryProvider);
      final id = Uuid().v4();

      // Create guest user
      final guestUser = User(
        id: id,
        email: '$id@guest.local',
        username: UsernameGenerator.generateUsername(),
        profilePicture: UsernameGenerator.generateAvatar(),
        isGuest: true,
      );

      await userRepo.saveUser(guestUser);

      // Store auth token and user ID
      final storage = ref.read(secureStorageProvider);
      await storage.write(key: _tokenKey, value: 'guest_token_${guestUser.id}');
      await storage.write(key: _userIdKey, value: guestUser.id);
      // Update state
      state = AsyncValue.data(guestUser);

      // Load notes for guest
      // Use a try-catch block to prevent errors from propagating
      try {
        await ref.read(notesProvider.notifier).loadNotesForCurrentUser();
      } catch (e) {
        // Log the error but don't let it break the login flow
        log('Error loading notes for guest: $e');
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  // Logout
  Future<void> logout() async {
    final storage = ref.read(secureStorageProvider);
    await storage.delete(key: _tokenKey);
    await storage.delete(key: _userIdKey);

    state = const AsyncValue.data(null);
  }

  // Check if currently logged in user is a guest
  bool isGuest() {
    return state.value?.isGuest ?? false;
  }

  // Get current user
  User? getCurrentUser() {
    return state.value;
  }
}
