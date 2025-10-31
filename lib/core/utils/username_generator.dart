import 'dart:math';

class UsernameGenerator {
  static final List<String> _prefixes = [
    'Sigma',
    'Cipher',
    'Note',
    'Vault',
    'Secure',
    'Logic',
    'Quantum',
    'Data',
    'Crypto',
    'Nexus',
    'Zen',
    'Prism',
    'Apex',
    'Void',
    'Echo',
    'Nova',
    'Phantom',
    'Astral',
  ];

  static final List<String> _suffixes = [
    'Vault',
    'Sage',
    'Keeper',
    'Guard',
    'Scribe',
    'Mind',
    'Note',
    'Sage',
    'Quill',
    'Keeper',
    'Vault',
    'Note',
    'Scribe',
    'Core',
    'Keeper',
    'Vault',
    'Mind',
    'Note',
    'Scribe',
    'Flux',
  ];

  static final List<String> _avatars = [
    'assets/images/avatar1.png',
    'assets/images/avatar2.png',
    'assets/images/avatar3.png',
  ];

  static final Random _random = Random();

  // Generate a random username like "SigmaVault42"
  static String generateUsername() {
    final prefix = _prefixes[_random.nextInt(_prefixes.length)];
    final suffix = _suffixes[_random.nextInt(_suffixes.length)];

    final number = _random.nextInt(99) + 1; // 1-99
    final numberStr = number.toString().padLeft(2, '0'); // 01, 02, etc.
    return '$prefix$suffix$numberStr';
  }

  // Pick a random avatar
  static String generateAvatar() {
    return _avatars[_random.nextInt(_avatars.length)];
  }
}
