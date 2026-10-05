import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/appointment_dummy_data.dart';
import '../models/appointment_model.dart';
import '../service/appointment_notification_service.dart';
import 'schedule_state.dart';

final scheduleControllerProvider =
StateNotifierProvider<ScheduleController, ScheduleState>(
      (ref) => ScheduleController(),
);

class ScheduleController extends StateNotifier<ScheduleState> {
  ScheduleController() : super(ScheduleState.initial()) {
    _initialize();
  }

  final AppointmentNotificationService
  _notificationService =
      AppointmentNotificationService.instance;

  //==========================================================
  // INITIALIZE
  //==========================================================

  Future<void> _initialize() async {
    await _notificationService.initialize();
    await loadAppointments();
  }

  //==========================================================
  // LOAD APPOINTMENTS
  //==========================================================

  Future<void> loadAppointments() async {
    state = state.copyWith(
      isLoading: true,
    );

    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    final appointments =
        AppointmentDummyData.appointments;

    state = state.copyWith(
      isLoading: false,
      appointments: appointments,
    );

    // Schedule notifications for existing appointments.
    for (final appointment in appointments) {
      if (!appointment.completed &&
          appointment.dateTime.isAfter(DateTime.now())) {
        await _notificationService
            .scheduleAppointment(
          appointment,
        );
      }
    }
  }

  //==========================================================
  // REFRESH
  //==========================================================

  Future<void> refreshAppointments() async {
    await loadAppointments();
  }

  //==========================================================
  // SELECT DATE
  //==========================================================

  void selectDate(DateTime date) {
    state = state.copyWith(
      selectedDate: date,
    );
  }

  //==========================================================
  // BOOKING SCREEN
  //==========================================================

  void openBooking() {
    state = state.copyWith(
      isBooking: true,
    );
  }

  void closeBooking() {
    state = state.copyWith(
      isBooking: false,
    );
  }

  //==========================================================
  // ADD APPOINTMENT
  //==========================================================

  void addAppointment(
      AppointmentModel appointment,
      ) {
    state = state.copyWith(
      appointments: [
        ...state.appointments,
        appointment,
      ],
      isBooking: false,
    );

    // Schedule alarm for newly booked appointment.
    if (!appointment.completed &&
        appointment.dateTime.isAfter(DateTime.now())) {
      _notificationService.scheduleAppointment(
        appointment,
      );
    }
  }

  //==========================================================
  // REMOVE APPOINTMENT
  //==========================================================

  void removeAppointment(
      String id,
      ) {
    state = state.copyWith(
      appointments: state.appointments
          .where(
            (appointment) =>
        appointment.id != id,
      )
          .toList(),
    );

    _notificationService.cancelAppointment(
      id,
    );
  }

  //==========================================================
  // MARK COMPLETED
  //==========================================================

  void markCompleted(
      String id,
      ) {
    final updated =
    state.appointments.map(
          (appointment) {
        if (appointment.id != id) {
          return appointment;
        }

        return appointment.copyWith(
          completed: true,
        );
      },
    ).toList();

    state = state.copyWith(
      appointments: updated,
    );

    // Stop future alarm if appointment
    // was manually completed.
    _notificationService.cancelAppointment(
      id,
    );
  }

  //==========================================================
  // UPCOMING APPOINTMENTS
  //==========================================================

  List<AppointmentModel>
  get upcomingAppointments {
    final now = DateTime.now();

    return state.appointments
        .where(
          (appointment) {
        return !appointment.completed &&
            appointment.dateTime.isAfter(
              now,
            );
      },
    )
        .toList()
      ..sort(
            (a, b) => a.dateTime.compareTo(
          b.dateTime,
        ),
      );
  }

  //==========================================================
  // PAST APPOINTMENTS
  //==========================================================

  List<AppointmentModel>
  get pastAppointments {
    final now = DateTime.now();

    return state.appointments
        .where(
          (appointment) {
        return appointment.completed ||
            appointment.dateTime.isBefore(
              now,
            );
      },
    )
        .toList()
      ..sort(
            (a, b) => b.dateTime.compareTo(
          a.dateTime,
        ),
      );
  }

  //==========================================================
  // APPOINTMENTS FOR SELECTED DATE
  //==========================================================

  List<AppointmentModel>
  get selectedDateAppointments {
    return upcomingAppointments
        .where(
          (appointment) {
        return appointment.dateTime.year ==
            state.selectedDate.year &&
            appointment.dateTime.month ==
                state.selectedDate.month &&
            appointment.dateTime.day ==
                state.selectedDate.day;
      },
    )
        .toList();
  }
}