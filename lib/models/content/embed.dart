import 'content_model.dart';
import 'content_type.dart';

/// Represents an embedded resource.
class EmbedContent extends ContentModel {
  final String url;
  final String? title;
  final String? description;
  final String? thumbnailUrl;

  EmbedContent({
    super.id,
    required super.order,
    required this.url,
    this.title,
    this.description,
    this.thumbnailUrl,
    super.createdAt,
    super.updatedAt,
    super.createdBy,
    super.lastModifiedBy,
    super.isCollapsed,
    super.backgroundColor,
    super.indentLevel,
    super.parentBlockId,
    super.metadata,
  }) : super(type: ContentType.embed);

  @override
  Map<String, dynamic> toJson() => {
    ...baseToJson(),
    'url': url,
    'title': title,
    'description': description,
    'thumbnailUrl': thumbnailUrl,
  };

  factory EmbedContent.fromJson(Map<String, dynamic> json) => EmbedContent(
    id: json['id'],
    order: json['order'] ?? 0,
    url: json['url'] ?? '',
    title: json['title'],
    description: json['description'],
    thumbnailUrl: json['thumbnailUrl'],
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
  bool validate() => url.isNotEmpty && Uri.tryParse(url) != null;

  @override
  String getSearchableText() => '${title ?? ''} ${description ?? ''}';

  EmbedContent copyWith({
    String? url,
    String? title,
    String? description,
    int? order,
  }) {
    return EmbedContent(
      id: id,
      order: order ?? this.order,
      url: url ?? this.url,
      title: title ?? this.title,
      description: description ?? this.description,
      thumbnailUrl: thumbnailUrl,
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
