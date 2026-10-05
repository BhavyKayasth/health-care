import '../models/appointment_model.dart';

class ScheduleState {
  final bool isLoading;
  final bool isBooking;
  final DateTime selectedDate;
  final List<AppointmentModel> appointments;

  const ScheduleState({
    required this.isLoading,
    required this.isBooking,
    required this.selectedDate,
    required this.appointments,
  });

  /// Initial State
  factory ScheduleState.initial() {
    return ScheduleState(
      isLoading: false,
      isBooking: false,
      selectedDate: DateTime.now(),
      appointments: const [],
    );
  }

  /// CopyWith
  ScheduleState copyWith({
    bool? isLoading,
    bool? isBooking,
    DateTime? selectedDate,
    List<AppointmentModel>? appointments,
  }) {
    return ScheduleState(
      isLoading: isLoading ?? this.isLoading,
      isBooking: isBooking ?? this.isBooking,
      selectedDate: selectedDate ?? this.selectedDate,
      appointments: appointments ?? this.appointments,
    );
  }

  //==========================================================
  // COMPUTED GETTERS
  //==========================================================

  /// Upcoming appointments
  List<AppointmentModel> get upcomingAppointments {
    return appointments.where((appointment) {
      return appointment.isUpcoming;
    }).toList()
      ..sort(
            (a, b) => a.dateTime.compareTo(b.dateTime),
      );
  }

  /// Past appointments
  List<AppointmentModel> get pastAppointments {
    return appointments.where((appointment) {
      return !appointment.isUpcoming;
    }).toList()
      ..sort(
            (a, b) => b.dateTime.compareTo(a.dateTime),
      );
  }

  /// Appointments for selected date
  List<AppointmentModel> get selectedDateAppointments {
    return upcomingAppointments.where((appointment) {
      final date = appointment.dateTime;

      return date.year == selectedDate.year &&
          date.month == selectedDate.month &&
          date.day == selectedDate.day;
    }).toList();
  }

  /// Total appointments
  int get totalAppointments => appointments.length;

  /// Total upcoming
  int get upcomingCount => upcomingAppointments.length;

  /// Total completed
  int get completedCount => pastAppointments.length;
}