import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:local_auth/local_auth.dart';

import 'package:local_auth_platform_interface/types/auth_messages.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';
import 'package:local_auth_android/local_auth_android.dart';

part 'biometrics_provider.g.dart';

@riverpod
LocalAuthentication localAuth(Ref ref) {
  return LocalAuthentication();
}

@riverpod
class Biometrics extends _$Biometrics {
  @override
  FutureOr<bool> build() async {
    // Check if biometrics is available on device
    return await _checkBiometrics();
  }

  Future<bool> _checkBiometrics() async {
    final auth = ref.read(localAuthProvider);
    try {
      return await auth.canCheckBiometrics || await auth.isDeviceSupported();
    } catch (e) {
      return false;
    }
  }

  Future<BiometricAuthResult> authenticate({
    required String localizedReason,
    bool useErrorDialogs = true,
    bool stickyAuth = false,
    bool sensitiveTransaction = true,
  }) async {
    // Use `ref.read` once at the start
    final auth = ref.read(localAuthProvider);

    try {
      // Async gap: check if provider is still mounted
      if (!ref.mounted)
        return BiometricAuthResult(
          success: false,
          errorType: BiometricErrorType.unknown,
          errorMessage: 'Provider disposed before authentication',
        );

      // Check if biometrics are available
      final canCheckBiometrics = await _checkBiometrics();
      if (!ref.mounted)
        return BiometricAuthResult(
          success: false,
          errorType: BiometricErrorType.unknown,
          errorMessage: 'Provider disposed during biometric check',
        );

      if (!canCheckBiometrics) {
        return BiometricAuthResult(
          success: false,
          errorType: BiometricErrorType.notAvailable,
          errorMessage: 'Biometric authentication is not available',
        );
      }

      // Check enrolled biometrics
      final availableBiometrics = await getAvailableBiometrics();
      if (!ref.mounted)
        return BiometricAuthResult(
          success: false,
          errorType: BiometricErrorType.unknown,
          errorMessage: 'Provider disposed during biometric availability check',
        );

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

      if (!ref.mounted) {
        return BiometricAuthResult(
          success: false,
          errorType: BiometricErrorType.unknown,
          errorMessage: 'Provider disposed during authentication',
        );
      }

      return BiometricAuthResult(
        success: authenticated,
        errorType: authenticated ? null : BiometricErrorType.authFailed,
        errorMessage: authenticated ? null : 'Authentication failed',
      );
    } catch (e) {
      if (!ref.mounted) {
        return BiometricAuthResult(
          success: false,
          errorType: BiometricErrorType.unknown,
          errorMessage: 'Provider disposed while handling exception',
        );
      }
      return _handleError(e);
    }
  }

  // Get available biometrics
  Future<List<BiometricType>> getAvailableBiometrics() async {
    final auth = ref.read(localAuthProvider);
    try {
      return await auth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }

  /// Handle authentication errors
  BiometricAuthResult _handleError(dynamic error) {
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
