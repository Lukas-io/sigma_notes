import 'content_model.dart';
import 'content_type.dart';

/// Represents a timer or countdown block.
class TimerContent extends ContentModel {
  final Duration duration;
  final String? label;

  TimerContent({
    super.id,
    required super.order,
    required this.duration,
    this.label,
    super.createdAt,
    super.updatedAt,
    super.createdBy,
    super.lastModifiedBy,
    super.isCollapsed,
    super.backgroundColor,
    super.indentLevel,
    super.parentBlockId,
    super.metadata,
  }) : super(type: ContentType.timer);

  @override
  Map<String, dynamic> toJson() => {
    ...baseToJson(),
    'duration': duration.inMilliseconds,
    'label': label,
  };

  factory TimerContent.fromJson(Map<String, dynamic> json) => TimerContent(
    id: json['id'],
    order: json['order'] ?? 0,
    duration: Duration(milliseconds: json['duration'] ?? 0),
    label: json['label'],
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
  String getSearchableText() => label ?? '';

  TimerContent copyWith({Duration? duration, String? label, int? order}) {
    return TimerContent(
      id: id,
      order: order ?? this.order,
      duration: duration ?? this.duration,
      label: label ?? this.label,
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
