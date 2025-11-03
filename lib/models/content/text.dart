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

  AttachmentContent copyWith({String? name, String? url, int? order}) {
    return AttachmentContent(
      id: id,
      order: order ?? this.order,
      name: name ?? text,
      url: url ?? id,
      size: text.length,
      mimeType: MimeTypeCategory.document,
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
