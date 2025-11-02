import 'content_model.dart';
import 'content_type.dart';

/// Represents a link to another note or a specific block within a note.
class LinkContent extends ContentModel {
  /// The ID of the note this link points to.
  final String targetNoteId;

  /// The optional ID of the specific block within the note.
  final String? targetBlockId;

  /// The text displayed for the link.
  final String displayText;

  /// Creates a [LinkContent] instance.
  LinkContent({
    super.id,
    required super.order,
    required this.targetNoteId,
    this.targetBlockId,
    required this.displayText,
    super.createdAt,
    super.updatedAt,
    super.createdBy,
    super.lastModifiedBy,
    super.isCollapsed,
    super.backgroundColor,
    super.indentLevel,
    super.parentBlockId,
    super.metadata,
  }) : super(type: ContentType.link);

  /// Converts this object into a JSON-compatible map.
  @override
  Map<String, dynamic> toJson() => {
    ...baseToJson(),
    'targetNoteId': targetNoteId,
    'targetBlockId': targetBlockId,
    'displayText': displayText,
  };

  /// Creates an instance of [LinkContent] from a JSON map.
  factory LinkContent.fromJson(Map<String, dynamic> json) => LinkContent(
    id: json['id'],
    order: json['order'] ?? 0,
    targetNoteId: json['targetNoteId'] ?? '',
    targetBlockId: json['targetBlockId'],
    displayText: json['displayText'] ?? '',
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : null,
    updatedAt: json['updatedAt'] != null
        ? DateTime.parse(json['updatedAt'])
        : null,
    createdBy: json['createdBy'],
    lastModifiedBy: json['lastModifiedBy'],
    isCollapsed: json['isCollapsed'] ?? false,
    backgroundColor: json['backgroundColor'],
    indentLevel: json['indentLevel'] ?? 0,
    parentBlockId: json['parentBlockId'],
    metadata: (json['metadata'] as Map?)?.cast<String, dynamic>(),
  );

  /// Returns the text that should be searchable for this content block.
  @override
  String getSearchableText() => displayText;

  /// Returns a copy of this [LinkContent] with optional updated fields.
  LinkContent copyWith({
    String? targetNoteId,
    String? targetBlockId,
    String? displayText,
    int? order,
  }) {
    return LinkContent(
      id: id,
      order: order ?? this.order,
      targetNoteId: targetNoteId ?? this.targetNoteId,
      targetBlockId: targetBlockId ?? this.targetBlockId,
      displayText: displayText ?? this.displayText,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      createdBy: createdBy,
      lastModifiedBy: lastModifiedBy,
      isCollapsed: isCollapsed,
      backgroundColor: backgroundColor,
      indentLevel: indentLevel,
      parentBlockId: parentBlockId,
      metadata: metadata,
    );
  }

  @override
  String toString() =>
      'LinkContent(targetNoteId: $targetNoteId, targetBlockId: $targetBlockId, displayText: $displayText, order: $order, id: $id)';
}
