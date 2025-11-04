import 'package:uuid/uuid.dart';

import 'content_model.dart';

/// Text styling options
enum TextStyleType {
  h1,
  h2,
  h3,
  h4,
  paragraph,
  bullet,
  numbered,
  quote,
  callout,
}

/// Represents a simple text block with rich formatting support.
class TextContent extends ContentModel {
  /// The text content itself.
  final String text;

  /// Text style (heading, paragraph, etc.)
  final TextStyleType style;

  /// Rich text formatting map
  /// Example: {'bold': [[0, 5], [10, 15]], 'italic': [[3, 8]], 'color': '#FF0000'}
  final Map<String, dynamic>? formatting;

  TextContent({
    super.id,
    required super.order,
    required this.text,
    this.style = TextStyleType.paragraph,
    this.formatting,
    super.createdAt,
    super.updatedAt,
    super.createdBy,
    super.lastModifiedBy,
    super.isCollapsed,
    super.backgroundColor,
    super.indentLevel,
    super.parentBlockId,
    super.metadata,
  }) : super(type: ContentType.text);

  @override
  Map<String, dynamic> toJson() => {
    ...baseToJson(),
    'text': text,
    'style': style.name,
    'formatting': formatting,
  };

  factory TextContent.fromJson(Map<String, dynamic> json) => TextContent(
    id: json['id'],
    order: json['order'] ?? 0,
    text: json['text'] ?? '',
    style: TextStyleType.values.firstWhere(
      (e) => e.name == json['style'],
      orElse: () => TextStyleType.paragraph,
    ),
    formatting: json['formatting'],
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
    metadata: json['metadata'],
  );

  @override
  String getSearchableText() => text;

  /// Returns a new [TextContent] with updated fields.
  TextContent copyWith({
    String? text,
    TextStyleType? style,
    Map<String, dynamic>? formatting,
    int? order,
    DateTime? updatedAt,
    bool? isCollapsed,
    String? backgroundColor,
    int? indentLevel,
    String? parentBlockId,
    Map<String, dynamic>? metadata,
  }) {
    return TextContent(
      id: id,
      order: order ?? this.order,
      text: text ?? this.text,
      style: style ?? this.style,
      formatting: formatting ?? this.formatting,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      createdBy: createdBy,
      lastModifiedBy: lastModifiedBy,
      isCollapsed: isCollapsed ?? this.isCollapsed,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      indentLevel: indentLevel ?? this.indentLevel,
      parentBlockId: parentBlockId ?? this.parentBlockId,
      metadata: metadata ?? this.metadata,
    );
  }

  /// 🧠 Converts this [TextContent] into a [ChecklistContent].
  /// Each line of text (`\n`) becomes a [ChecklistItem].
  ChecklistContent copyAsChecklist(String? id) {
    final uuid = const Uuid();

    // Split text into lines, ignore empty ones
    final lines = text
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    final items = lines
        .map((line) => ChecklistItem(id: id ?? uuid.v4(), text: line))
        .toList();

    return ChecklistContent(
      id: id,
      order: order,
      items: items,
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
}
