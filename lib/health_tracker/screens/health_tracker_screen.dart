import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../step_counter/controller/step_controller.dart';

import '../widgets/health_tracker_calories.dart';
import '../widgets/health_tracker_header.dart';
import '../widgets/health_tracker_heart_rate.dart';
import '../widgets/health_tracker_hydration.dart';
import '../widgets/health_tracker_sleep.dart';
import '../widgets/health_tracker_step_card.dart';
import '../widgets/health_tracker_tabs.dart';
import '../widgets/health_tracker_vitals.dart';
import '../widgets/health_tracker_weekly_steps.dart';

class HealthTrackerScreen extends ConsumerStatefulWidget {
  const HealthTrackerScreen({super.key});

  @override
  ConsumerState<HealthTrackerScreen> createState() =>
      _HealthTrackerScreenState();
}

class _HealthTrackerScreenState extends ConsumerState<HealthTrackerScreen> {
  //----------------------------------------------------------
  // STATE
  //----------------------------------------------------------

  int waterGlasses = 5;

  int heartRate = 72;

  String activeTab = 'Today';

  //----------------------------------------------------------
  // HEART RATE SIMULATION
  //----------------------------------------------------------

  @override
  void initState() {
    super.initState();

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) {
        return false;
      }

      setState(() {
        final int change = math.Random().nextInt(7) - 3;

        heartRate = math.max(58, math.min(102, heartRate + change));
      });

      return true;
    });
  }

  //----------------------------------------------------------
  // BUILD WEEKLY DATA
  //----------------------------------------------------------

  List<Map<String, dynamic>> _buildWeeklyData(
    Map<String, int> history,
    int currentSteps,
  ) {
    final DateTime now = DateTime.now();

    //--------------------------------------------------------
    // GET MONDAY OF CURRENT WEEK
    //--------------------------------------------------------

    final DateTime monday = DateTime(
      now.year,
      now.month,
      now.day - (now.weekday - 1),
    );

    const List<String> dayNames = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];

    final List<Map<String, dynamic>> result = [];

    //--------------------------------------------------------
    // BUILD 7 DAYS
    //--------------------------------------------------------

    for (int i = 0; i < 7; i++) {
      final DateTime date = monday.add(Duration(days: i));

      final String key = _dateKey(date);

      //------------------------------------------------------
      // FUTURE DAY
      //------------------------------------------------------

      final bool isFuture = date.isAfter(
        DateTime(now.year, now.month, now.day),
      );

      if (isFuture) {
        result.add({'day': dayNames[i], 'steps': null});

        continue;
      }

      //------------------------------------------------------
      // TODAY
      //
      // Always use the live StepController value.
      //------------------------------------------------------

      if (_isSameDay(date, now)) {
        result.add({'day': dayNames[i], 'steps': currentSteps});

        continue;
      }

      //------------------------------------------------------
      // PAST DAY
      //
      // Use only real saved history.
      //------------------------------------------------------

      result.add({'day': dayNames[i], 'steps': history[key]});
    }

    return result;
  }

  //----------------------------------------------------------
  // DATE KEY
  //----------------------------------------------------------

  String _dateKey(DateTime date) {
    return '${date.year}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  //----------------------------------------------------------
  // SAME DAY
  //----------------------------------------------------------

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  //----------------------------------------------------------
  // BUILD
  //----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    //--------------------------------------------------------
    // WATCH REAL STEP STATE
    //--------------------------------------------------------

    final stepState = ref.watch(stepControllerProvider);

    //--------------------------------------------------------
    // BUILD REAL WEEKLY DATA
    //--------------------------------------------------------

    final List<Map<String, dynamic>> weeklyData = _buildWeeklyData(
      stepState.dailySteps,
      stepState.steps,
    );

    //--------------------------------------------------------
    // SCREEN
    //--------------------------------------------------------

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      body: SafeArea(
        bottom: false,

        //----------------------------------------------------
        // ENTIRE SCREEN SCROLLS
        //----------------------------------------------------
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          padding: const EdgeInsets.only(bottom: 40),

          child: Column(
            children: [
              //------------------------------------------------
              // HEADER
              //------------------------------------------------
              const HealthTrackerHeader(),

              //------------------------------------------------
              // CONTENT
              //------------------------------------------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),

                child: Column(
                  children: [
                    //------------------------------------------------
                    // TABS
                    //------------------------------------------------
                    HealthTrackerTabs(
                      activeTab: activeTab,

                      onChanged: (value) {
                        setState(() {
                          activeTab = value;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    //------------------------------------------------
                    // REAL STEP COUNTER
                    //------------------------------------------------
                    const HealthTrackerStepCard(),

                    const SizedBox(height: 16),

                    //------------------------------------------------
                    // HEART RATE
                    //------------------------------------------------
                    HealthTrackerHeartRate(heartRate: heartRate),

                    const SizedBox(height: 16),

                    //------------------------------------------------
                    // VITALS
                    //------------------------------------------------
                    const HealthTrackerVitals(),

                    const SizedBox(height: 16),

                    //------------------------------------------------
                    // SLEEP
                    //------------------------------------------------
                    const HealthTrackerSleep(),

                    const SizedBox(height: 16),

                    //------------------------------------------------
                    // HYDRATION
                    //------------------------------------------------
                    HealthTrackerHydration(
                      waterGlasses: waterGlasses,

                      onWaterChanged: (value) {
                        setState(() {
                          waterGlasses = value;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    //------------------------------------------------
                    // CALORIES
                    //------------------------------------------------
                    const HealthTrackerCalories(),

                    const SizedBox(height: 16),

                    //------------------------------------------------
                    // REAL WEEKLY STEPS
                    //------------------------------------------------
                    HealthTrackerWeeklySteps(data: weeklyData),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
