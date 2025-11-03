/// Represents someone who has access to a note
class Collaborator {
  final String userId;
  final String email;
  final String? name;
  final CollaboratorRole role;
  final DateTime addedAt;

  Collaborator({
    required this.userId,
    required this.email,
    this.name,
    this.role = CollaboratorRole.viewer,
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'email': email,
      'name': name,
      'role': role.name,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  factory Collaborator.fromMap(Map<String, dynamic> map) {
    return Collaborator(
      userId: map['userId'],
      email: map['email'],
      name: map['name'],
      role: CollaboratorRole.values.firstWhere(
        (r) => r.name == map['role'],
        orElse: () => CollaboratorRole.viewer,
      ),
      addedAt: DateTime.parse(map['addedAt']),
    );
  }

  Collaborator copyWith({String? name, CollaboratorRole? role}) {
    return Collaborator(
      userId: userId,
      email: email,
      name: name ?? this.name,
      role: role ?? this.role,
      addedAt: addedAt,
    );
  }
}

/// Collaborator permission levels
enum CollaboratorRole {
  viewer, // Can only view
  editor, // Can view and edit
  admin, // Can view, edit, and manage collaborators
}
