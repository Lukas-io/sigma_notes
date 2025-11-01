import 'package:uuid/uuid.dart';

class User {
  final String id; // UUID now!
  final String email;
  final String username;
  final String profilePicture;
  final bool isGuest;
  final DateTime createdAt;

  User({
    String? id, // Make it optional so we can generate
    required this.email,
    required this.username,
    required this.profilePicture,
    this.isGuest = false,
    DateTime? createdAt,
  }) : id = id ?? const Uuid().v4(),
       // Generate UUID if not provided
       createdAt = createdAt ?? DateTime.now();

  // ... rest of your methods stay the same
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'profilePicture': profilePicture,
      'isGuest': isGuest ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      username: map['username'],
      profilePicture: map['profilePicture'],
      isGuest: map['isGuest'] == 1,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  User copyWith({
    String? id,
    String? email,
    String? username,
    String? profilePicture,
    bool? isGuest,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      profilePicture: profilePicture ?? this.profilePicture,
      isGuest: isGuest ?? this.isGuest,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
