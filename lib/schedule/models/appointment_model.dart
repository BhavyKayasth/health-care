class AppointmentModel {
  final String id;
  final String doctor;
  final String specialty;
  final String avatar;
  final DateTime dateTime;
  final String type; // Video Consultation / Hospital Visit
  final bool completed;

  const AppointmentModel({
    required this.id,
    required this.doctor,
    required this.specialty,
    required this.avatar,
    required this.dateTime,
    required this.type,
    required this.completed,
  });

  //==========================================================
  // COPY WITH
  //==========================================================

  AppointmentModel copyWith({
    String? id,
    String? doctor,
    String? specialty,
    String? avatar,
    DateTime? dateTime,
    String? type,
    bool? completed,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      doctor: doctor ?? this.doctor,
      specialty: specialty ?? this.specialty,
      avatar: avatar ?? this.avatar,
      dateTime: dateTime ?? this.dateTime,
      type: type ?? this.type,
      completed: completed ?? this.completed,
    );
  }

  //==========================================================
  // DATE
  //==========================================================

  String get date {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];

    return "${dateTime.day} ${months[dateTime.month - 1]}";
  }

  //==========================================================
  // TIME
  //==========================================================

  String get time {
    int hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, "0");

    final period = hour >= 12 ? "PM" : "AM";

    if (hour > 12) hour -= 12;
    if (hour == 0) hour = 12;

    return "$hour:$minute $period";
  }

  //==========================================================
  // HELPERS
  //==========================================================

  bool get isVideo => type == "Video Consultation";

  bool get isHospitalVisit => type == "Hospital Visit";

  bool get isUpcoming =>
      !completed && dateTime.isAfter(DateTime.now());

  bool get isPast =>
      completed || dateTime.isBefore(DateTime.now());

  String get doctorInitial =>
      doctor.isNotEmpty ? doctor[0].toUpperCase() : "D";
}