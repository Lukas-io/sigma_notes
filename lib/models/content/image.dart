import 'content_model.dart';
import 'content_type.dart';

/// Represents an image block with optional caption.
class ImageContent extends ContentModel {
  final String url;
  final String? caption;
  final int? width;
  final int? height;

  ImageContent({
    super.id,
    required super.order,
    required this.url,
    this.caption,
    this.width,
    this.height,
    super.createdAt,
    super.updatedAt,
    super.createdBy,
    super.lastModifiedBy,
    super.isCollapsed,
    super.backgroundColor,
    super.indentLevel,
    super.parentBlockId,
    super.metadata,
  }) : super(type: ContentType.image);

  @override
  Map<String, dynamic> toJson() => {
    ...baseToJson(),
    'url': url,
    'caption': caption,
    'width': width,
    'height': height,
  };

  factory ImageContent.fromJson(Map<String, dynamic> json) => ImageContent(
    id: json['id'],
    order: json['order'] ?? 0,
    url: json['url'] ?? '',
    caption: json['caption'],
    width: json['width'],
    height: json['height'],
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
  String getSearchableText() => caption ?? '';

  ImageContent copyWith({String? url, String? caption, int? order}) {
    return ImageContent(
      id: id,
      order: order ?? this.order,
      url: url ?? this.url,
      caption: caption ?? this.caption,
      width: width,
      height: height,
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
