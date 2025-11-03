import 'content_model.dart';

/// Defines available visual styles for a divider block.
enum DividerStyle {
  /// A single solid line divider (default).
  solid,

  /// A dashed line divider (--- --- ---).
  dashed,

  /// A dotted line divider (... ... ...).
  dotted,

  /// A double-line divider (═ ═ ═).
  doubleLine,

  /// A decorative divider with symbols or patterns (e.g., "***").
  decorative,

  /// A custom or experimental divider not in the standard list.
  custom,
}

/// Represents a divider block used to visually separate sections of content.
class DividerContent extends ContentModel {
  /// The visual style of the divider (e.g., solid, dashed, dotted).
  final DividerStyle style;

  DividerContent({
    super.id,
    required super.order,
    DividerStyle? style,
    super.createdAt,
    super.updatedAt,
    super.createdBy,
    super.lastModifiedBy,
    super.isCollapsed,
    super.backgroundColor,
    super.indentLevel,
    super.parentBlockId,
    super.metadata,
  }) : style = style ?? DividerStyle.solid,
       super(type: ContentType.divider);

  /// Converts this object into a JSON-compatible map.
  @override
  Map<String, dynamic> toJson() => {...baseToJson(), 'style': style.name};

  /// Creates an instance of [DividerContent] from a JSON map.
  factory DividerContent.fromJson(Map<String, dynamic> json) => DividerContent(
    id: json['id'],
    order: json['order'] ?? 0,
    style: _styleFromString(json['style']),
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
    metadata: (json['metadata'] as Map?)?.cast<String, dynamic>(),
  );

  /// Returns a copy of this [DividerContent] with optional changes.
  DividerContent copyWith({DividerStyle? style, int? order}) {
    return DividerContent(
      id: id,
      order: order ?? this.order,
      style: style ?? this.style,
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

  /// Converts a string safely into a [DividerStyle] enum value.
  static DividerStyle _styleFromString(dynamic value) {
    if (value == null) return DividerStyle.solid;
    return DividerStyle.values.firstWhere(
      (e) => e.name == value.toString(),
      orElse: () => DividerStyle.solid,
    );
  }

  @override
  String toString() =>
      'DividerContent(style: ${style.name}, order: $order, id: $id)';
}
