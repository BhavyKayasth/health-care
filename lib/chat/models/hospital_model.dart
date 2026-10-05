import 'doctor_model.dart';

class HospitalModel {
  final String id;
  final String name;
  final String specialty;
  final String distance;
  final double rating;
  final String phone;
  final String address;
  final double latitude;
  final double longitude;
  final List<DoctorModel> doctors;

  const HospitalModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.distance,
    required this.rating,
    required this.phone,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.doctors,
  });

  HospitalModel copyWith({
    String? id,
    String? name,
    String? specialty,
    String? distance,
    double? rating,
    String? phone,
    String? address,
    double? latitude,
    double? longitude,
    List<DoctorModel>? doctors,
  }) {
    return HospitalModel(
      id: id ?? this.id,
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      distance: distance ?? this.distance,
      rating: rating ?? this.rating,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      doctors: doctors ?? this.doctors,
    );
  }

  factory HospitalModel.fromJson(Map<String, dynamic> json) {
    return HospitalModel(
      id: json["id"]?.toString() ?? "",
      name: json["name"] ?? "",
      specialty: json["specialty"] ?? "",
      distance: json["distance"] ?? "",
      rating: (json["rating"] as num?)?.toDouble() ?? 0.0,
      phone: json["phone"] ?? "",
      address: json["address"] ?? "",
      latitude: (json["latitude"] as num?)?.toDouble() ?? 0.0,
      longitude: (json["longitude"] as num?)?.toDouble() ?? 0.0,
      doctors: (json["doctors"] as List<dynamic>?)
          ?.map((e) => DoctorModel.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "specialty": specialty,
      "distance": distance,
      "rating": rating,
      "phone": phone,
      "address": address,
      "latitude": latitude,
      "longitude": longitude,
      "doctors": doctors.map((e) => e.toJson()).toList(),
    };
  }
}