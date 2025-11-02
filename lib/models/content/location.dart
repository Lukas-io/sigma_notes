import 'content_model.dart';
import 'content_type.dart';

/// Represents a geolocation point.
class LocationContent extends ContentModel {
  final double latitude;
  final double longitude;
  final String? placeName;
  final String? address;

  LocationContent({
    super.id,
    required super.order,
    required this.latitude,
    required this.longitude,
    this.placeName,
    this.address,
    super.createdAt,
    super.updatedAt,
    super.createdBy,
    super.lastModifiedBy,
    super.isCollapsed,
    super.backgroundColor,
    super.indentLevel,
    super.parentBlockId,
    super.metadata,
  }) : super(type: ContentType.location);

  @override
  Map<String, dynamic> toJson() => {
    ...baseToJson(),
    'latitude': latitude,
    'longitude': longitude,
    'placeName': placeName,
    'address': address,
  };

  factory LocationContent.fromJson(Map<String, dynamic> json) =>
      LocationContent(
        id: json['id'],
        order: json['order'] ?? 0,
        latitude: json['latitude'] ?? 0.0,
        longitude: json['longitude'] ?? 0.0,
        placeName: json['placeName'],
        address: json['address'],
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
  String getSearchableText() => '${placeName ?? ''} ${address ?? ''}';

  LocationContent copyWith({
    double? latitude,
    double? longitude,
    String? placeName,
    String? address,
    int? order,
  }) {
    return LocationContent(
      id: id,
      order: order ?? this.order,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      placeName: placeName ?? this.placeName,
      address: address ?? this.address,
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
