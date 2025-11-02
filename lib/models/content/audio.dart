import 'content_model.dart';
import 'content_type.dart';

/// Represents an audio recording or file.
class AudioContent extends ContentModel {
  final String url;
  final Duration? duration;
  final int? fileSizeBytes;

  AudioContent({
    super.id,
    required super.order,
    required this.url,
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
  }) : super(type: ContentType.audio);

  /// Check if file size is within 50MB limit
  bool get isWithinLimit =>
      fileSizeBytes == null || fileSizeBytes! < 50 * 1024 * 1024;

  @override
  Map<String, dynamic> toJson() => {
    ...baseToJson(),
    'url': url,
    'duration': duration?.inMilliseconds,
    'fileSizeBytes': fileSizeBytes,
  };

  factory AudioContent.fromJson(Map<String, dynamic> json) => AudioContent(
    id: json['id'],
    order: json['order'] ?? 0,
    url: json['url'] ?? '',
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

  AudioContent copyWith({String? url, Duration? duration, int? order}) {
    return AudioContent(
      id: id,
      order: order ?? this.order,
      url: url ?? this.url,
      duration: duration ?? this.duration,
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
