class DoctorModel {
  final String name;
  final String specialty;
  final bool available;

  const DoctorModel({
    required this.name,
    required this.specialty,
    required this.available,
  });

  DoctorModel copyWith({
    String? name,
    String? specialty,
    bool? available,
  }) {
    return DoctorModel(
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      available: available ?? this.available,
    );
  }

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      name: json["name"] ?? "",
      specialty: json["specialty"] ?? "",
      available: json["available"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "specialty": specialty,
      "available": available,
    };
  }
}