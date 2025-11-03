import 'content_model.dart';

/// Represents a video content block.
class VideoContent extends ContentModel {
  final String url;
  final String? thumbnail;
  final Duration? duration;
  final int? fileSizeBytes;

  VideoContent({
    super.id,
    required super.order,
    required this.url,
    this.thumbnail,
    this.duration,
    this.fileSizeBytes,
    super.createdAt,
    super.updatedAt,
    super.createdBy,
    super.lastModifiedBy,
    super.isCollapsed,
    super.backgroundColor,
    super.indentLevel,
    super.parentBlockId,
    super.metadata,
  }) : super(type: ContentType.video);

  bool get isWithinLimit =>
      fileSizeBytes == null || fileSizeBytes! < 100 * 1024 * 1024; // 100MB

  @override
  Map<String, dynamic> toJson() => {
    ...baseToJson(),
    'url': url,
    'thumbnail': thumbnail,
    'duration': duration?.inMilliseconds,
    'fileSizeBytes': fileSizeBytes,
  };

  factory VideoContent.fromJson(Map<String, dynamic> json) => VideoContent(
    id: json['id'],
    order: json['order'] ?? 0,
    url: json['url'] ?? '',
    thumbnail: json['thumbnail'],
    duration: json['duration'] != null
        ? Duration(milliseconds: json['duration'])
        : null,
    fileSizeBytes: json['fileSizeBytes'],
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
  bool validate() => url.isNotEmpty && isWithinLimit;

  VideoContent copyWith({String? url, String? thumbnail, int? order}) {
    return VideoContent(
      id: id,
      order: order ?? this.order,
      url: url ?? this.url,
      thumbnail: thumbnail ?? this.thumbnail,
      duration: duration,
      fileSizeBytes: fileSizeBytes,
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
