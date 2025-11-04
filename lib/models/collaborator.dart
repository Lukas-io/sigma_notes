/// Represents someone who has access to a note.
class Collaborator {
  /// The unique ID of the user.
  final String userId;

  /// The email of the collaborator.
  final String email;

  /// Optional name of the collaborator.
  final String? name;

  /// URL of the collaborator's profile image.
  final String? profileImageUrl;

  /// The role/permission level of the collaborator.
  final CollaboratorRole role;

  /// The timestamp when the collaborator was added.
  final DateTime addedAt;

  /// Creates a new [Collaborator].
  ///
  /// [addedAt] defaults to `DateTime.now()` if not provided.
  Collaborator({
    required this.userId,
    required this.email,
    this.name,
    this.profileImageUrl,
    this.role = CollaboratorRole.viewer,
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();

  /// Converts this [Collaborator] to a map suitable for database storage.
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'email': email,
      'name': name,
      'profileImageUrl': profileImageUrl,
      'role': role.name,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  /// Creates a [Collaborator] from a database map.
  factory Collaborator.fromMap(Map<String, dynamic> map) {
    return Collaborator(
      userId: map['userId'],
      email: map['email'],
      name: map['name'],
      profileImageUrl: map['profileImageUrl'],
      role: CollaboratorRole.values.firstWhere(
        (r) => r.name == map['role'],
        orElse: () => CollaboratorRole.viewer,
      ),
      addedAt: DateTime.parse(map['addedAt']),
    );
  }

  /// Converts this [Collaborator] to JSON.
  Map<String, dynamic> toJson() => toMap();

  /// Creates a [Collaborator] from JSON.
  factory Collaborator.fromJson(Map<String, dynamic> json) =>
      Collaborator.fromMap(json);

  /// Creates a copy of this [Collaborator] with optional changes.
  ///
  /// Useful when you want to update a collaborator's name, role, or profile image.
  Collaborator copyWith({
    String? name,
    String? profileImageUrl,
    CollaboratorRole? role,
  }) {
    return Collaborator(
      userId: userId,
      email: email,
      name: name ?? this.name,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      role: role ?? this.role,
      addedAt: addedAt,
    );
  }
}

/// Collaborator permission levels for notes.
enum CollaboratorRole {
  /// Can only view the note.
  viewer,

  /// Can view and edit the note.
  editor,

  /// Can view, edit, and manage collaborators.
  admin,
}
