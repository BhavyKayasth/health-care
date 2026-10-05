class AreaModel {
  final String id;
  final String cityId;
  final String name;
  final double latitude;
  final double longitude;

  const AreaModel({
    required this.id,
    required this.cityId,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  AreaModel copyWith({
    String? id,
    String? cityId,
    String? name,
    double? latitude,
    double? longitude,
  }) {
    return AreaModel(
      id: id ?? this.id,
      cityId: cityId ?? this.cityId,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}