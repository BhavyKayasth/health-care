class AppointmentModel {
  final String doctor;
  final String specialty;
  final String time;
  final String type;

  const AppointmentModel({
    required this.doctor,
    required this.specialty,
    required this.time,
    required this.type,
  });
}

const List<AppointmentModel> appointments = [
  AppointmentModel(
    doctor: "Dr. Sarah Johnson",
    specialty: "General Physician",
    time: "Today, 2:30 PM",
    type: "Video Consultation",
  ),
  AppointmentModel(
    doctor: "Dr. Michael Chen",
    specialty: "Cardiologist",
    time: "Tomorrow, 10:00 AM",
    type: "In-Person",
  ),
];