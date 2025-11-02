import 'content_model.dart';
import 'content_type.dart';

/// Represents a tag or label.
class TagContent extends ContentModel {
  final String tag;
  final String? color;

  TagContent({
    super.id,
    required super.order,
    required this.tag,
    this.color,
    super.createdAt,
    super.updatedAt,
    super.createdBy,
    super.lastModifiedBy,
    super.isCollapsed,
    super.backgroundColor,
    super.indentLevel,
    super.parentBlockId,
    super.metadata,
  }) : super(type: ContentType.tag);

  @override
  Map<String, dynamic> toJson() => {
    ...baseToJson(),
    'tag': tag,
    'color': color,
  };

  factory TagContent.fromJson(Map<String, dynamic> json) => TagContent(
    id: json['id'],
    order: json['order'] ?? 0,
    tag: json['tag'] ?? '',
    color: json['color'],
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
  String getSearchableText() => tag;

  TagContent copyWith({String? tag, String? color, int? order}) {
    return TagContent(
      id: id,
      order: order ?? this.order,
      tag: tag ?? this.tag,
      color: color ?? this.color,
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
