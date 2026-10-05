import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String notificationChannelId = 'healthcare_steps';

const int notificationId = 1001;

const String stepDateKey = 'step_date';

const String stepCountKey = 'step_count';

const String lastSensorStepKey = 'last_sensor_steps';

const String dailyHistoryKey = 'daily_step_history';

//----------------------------------------------------------
// SERVICE CONFIGURATION FLAG
//----------------------------------------------------------

bool _serviceConfigured = false;

//----------------------------------------------------------
// INITIALIZE BACKGROUND SERVICE
//----------------------------------------------------------

Future<void> initializeStepBackgroundService() async {
  //--------------------------------------------------------
  // PREVENT MULTIPLE CONFIGURATIONS
  //--------------------------------------------------------

  if (_serviceConfigured) {
    return;
  }

  final service = FlutterBackgroundService();

  //--------------------------------------------------------
  // NOTIFICATION CHANNEL
  //--------------------------------------------------------

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    notificationChannelId,
    'HealthCare AI Step Counter',
    description: 'Tracks your daily steps in the background.',
    importance: Importance.low,
  );

  final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  //--------------------------------------------------------
  // INITIALIZE NOTIFICATIONS
  //--------------------------------------------------------

  await notifications.initialize(
    settings: const InitializationSettings(
      android: AndroidInitializationSettings('step_counter_notification'),
    ),
  );

  //--------------------------------------------------------
  // CREATE CHANNEL
  //--------------------------------------------------------

  await notifications
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);

  //--------------------------------------------------------
  // CONFIGURE SERVICE
  //--------------------------------------------------------

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: false,
      autoStartOnBoot: false,
      isForegroundMode: true,
      notificationChannelId: notificationChannelId,
      initialNotificationTitle: 'HealthCare AI',
      initialNotificationContent: 'Step counter is running',
      foregroundServiceNotificationId: notificationId,
      foregroundServiceTypes: [AndroidForegroundType.health],
    ),
    iosConfiguration: IosConfiguration(
      autoStart: false,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );

  _serviceConfigured = true;
}

//----------------------------------------------------------
// IOS BACKGROUND
//----------------------------------------------------------

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();

  DartPluginRegistrant.ensureInitialized();

  return true;
}

//----------------------------------------------------------
// BACKGROUND SERVICE
//----------------------------------------------------------

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  //--------------------------------------------------------
  // IMPORTANT
  //--------------------------------------------------------
  // Do NOT call DartPluginRegistrant.ensureInitialized()
  // here for Android.
  //
  // It previously caused an Android main-isolate error
  // with your installed background-service version.
  //--------------------------------------------------------

  //--------------------------------------------------------
  // SHARED PREFERENCES
  //--------------------------------------------------------

  final SharedPreferences prefs = await SharedPreferences.getInstance();

  //--------------------------------------------------------
  // TODAY
  //--------------------------------------------------------

  String today = _todayKey();

  //--------------------------------------------------------
  // LOAD SAVED DATA
  //--------------------------------------------------------

  String savedDate = prefs.getString(stepDateKey) ?? '';

  int savedSteps = prefs.getInt(stepCountKey) ?? 0;

  int? lastSensorSteps = prefs.getInt(lastSensorStepKey);

  //--------------------------------------------------------
  // LOAD DAILY HISTORY
  //--------------------------------------------------------

  Map<String, int> dailyHistory = _loadDailyHistory(prefs);

  //--------------------------------------------------------
  // NEW DAY
  //--------------------------------------------------------

  if (savedDate != today) {
    savedDate = today;

    savedSteps = 0;

    lastSensorSteps = null;

    await prefs.setString(stepDateKey, today);

    await prefs.setInt(stepCountKey, 0);

    await prefs.remove(lastSensorStepKey);

    //------------------------------------------------------
    // CREATE TODAY
    //------------------------------------------------------

    dailyHistory[today] = 0;

    await _saveDailyHistory(prefs, dailyHistory);
  }

  //--------------------------------------------------------
  // MAKE SURE TODAY EXISTS
  //--------------------------------------------------------

  dailyHistory[today] = savedSteps;

  await _saveDailyHistory(prefs, dailyHistory);

  //--------------------------------------------------------
  // LISTEN TO STEP SENSOR
  //--------------------------------------------------------

  StreamSubscription<StepCount>? subscription;

  subscription = Pedometer.stepCountStream.listen(
    (StepCount event) async {
      //----------------------------------------------------
      // CHECK DATE
      //----------------------------------------------------

      final String currentDate = _todayKey();

      //----------------------------------------------------
      // NEW DAY
      //----------------------------------------------------

      if (currentDate != today) {
        today = currentDate;

        savedSteps = 0;

        //--------------------------------------------------
        // VERY IMPORTANT:
        //
        // This sensor value becomes the baseline for the
        // new day.
        //--------------------------------------------------

        lastSensorSteps = event.steps;

        await prefs.setString(stepDateKey, today);

        await prefs.setInt(stepCountKey, 0);

        await prefs.setInt(lastSensorStepKey, event.steps);

        //--------------------------------------------------
        // CREATE NEW DAY HISTORY
        //--------------------------------------------------

        dailyHistory[today] = 0;

        await _saveDailyHistory(prefs, dailyHistory);

        //--------------------------------------------------
        // UPDATE UI
        //--------------------------------------------------

        service.invoke('stepsUpdated', {'steps': 0});

        return;
      }

      //----------------------------------------------------
      // FIRST SENSOR READING
      //----------------------------------------------------

      if (lastSensorSteps == null) {
        lastSensorSteps = event.steps;

        await prefs.setInt(lastSensorStepKey, event.steps);

        //--------------------------------------------------
        // SAVE CURRENT DAY
        //--------------------------------------------------

        dailyHistory[today] = savedSteps;

        await _saveDailyHistory(prefs, dailyHistory);

        service.invoke('stepsUpdated', {'steps': savedSteps});

        return;
      }

      //----------------------------------------------------
      // CALCULATE DIFFERENCE
      //----------------------------------------------------

      int difference = event.steps - lastSensorSteps!;

      //----------------------------------------------------
      // DEVICE REBOOT / SENSOR RESET
      //----------------------------------------------------

      if (difference < 0) {
        difference = event.steps;
      }

      //----------------------------------------------------
      // UPDATE SENSOR BASELINE
      //----------------------------------------------------

      lastSensorSteps = event.steps;

      await prefs.setInt(lastSensorStepKey, event.steps);

      //----------------------------------------------------
      // ADD NEW STEPS
      //----------------------------------------------------

      if (difference > 0) {
        savedSteps += difference;

        await prefs.setInt(stepCountKey, savedSteps);
      }

      //----------------------------------------------------
      // SAVE TODAY'S ACTUAL TOTAL
      //----------------------------------------------------

      dailyHistory[today] = savedSteps;

      await _saveDailyHistory(prefs, dailyHistory);

      //----------------------------------------------------
      // SEND TO UI
      //----------------------------------------------------

      service.invoke('stepsUpdated', {'steps': savedSteps});
    },
    onError: (dynamic error) {
      service.invoke('stepError', {'error': error.toString()});
    },
  );

  //--------------------------------------------------------
  // RESET STEPS
  //--------------------------------------------------------

  service.on('resetSteps').listen((event) async {
    savedSteps = 0;

    today = _todayKey();

    //----------------------------------------------------
    // SAVE RESET
    //----------------------------------------------------

    await prefs.setString(stepDateKey, today);

    await prefs.setInt(stepCountKey, 0);

    //----------------------------------------------------
    // RESET TODAY HISTORY
    //----------------------------------------------------

    dailyHistory[today] = 0;

    await _saveDailyHistory(prefs, dailyHistory);

    //----------------------------------------------------
    // KEEP SENSOR BASELINE
    //----------------------------------------------------

    if (lastSensorSteps != null) {
      await prefs.setInt(lastSensorStepKey, lastSensorSteps!);
    }

    //----------------------------------------------------
    // SEND RESET
    //----------------------------------------------------

    service.invoke('stepsUpdated', {'steps': 0});
  });

  //--------------------------------------------------------
  // STOP SERVICE
  //--------------------------------------------------------

  service.on('stopService').listen((event) async {
    await subscription?.cancel();

    service.stopSelf();
  });

  //--------------------------------------------------------
  // FOREGROUND NOTIFICATION
  //--------------------------------------------------------

  Timer.periodic(const Duration(minutes: 1), (Timer timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        service.setForegroundNotificationInfo(
          title: 'HealthCare AI',
          content: 'Steps today: $savedSteps',
        );
      }
    }
  });
}

//----------------------------------------------------------
// LOAD DAILY HISTORY
//----------------------------------------------------------

Map<String, int> _loadDailyHistory(SharedPreferences prefs) {
  final String? raw = prefs.getString(dailyHistoryKey);

  if (raw == null || raw.isEmpty) {
    return {};
  }

  try {
    final dynamic decoded = jsonDecode(raw);

    if (decoded is! Map) {
      return {};
    }

    final Map<String, int> result = {};

    decoded.forEach((key, value) {
      if (value is num) {
        result[key.toString()] = value.toInt();
      }
    });

    return result;
  } catch (_) {
    return {};
  }
}

//----------------------------------------------------------
// SAVE DAILY HISTORY
//----------------------------------------------------------

Future<void> _saveDailyHistory(
  SharedPreferences prefs,
  Map<String, int> history,
) async {
  await prefs.setString(dailyHistoryKey, jsonEncode(history));
}

//----------------------------------------------------------
// TODAY KEY
//----------------------------------------------------------

String _todayKey() {
  final DateTime now = DateTime.now();

  return '${now.year}-'
      '${now.month.toString().padLeft(2, '0')}-'
      '${now.day.toString().padLeft(2, '0')}';
}
