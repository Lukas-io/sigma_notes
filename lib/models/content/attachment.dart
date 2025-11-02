import 'package:uuid/uuid.dart';
import 'content_model.dart';
import 'content_type.dart';

/// Defines broad categories of MIME types for attachments.
enum MimeTypeCategory { image, video, audio, document, archive, other }

/// Represents an attached file such as an image, video, audio, or document.
class AttachmentContent extends ContentModel {
  /// The human-readable name of the file.
  final String name;

  /// The URL where the file is stored or can be accessed.
  final String url;

  /// The size of the file in bytes.
  final int? size;

  /// The MIME category of the file (e.g., image, video, document).
  final MimeTypeCategory mimeType;

  AttachmentContent({
    String? id,
    required super.order,
    required this.name,
    required this.url,
    this.size,
    MimeTypeCategory? mimeType,
    super.createdAt,
    super.updatedAt,
    super.createdBy,
    super.lastModifiedBy,
    super.isCollapsed,
    super.backgroundColor,
    super.indentLevel,
    super.parentBlockId,
    super.metadata,
  }) : mimeType = mimeType ?? _detectMimeType(name, url),
       super(id: id ?? const Uuid().v4(), type: ContentType.attachment);

  /// Converts this object into a JSON-compatible map.
  @override
  Map<String, dynamic> toJson() => {
    ...baseToJson(),
    'name': name,
    'url': url,
    'size': size,
    'mimeType': mimeType.name,
  };

  /// Creates an instance of [AttachmentContent] from a JSON map.
  factory AttachmentContent.fromJson(Map<String, dynamic> json) {
    return AttachmentContent(
      id: json['id'],
      order: json['order'] ?? 0,
      name: json['name'] ?? '',
      url: json['url'] ?? '',
      size: json['size'],
      mimeType: _mimeTypeFromString(json['mimeType']),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      createdBy: json['createdBy'],
      lastModifiedBy: json['lastModifiedBy'],
      isCollapsed: json['isCollapsed'] ?? false,
      backgroundColor: json['backgroundColor'],
      indentLevel: json['indentLevel'] ?? 0,
      parentBlockId: json['parentBlockId'],
      metadata: (json['metadata'] as Map?)?.cast<String, dynamic>(),
    );
  }

  /// Returns a human-readable string representation for debugging.
  @override
  String toString() =>
      'AttachmentContent(name: $name, url: $url, size: $size, mimeType: ${mimeType.name})';

  /// Detects the [MimeTypeCategory] based on the file name or URL.
  static MimeTypeCategory _detectMimeType(String name, String url) {
    final lower = (name + url).toLowerCase();

    if (lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png') ||
        lower.endsWith('.gif') ||
        lower.endsWith('.webp') ||
        lower.endsWith('.svg')) {
      return MimeTypeCategory.image;
    } else if (lower.endsWith('.mp4') ||
        lower.endsWith('.mov') ||
        lower.endsWith('.avi') ||
        lower.endsWith('.mkv')) {
      return MimeTypeCategory.video;
    } else if (lower.endsWith('.mp3') ||
        lower.endsWith('.wav') ||
        lower.endsWith('.aac') ||
        lower.endsWith('.flac')) {
      return MimeTypeCategory.audio;
    } else if (lower.endsWith('.pdf') ||
        lower.endsWith('.doc') ||
        lower.endsWith('.docx') ||
        lower.endsWith('.txt') ||
        lower.endsWith('.ppt') ||
        lower.endsWith('.pptx') ||
        lower.endsWith('.xls') ||
        lower.endsWith('.xlsx')) {
      return MimeTypeCategory.document;
    } else if (lower.endsWith('.zip') ||
        lower.endsWith('.rar') ||
        lower.endsWith('.7z') ||
        lower.endsWith('.tar') ||
        lower.endsWith('.gz')) {
      return MimeTypeCategory.archive;
    } else {
      return MimeTypeCategory.other;
    }
  }

  /// Safely converts a string back into a [MimeTypeCategory] enum value.
  static MimeTypeCategory _mimeTypeFromString(dynamic value) {
    if (value == null) return MimeTypeCategory.other;
    return MimeTypeCategory.values.firstWhere(
      (e) => e.name == value.toString(),
      orElse: () => MimeTypeCategory.other,
    );
  }
}
