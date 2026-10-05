class CityModel {
  final String id;
  final String name;
  final double latitude;
  final double longitude;

  const CityModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  CityModel copyWith({
    String? id,
    String? name,
    double? latitude,
    double? longitude,
  }) {
    return CityModel(
      id: id ?? this.id,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}