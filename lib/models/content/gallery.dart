import 'content_model.dart';
import 'content_type.dart';

/// Represents a gallery of multiple images.
class GalleryContent extends ContentModel {
  final List<String> imageUrls;
  final String? caption;

  GalleryContent({
    super.id,
    required super.order,
    required this.imageUrls,
    this.caption,
    super.createdAt,
    super.updatedAt,
    super.createdBy,
    super.lastModifiedBy,
    super.isCollapsed,
    super.backgroundColor,
    super.indentLevel,
    super.parentBlockId,
    super.metadata,
  }) : super(type: ContentType.gallery);

  @override
  Map<String, dynamic> toJson() => {
    ...baseToJson(),
    'imageUrls': imageUrls,
    'caption': caption,
  };

  factory GalleryContent.fromJson(Map<String, dynamic> json) => GalleryContent(
    id: json['id'],
    order: json['order'] ?? 0,
    imageUrls: (json['imageUrls'] as List<dynamic>? ?? []).cast<String>(),
    caption: json['caption'],
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
  String getSearchableText() => caption ?? '';

  GalleryContent copyWith({
    List<String>? imageUrls,
    String? caption,
    int? order,
  }) {
    return GalleryContent(
      id: id,
      order: order ?? this.order,
      imageUrls: imageUrls ?? this.imageUrls,
      caption: caption ?? this.caption,
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
