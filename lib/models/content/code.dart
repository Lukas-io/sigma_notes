import 'content_model.dart';
import 'content_type.dart';

/// Represents a code snippet block.
class CodeContent extends ContentModel {
  final String code;
  final String language;

  CodeContent({
    super.id,
    required super.order,
    required this.code,
    this.language = 'plaintext',
    super.createdAt,
    super.updatedAt,
    super.createdBy,
    super.lastModifiedBy,
    super.isCollapsed,
    super.backgroundColor,
    super.indentLevel,
    super.parentBlockId,
    super.metadata,
  }) : super(type: ContentType.code);

  @override
  Map<String, dynamic> toJson() => {
    ...baseToJson(),
    'code': code,
    'language': language,
  };

  factory CodeContent.fromJson(Map<String, dynamic> json) => CodeContent(
    id: json['id'],
    order: json['order'] ?? 0,
    code: json['code'] ?? '',
    language: json['language'] ?? 'plaintext',
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
  String getSearchableText() => code;

  CodeContent copyWith({String? code, String? language, int? order}) {
    return CodeContent(
      id: id,
      order: order ?? this.order,
      code: code ?? this.code,
      language: language ?? this.language,
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
