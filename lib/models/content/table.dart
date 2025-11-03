import 'content_model.dart';

/// Represents a simple table.
class TableContent extends ContentModel {
  final List<List<String>> rows;
  final bool hasHeader;

  TableContent({
    super.id,
    required super.order,
    required this.rows,
    this.hasHeader = true,
    super.createdAt,
    super.updatedAt,
    super.createdBy,
    super.lastModifiedBy,
    super.isCollapsed,
    super.backgroundColor,
    super.indentLevel,
    super.parentBlockId,
    super.metadata,
  }) : super(type: ContentType.table);

  @override
  Map<String, dynamic> toJson() => {
    ...baseToJson(),
    'rows': rows,
    'hasHeader': hasHeader,
  };

  factory TableContent.fromJson(Map<String, dynamic> json) => TableContent(
    id: json['id'],
    order: json['order'] ?? 0,
    rows: (json['rows'] as List<dynamic>? ?? [])
        .map((r) => (r as List<dynamic>).cast<String>())
        .toList(),
    hasHeader: json['hasHeader'] ?? true,
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
  String getSearchableText() => rows.expand((row) => row).join(' ');

  TableContent copyWith({
    List<List<String>>? rows,
    bool? hasHeader,
    int? order,
  }) {
    return TableContent(
      id: id,
      order: order ?? this.order,
      rows: rows ?? this.rows,
      hasHeader: hasHeader ?? this.hasHeader,
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
