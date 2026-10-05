import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/step_background_service.dart';
import 'step_state.dart';

//----------------------------------------------------------
// PROVIDER
//----------------------------------------------------------

final stepControllerProvider = StateNotifierProvider<StepController, StepState>(
  (ref) => StepController(),
);

//----------------------------------------------------------
// CONTROLLER
//----------------------------------------------------------

class StepController extends StateNotifier<StepState> {
  StepController() : super(StepState.initial());

  //--------------------------------------------------------
  // BACKGROUND SERVICE LISTENER
  //--------------------------------------------------------

  StreamSubscription<dynamic>? _backgroundSubscription;

  //--------------------------------------------------------
  // STORAGE
  //--------------------------------------------------------

  SharedPreferences? _prefs;

  //--------------------------------------------------------
  // STORAGE KEYS
  //--------------------------------------------------------

  static const String _stepDateKey = 'step_date';

  static const String _stepCountKey = 'step_count';

  static const String _dailyHistoryKey = 'daily_step_history';

  //--------------------------------------------------------
  // INITIALIZE
  //--------------------------------------------------------

  Future<void> initialize() async {
    if (!mounted) {
      return;
    }

    state = state.copyWith(isLoading: true, isAvailable: false);

    try {
      //------------------------------------------------------
      // ACTIVITY RECOGNITION PERMISSION
      //------------------------------------------------------

      final permission = await Permission.activityRecognition.request();

      if (!permission.isGranted) {
        if (!mounted) {
          return;
        }

        state = state.copyWith(isLoading: false, isAvailable: false);

        return;
      }

      //------------------------------------------------------
      // SHARED PREFERENCES
      //------------------------------------------------------

      _prefs = await SharedPreferences.getInstance();

      //------------------------------------------------------
      // PREPARE TODAY
      //------------------------------------------------------

      await _prepareTodayData();

      //------------------------------------------------------
      // LOAD DAILY HISTORY
      //------------------------------------------------------

      final history = _loadDailyHistory();

      if (mounted) {
        state = state.copyWith(dailySteps: history);
      }

      //------------------------------------------------------
      // INITIALIZE BACKGROUND SERVICE
      //------------------------------------------------------

      await initializeStepBackgroundService();

      //------------------------------------------------------
      // SERVICE
      //------------------------------------------------------

      final service = FlutterBackgroundService();

      //------------------------------------------------------
      // LISTEN FOR STEP UPDATES
      //------------------------------------------------------

      await _backgroundSubscription?.cancel();

      _backgroundSubscription = service.on('stepsUpdated').listen((event) {
        if (!mounted || event == null) {
          return;
        }

        final dynamic value = event['steps'];

        if (value is int) {
          _updateStateFromSteps(value);
        }
      });

      //------------------------------------------------------
      // START SERVICE
      //------------------------------------------------------

      final bool isRunning = await service.isRunning();

      if (!isRunning) {
        await service.startService();
      }

      //------------------------------------------------------
      // LOAD TODAY'S SAVED STEPS
      //------------------------------------------------------

      final int savedSteps = _prefs?.getInt(_stepCountKey) ?? 0;

      //------------------------------------------------------
      // UPDATE STATE
      //------------------------------------------------------

      _updateStateFromSteps(savedSteps);

      //------------------------------------------------------
      // AVAILABLE
      //------------------------------------------------------

      if (!mounted) {
        return;
      }

      state = state.copyWith(isLoading: false, isAvailable: true);
    } catch (e, stackTrace) {
      debugPrint('STEP COUNTER ERROR: $e');

      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) {
        return;
      }

      state = state.copyWith(isLoading: false, isAvailable: false);
    }
  }

  //--------------------------------------------------------
  // PREPARE TODAY'S DATA
  //--------------------------------------------------------

  Future<void> _prepareTodayData() async {
    final prefs = _prefs;

    if (prefs == null) {
      return;
    }

    final String today = _todayKey();

    final String savedDate = prefs.getString(_stepDateKey) ?? '';

    //------------------------------------------------------
    // NEW DAY
    //------------------------------------------------------

    if (savedDate != today) {
      await prefs.setString(_stepDateKey, today);

      await prefs.setInt(_stepCountKey, 0);

      //----------------------------------------------------
      // DO NOT DELETE OLD HISTORY
      //----------------------------------------------------
      //
      // Keep previous days so the weekly chart can use them.
      //

      final Map<String, int> history = _loadDailyHistory();

      history[today] ??= 0;

      await _saveDailyHistory(history);
    }
  }

  //--------------------------------------------------------
  // LOAD DAILY HISTORY
  //--------------------------------------------------------

  Map<String, int> _loadDailyHistory() {
    final String? raw = _prefs?.getString(_dailyHistoryKey);

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
    } catch (e) {
      debugPrint('DAILY STEP HISTORY ERROR: $e');

      return {};
    }
  }

  //--------------------------------------------------------
  // SAVE DAILY HISTORY
  //--------------------------------------------------------

  Future<void> _saveDailyHistory(Map<String, int> history) async {
    await _prefs?.setString(_dailyHistoryKey, jsonEncode(history));
  }

  //--------------------------------------------------------
  // UPDATE UI + DAILY HISTORY
  //--------------------------------------------------------

  void _updateStateFromSteps(int steps) {
    if (!mounted) {
      return;
    }

    //------------------------------------------------------
    // CALCULATIONS
    //------------------------------------------------------

    final double distanceKm = (steps * 0.75) / 1000;

    final int activeMinutes = (steps / 100).round();

    final double calories = steps * 0.04;

    //------------------------------------------------------
    // UPDATE TODAY'S HISTORY
    //------------------------------------------------------

    final Map<String, int> history = Map<String, int>.from(state.dailySteps);

    final String today = _todayKey();

    history[today] = steps;

    //------------------------------------------------------
    // UPDATE STATE FIRST
    //------------------------------------------------------

    state = state.copyWith(
      steps: steps,
      distanceKm: distanceKm,
      activeMinutes: activeMinutes,
      calories: calories,
      dailySteps: history,
      isAvailable: true,
      isLoading: false,
    );

    //------------------------------------------------------
    // SAVE HISTORY
    //------------------------------------------------------

    unawaited(_saveDailyHistory(history));
  }

  //--------------------------------------------------------
  // SET GOAL
  //--------------------------------------------------------

  Future<void> setGoal(int newGoal) async {
    if (newGoal <= 0) {
      return;
    }

    if (!mounted) {
      return;
    }

    state = state.copyWith(goal: newGoal);
  }

  //--------------------------------------------------------
  // RESET
  //--------------------------------------------------------

  Future<void> resetSteps() async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();

    //------------------------------------------------------
    // TODAY
    //------------------------------------------------------

    final String today = _todayKey();

    //------------------------------------------------------
    // RESET SAVED COUNT
    //------------------------------------------------------

    await prefs.setString(_stepDateKey, today);

    await prefs.setInt(_stepCountKey, 0);

    //------------------------------------------------------
    // RESET TODAY HISTORY
    //------------------------------------------------------

    final Map<String, int> history = _loadDailyHistory();

    history[today] = 0;

    await _saveDailyHistory(history);

    //------------------------------------------------------
    // TELL BACKGROUND SERVICE
    //------------------------------------------------------

    final service = FlutterBackgroundService();

    service.invoke('resetSteps');

    //------------------------------------------------------
    // UPDATE STATE
    //------------------------------------------------------

    _updateStateFromSteps(0);
  }

  //--------------------------------------------------------
  // REFRESH
  //--------------------------------------------------------

  Future<void> refresh() async {
    await _backgroundSubscription?.cancel();

    _backgroundSubscription = null;

    await initialize();
  }

  //--------------------------------------------------------
  // TODAY KEY
  //--------------------------------------------------------

  String _todayKey() {
    final now = DateTime.now();

    return '${now.year}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
  }

  //--------------------------------------------------------
  // DISPOSE
  //--------------------------------------------------------

  @override
  void dispose() {
    _backgroundSubscription?.cancel();

    _backgroundSubscription = null;

    super.dispose();
  }
}
