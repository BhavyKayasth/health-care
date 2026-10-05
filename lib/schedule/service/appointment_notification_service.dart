import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../models/appointment_model.dart';

class AppointmentNotificationService {
  AppointmentNotificationService._();

  static final AppointmentNotificationService instance =
  AppointmentNotificationService._();

  final FlutterLocalNotificationsPlugin _notifications =
  FlutterLocalNotificationsPlugin();

  Future<void>? _initialization;

  // ==========================================================
  // INITIALIZE
  // ==========================================================

  Future<void> initialize() {
    return _initialization ??= _initialize();
  }

  Future<void> _initialize() async {
    // --------------------------------------------------------
    // TIMEZONE
    // --------------------------------------------------------

    tz.initializeTimeZones();

    try {
      final timezoneInfo =
      await FlutterTimezone.getLocalTimezone();

      final String timezoneName =
          timezoneInfo.identifier;

      tz.setLocalLocation(
        tz.getLocation(timezoneName),
      );

      debugPrint(
        'AppointmentNotificationService: '
            'timezone=$timezoneName',
      );
    } catch (e) {
      debugPrint(
        'AppointmentNotificationService: '
            'timezone detection failed: $e',
      );

      // Fallback for India.
      tz.setLocalLocation(
        tz.getLocation('Asia/Kolkata'),
      );
    }

    // --------------------------------------------------------
    // ANDROID INITIALIZATION
    // --------------------------------------------------------

    const AndroidInitializationSettings
    androidSettings =
    AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const InitializationSettings settings =
    InitializationSettings(
      android: androidSettings,
    );

    await _notifications.initialize(
      settings: settings,
    );

    // --------------------------------------------------------
    // REQUEST ANDROID PERMISSIONS
    // --------------------------------------------------------

    final androidPlugin =
    _notifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.requestNotificationsPermission();

    await androidPlugin?.requestExactAlarmsPermission();

    debugPrint(
      'AppointmentNotificationService: '
          'initialized',
    );
  }

  // ==========================================================
  // SCHEDULE APPOINTMENT
  // ==========================================================

  Future<void> scheduleAppointment(
      AppointmentModel appointment,
      ) async {
    await initialize();

    final DateTime appointmentTime =
        appointment.dateTime;

    // Do not schedule appointments that are already past.
    if (!appointmentTime.isAfter(DateTime.now())) {
      debugPrint(
        'AppointmentNotificationService: '
            'skipping past appointment ${appointment.id}',
      );
      return;
    }

    final tz.TZDateTime scheduledDate =
    tz.TZDateTime.from(
      appointmentTime,
      tz.local,
    );

    final int notificationId =
    _notificationId(appointment.id);

    const AndroidNotificationDetails
    androidDetails =
    AndroidNotificationDetails(
      'appointment_reminders',
      'Appointment Reminders',
      channelDescription:
      'Reminders for scheduled doctor appointments.',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      enableVibration: true,
    );

    const NotificationDetails details =
    NotificationDetails(
      android: androidDetails,
    );

    await _notifications.zonedSchedule(
      id: notificationId,
      title: 'Appointment Reminder',
      body:
      'Your appointment with ${appointment.doctor} is now.',
      scheduledDate: scheduledDate,
      notificationDetails: details,
      androidScheduleMode:
      AndroidScheduleMode.exactAllowWhileIdle,
      payload: appointment.id,
    );

    debugPrint(
      'AppointmentNotificationService: '
          'scheduled ${appointment.doctor} '
          'at $appointmentTime '
          'notificationId=$notificationId',
    );
  }

  // ==========================================================
  // CANCEL APPOINTMENT
  // ==========================================================

  Future<void> cancelAppointment(
      String appointmentId,
      ) async {
    await initialize();

    await _notifications.cancel(
      id: _notificationId(appointmentId),
    );

    debugPrint(
      'AppointmentNotificationService: '
          'cancelled $appointmentId',
    );
  }

  // ==========================================================
  // NOTIFICATION ID
  // ==========================================================

  int _notificationId(
      String value,
      ) {
    int hash = 0;

    for (final int code in value.codeUnits) {
      hash = (hash * 31 + code) & 0x7fffffff;
    }

    return hash;
  }
}