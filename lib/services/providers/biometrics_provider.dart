import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:local_auth/local_auth.dart';

import 'package:local_auth_platform_interface/types/auth_messages.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';
import 'package:local_auth_android/local_auth_android.dart';

part 'biometrics_provider.g.dart';

// Keep this provider alive since LocalAuthentication is lightweight
// and we don't want to recreate it constantly
@Riverpod(keepAlive: true)
LocalAuthentication localAuth(Ref ref) {
  return LocalAuthentication();
}

/// Service class that handles biometric authentication
/// This is a pure service - no Riverpod refs needed, so no lifecycle issues
class BiometricService {
  /// Check if biometrics are available on device
  static Future<bool> canCheckBiometrics(LocalAuthentication auth) async {
    try {
      return await auth.canCheckBiometrics || await auth.isDeviceSupported();
    } catch (e) {
      return false;
    }
  }

  /// Get available biometric types
  static Future<List<BiometricType>> getAvailableBiometrics(
      LocalAuthentication auth) async {
    try {
      return await auth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }

  /// Authenticate using biometrics
  static Future<BiometricAuthResult> authenticate({
    required LocalAuthentication auth,
    required String localizedReason,
    bool sensitiveTransaction = true,
  }) async {
    try {
      // Check if biometrics are available
      final canCheck = await canCheckBiometrics(auth);
      if (!canCheck) {
        return BiometricAuthResult(
          success: false,
          errorType: BiometricErrorType.notAvailable,
          errorMessage: 'Biometric authentication is not available',
        );
      }

      // Check enrolled biometrics
      final availableBiometrics = await getAvailableBiometrics(auth);
      if (availableBiometrics.isEmpty) {
        return BiometricAuthResult(
          success: false,
          errorType: BiometricErrorType.notEnrolled,
          errorMessage: 'No biometrics enrolled on this device',
        );
      }

      // Perform authentication
      final authenticated = await auth.authenticate(
        localizedReason: localizedReason,
        biometricOnly: sensitiveTransaction,
        sensitiveTransaction: sensitiveTransaction,
        authMessages: <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: 'Biometric Authentication',
            cancelButton: 'Cancel',
            signInHint: 'Verify your identity',
          ),
          IOSAuthMessages(cancelButton: 'Cancel'),
        ],
      );

      return BiometricAuthResult(
        success: authenticated,
        errorType: authenticated ? null : BiometricErrorType.authFailed,
        errorMessage: authenticated ? null : 'Authentication failed',
      );
    } catch (e) {
      return _handleError(e);
    }
  }

  /// Handle authentication errors
  static BiometricAuthResult _handleError(dynamic error) {
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('locked out')) {
      return BiometricAuthResult(
        success: false,
        errorType: BiometricErrorType.lockedOut,
        errorMessage: 'Too many attempts. Please try again later',
      );
    } else if (errorString.contains('canceled') ||
        errorString.contains('user_cancel')) {
      return BiometricAuthResult(
        success: false,
        errorType: BiometricErrorType.userCanceled,
        errorMessage: 'Authentication canceled by user',
      );
    } else if (errorString.contains('not available')) {
      return BiometricAuthResult(
        success: false,
        errorType: BiometricErrorType.notAvailable,
        errorMessage: 'Biometric authentication not available',
      );
    } else if (errorString.contains('permission')) {
      return BiometricAuthResult(
        success: false,
        errorType: BiometricErrorType.permissionDenied,
        errorMessage: 'Biometric permission denied',
      );
    }

    return BiometricAuthResult(
      success: false,
      errorType: BiometricErrorType.unknown,
      errorMessage: 'Authentication error: ${error.toString()}',
    );
  }
}

/// Result of biometric authentication
class BiometricAuthResult {
  final bool success;
  final BiometricErrorType? errorType;
  final String? errorMessage;

  BiometricAuthResult({
    required this.success,
    this.errorType,
    this.errorMessage,
  });

  @override
  String toString() {
    return 'BiometricAuthResult(success: $success, errorType: $errorType, message: $errorMessage)';
  }
}

/// Types of biometric authentication errors
enum BiometricErrorType {
  notAvailable,
  notEnrolled,
  authFailed,
  userCanceled,
  lockedOut,
  permissionDenied,
  unknown,
}
