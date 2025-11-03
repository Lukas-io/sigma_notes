import 'package:uuid/uuid.dart';

/// Represents an application user.
class User {
  /// Unique identifier for the user.
  final String id;

  /// User's email address.
  final String email;

  /// User's display username.
  final String username;

  /// Optional URL of the user's profile picture.
  final String? profilePicture;

  /// Indicates if the user is a guest (not fully registered).
  final bool isGuest;

  /// Date when the user was created.
  final DateTime createdAt;

  /// Date when the user was last updated.
  final DateTime? updatedAt;

  /// Flag to indicate if the user is an admin.
  final bool isAdmin;

  /// Creates a new [User] instance.
  ///
  /// If [id] or [createdAt] are not provided, they are automatically generated.
  User({
    String? id,
    required this.email,
    required this.username,
    this.profilePicture,
    this.isGuest = false,
    DateTime? createdAt,
    this.updatedAt,
    this.isAdmin = false,
  }) : id = id ?? Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  /// Converts the [User] object to a Map suitable for storage (e.g., SQLite).
  Map<String, dynamic> toMap() => {
    'id': id,
    'email': email,
    'username': username,
    'profilePicture': profilePicture,
    'isGuest': isGuest ? 1 : 0,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    'isAdmin': isAdmin ? 1 : 0,
  };

  /// Creates a [User] instance from a Map.
  factory User.fromMap(Map<String, dynamic> map) => User(
    id: map['id'],
    email: map['email'],
    username: map['username'],
    profilePicture: map['profilePicture'],
    isGuest: map['isGuest'] == 1,
    createdAt: DateTime.parse(map['createdAt']),
    updatedAt: map['updatedAt'] != null
        ? DateTime.parse(map['updatedAt'])
        : null,
    isAdmin: map['isAdmin'] == 1,
  );

  /// Converts the [User] object to JSON.
  Map<String, dynamic> toJson() => toMap();

  /// Creates a [User] object from JSON.
  factory User.fromJson(Map<String, dynamic> json) => User.fromMap(json);

  /// Returns `true` if the user's email is valid.
  bool get isValidEmail =>
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);

  /// Returns a display name for the user, falling back to email prefix if username is empty.
  String get displayName =>
      username.isNotEmpty ? username : email.split('@')[0];

  /// Returns a new [User] object with updated fields.
  User copyWith({
    String? id,
    String? email,
    String? username,
    String? profilePicture,
    bool? isGuest,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isAdmin,
  }) => User(
    id: id ?? this.id,
    email: email ?? this.email,
    username: username ?? this.username,
    profilePicture: profilePicture ?? this.profilePicture,
    isGuest: isGuest ?? this.isGuest,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isAdmin: isAdmin ?? this.isAdmin,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is User && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'User(id: $id, email: $email, username: $username, isGuest: $isGuest, isAdmin: $isAdmin)';
  }
}
