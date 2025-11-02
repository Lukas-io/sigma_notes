import 'package:uuid/uuid.dart';

import 'audio.dart';
import 'checklist.dart';
import 'code.dart';
import 'content_type.dart';
import 'divider.dart';
import 'drawing.dart';
import 'embed.dart';
import 'gallery.dart';
import 'image.dart';
import 'link.dart';
import 'location.dart';
import 'quote.dart';
import 'table.dart';
import 'tag.dart';
import 'text.dart';
import 'timer.dart';
import 'video.dart';
import 'attachment.dart';

/// The base type for all content blocks that can appear in a note.
///
/// Each block (text, image, audio, checklist, etc.) extends [ContentModel]
/// and represents a structured piece of note data. This allows for a highly
/// flexible note system similar to Notion or Craft Docs.
abstract class ContentModel {
  /// Unique identifier for this block
  final String id;

  /// The content type that identifies the specific subclass.
  final ContentType type;

  /// The order/position of this block in the note
  final int order;

  /// The creation timestamp of the block.
  final DateTime createdAt;

  /// The last time the block was modified.
  final DateTime? updatedAt;

  /// User ID who created this block (for collaboration)
  final String? createdBy;

  /// User ID who last modified this block
  final String? lastModifiedBy;

  /// Whether the block is collapsed/hidden
  final bool isCollapsed;

  /// Background color for the block
  final String? backgroundColor;

  /// Indentation level for hierarchical content (0 = no indent)
  final int indentLevel;

  /// Parent block ID for nested content
  final String? parentBlockId;

  /// Additional flexible metadata
  final Map<String, dynamic>? metadata;

  ContentModel({
    String? id,
    required this.type,
    required this.order,
    DateTime? createdAt,
    this.updatedAt,
    this.createdBy,
    this.lastModifiedBy,
    this.isCollapsed = false,
    this.backgroundColor,
    this.indentLevel = 0,
    this.parentBlockId,
    this.metadata,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  /// Converts the model to JSON for serialization.
  Map<String, dynamic> toJson();

  /// Validates the block data
  bool validate() => true;

  /// Extracts searchable text from the block
  String getSearchableText() => '';

  /// Factory constructor that maps `type` from JSON and reconstructs
  /// the appropriate subclass.
  static ContentModel fromJson(Map<String, dynamic> json) {
    final typeString = json['type'] as String;
    final type = ContentType.values.firstWhere(
      (e) => e.toString().split('.').last == typeString,
      orElse: () => ContentType.text,
    );

    switch (type) {
      case ContentType.text:
        return TextContent.fromJson(json);
      case ContentType.checklist:
        return ChecklistContent.fromJson(json);
      case ContentType.image:
        return ImageContent.fromJson(json);
      case ContentType.audio:
        return AudioContent.fromJson(json);
      case ContentType.video:
        return VideoContent.fromJson(json);
      case ContentType.drawing:
        return DrawingContent.fromJson(json);
      case ContentType.quote:
        return QuoteContent.fromJson(json);
      case ContentType.divider:
        return DividerContent.fromJson(json);
      case ContentType.attachment:
        return AttachmentContent.fromJson(json);
      case ContentType.code:
        return CodeContent.fromJson(json);
      case ContentType.embed:
        return EmbedContent.fromJson(json);
      case ContentType.table:
        return TableContent.fromJson(json);
      case ContentType.tag:
        return TagContent.fromJson(json);
      case ContentType.gallery:
        return GalleryContent.fromJson(json);
      case ContentType.location:
        return LocationContent.fromJson(json);
      case ContentType.timer:
        return TimerContent.fromJson(json);
      case ContentType.link:
        return LinkContent.fromJson(json);
    }
  }

  /// Base toJson that includes common fields
  Map<String, dynamic> baseToJson() => {
    'id': id,
    'type': type.name,
    'order': order,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    'createdBy': createdBy,
    'lastModifiedBy': lastModifiedBy,
    'isCollapsed': isCollapsed,
    'backgroundColor': backgroundColor,
    'indentLevel': indentLevel,
    'parentBlockId': parentBlockId,
    'metadata': metadata,
  };
}
