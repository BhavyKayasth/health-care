class NearbyHospitalModel {
  final String id;
  final String name;

  final String address;
  final String phone;

  final double latitude;
  final double longitude;

  final double? rating;
  final double? distanceKm;

  final bool? emergency;
  final int? availableDoctors;

  final List<String> specialties;

  final String image;

  const NearbyHospitalModel({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.latitude,
    required this.longitude,
    this.rating,
    this.distanceKm,
    this.emergency,
    this.availableDoctors,
    this.specialties = const [],
    this.image = '',
  });

  //----------------------------------------------------------
  // COPY WITH
  //----------------------------------------------------------

  NearbyHospitalModel copyWith({
    String? id,
    String? name,
    String? address,
    String? phone,
    double? latitude,
    double? longitude,
    double? rating,
    double? distanceKm,
    bool? emergency,
    int? availableDoctors,
    List<String>? specialties,
    String? image,
  }) {
    return NearbyHospitalModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      rating: rating ?? this.rating,
      distanceKm: distanceKm ?? this.distanceKm,
      emergency: emergency ?? this.emergency,
      availableDoctors:
      availableDoctors ?? this.availableDoctors,
      specialties: specialties ?? this.specialties,
      image: image ?? this.image,
    );
  }
}