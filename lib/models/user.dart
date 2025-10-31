class User {
  final String id; // Unique ID (we'll use email as ID for simplicity)
  final String email;
  final String username;
  final String profilePicture; // Asset path like 'assets/avatars/avatar1.png'
  final bool isGuest;
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.profilePicture,
    this.isGuest = false,
    required this.createdAt,
  });

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

  // Copy with method for updating user
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
