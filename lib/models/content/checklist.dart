import 'package:uuid/uuid.dart';

import 'content_model.dart';

/// Represents a checklist block with multiple items.
class ChecklistContent extends ContentModel {
  /// List of checklist items.
  final List<ChecklistItem> items;

  ChecklistContent({
    super.id,
    required super.order,
    required this.items,
    super.createdAt,
    super.updatedAt,
    super.createdBy,
    super.lastModifiedBy,
    super.isCollapsed,
    super.backgroundColor,
    super.indentLevel,
    super.parentBlockId,
    super.metadata,
  }) : super(type: ContentType.checklist);

  /// Calculate completion percentage
  double get completionPercentage {
    if (items.isEmpty) return 0;
    final checked = items.where((i) => i.checked).length;
    return checked / items.length;
  }

  @override
  Map<String, dynamic> toJson() => {
    ...baseToJson(),
    'items': items.map((e) => e.toJson()).toList(),
  };

  factory ChecklistContent.fromJson(Map<String, dynamic> json) =>
      ChecklistContent(
        id: json['id'],
        order: json['order'] ?? 0,
        items: (json['items'] as List<dynamic>? ?? [])
            .map((e) => ChecklistItem.fromJson(e))
            .toList(),
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

  ChecklistContent copyWith({
    List<ChecklistItem>? items,
    int? order,
    bool? isCollapsed,
  }) {
    return ChecklistContent(
      id: id,
      order: order ?? this.order,
      items: items ?? this.items,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      createdBy: createdBy,
      lastModifiedBy: lastModifiedBy,
      isCollapsed: isCollapsed ?? this.isCollapsed,
      backgroundColor: backgroundColor,
      indentLevel: indentLevel,
      parentBlockId: parentBlockId,
      metadata: metadata,
    );
  }

  @override
  String getSearchableText() => items.map((i) => i.text).join(' ');
}

/// Represents a single checklist item.
class ChecklistItem {
  final String id;
  final String text;
  final bool checked;

  ChecklistItem({String? id, required this.text, this.checked = false})
    : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {'id': id, 'text': text, 'checked': checked};

  factory ChecklistItem.fromJson(Map<String, dynamic> json) => ChecklistItem(
    id: json['id'],
    text: json['text'] ?? '',
    checked: json['checked'] ?? false,
  );

  ChecklistItem copyWith({String? text, bool? checked}) {
    return ChecklistItem(
      id: id,
      text: text ?? this.text,
      checked: checked ?? this.checked,
    );
  }
}
