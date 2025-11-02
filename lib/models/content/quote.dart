import 'content_model.dart';
import 'content_type.dart';

/// Represents a quote or citation block.
class QuoteContent extends ContentModel {
  final String text;
  final String? author;

  QuoteContent({
    super.id,
    required super.order,
    required this.text,
    this.author,
    super.createdAt,
    super.updatedAt,
    super.createdBy,
    super.lastModifiedBy,
    super.isCollapsed,
    super.backgroundColor,
    super.indentLevel,
    super.parentBlockId,
    super.metadata,
  }) : super(type: ContentType.quote);

  @override
  Map<String, dynamic> toJson() => {
    ...baseToJson(),
    'text': text,
    'author': author,
  };

  factory QuoteContent.fromJson(Map<String, dynamic> json) => QuoteContent(
    id: json['id'],
    order: json['order'] ?? 0,
    text: json['text'] ?? '',
    author: json['author'],
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
  String getSearchableText() => '$text ${author ?? ''}';

  QuoteContent copyWith({String? text, String? author, int? order}) {
    return QuoteContent(
      id: id,
      order: order ?? this.order,
      text: text ?? this.text,
      author: author ?? this.author,
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
