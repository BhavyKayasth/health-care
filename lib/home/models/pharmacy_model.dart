// lib/home/models/pharmacy_model.dart

class PharmacyModel {
  final String id;
  final String name;
  final String distance;
  final String rating;
  final String phone;
  final double latitude;
  final double longitude;

  const PharmacyModel({
    required this.id,
    required this.name,
    required this.distance,
    required this.rating,
    required this.phone,
    required this.latitude,
    required this.longitude,
  });
}