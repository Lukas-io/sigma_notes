import 'content_model.dart';
import 'content_type.dart';

/// Represents a drawing or sketch block.
class DrawingContent extends ContentModel {
  final String drawingData;

  DrawingContent({
    super.id,
    required super.order,
    required this.drawingData,
    super.createdAt,
    super.updatedAt,
    super.createdBy,
    super.lastModifiedBy,
    super.isCollapsed,
    super.backgroundColor,
    super.indentLevel,
    super.parentBlockId,
    super.metadata,
  }) : super(type: ContentType.drawing);

  @override
  Map<String, dynamic> toJson() => {
    ...baseToJson(),
    'drawingData': drawingData,
  };

  factory DrawingContent.fromJson(Map<String, dynamic> json) => DrawingContent(
    id: json['id'],
    order: json['order'] ?? 0,
    drawingData: json['drawingData'] ?? '',
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

  DrawingContent copyWith({String? drawingData, int? order}) {
    return DrawingContent(
      id: id,
      order: order ?? this.order,
      drawingData: drawingData ?? this.drawingData,
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
