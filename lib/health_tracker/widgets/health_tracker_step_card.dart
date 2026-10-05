import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../step_counter/controller/step_controller.dart';
import 'health_tracker_components.dart';

class HealthTrackerStepCard extends ConsumerWidget {
  const HealthTrackerStepCard({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    //----------------------------------------------------------
    // REAL STEP COUNTER DATA
    //----------------------------------------------------------

    final stepState =
    ref.watch(stepControllerProvider);

    final int steps = stepState.steps;

    final int dailyGoal = stepState.goal;

    final double stepPercent =
        stepState.progress;

    //----------------------------------------------------------
    // CARD
    //----------------------------------------------------------

    return TrackerWhiteCard(
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [

          //----------------------------------------------------
          // HEADER
          //----------------------------------------------------

          Row(
            children: [

              const Icon(
                LucideIcons.trendingUp,
                color: Color(0xFF3B82F6),
                size: 20,
              ),

              const SizedBox(width: 8),

              const Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    Text(
                      'Step Counter',

                      style: TextStyle(
                        color: Color(0xFF1E3A8A),
                        fontSize: 16,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    Text(
                      'Auto-detecting your movement',

                      style: TextStyle(
                        color: Color(0xFF60A5FA),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),

              //------------------------------------------------
              // STATUS
              //------------------------------------------------

              Container(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 5,
                ),

                decoration:
                BoxDecoration(
                  color:
                  const Color(0xFFEFF6FF),

                  borderRadius:
                  BorderRadius.circular(
                    30,
                  ),

                  border:
                  Border.all(
                    color:
                    const Color(0xFFDBEAFE),
                  ),
                ),

                child: Text(
                  stepState.isAvailable
                      ? 'Tracking'
                      : 'Unavailable',

                  style: TextStyle(
                    color: stepState.isAvailable
                        ? const Color(
                      0xFF60A5FA,
                    )
                        : Colors.grey,

                    fontSize: 9,

                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          //----------------------------------------------------
          // MAIN CONTENT
          //----------------------------------------------------

          Row(
            children: [

              //------------------------------------------------
              // CIRCULAR PROGRESS
              //------------------------------------------------

              SizedBox(
                width: 116,
                height: 116,

                child: CustomPaint(
                  painter:
                  StepProgressPainter(
                    progress:
                    stepPercent,
                  ),

                  child: Center(
                    child: Column(
                      mainAxisSize:
                      MainAxisSize.min,

                      children: [

                        Text(
                          _formatSteps(
                            steps,
                          ),

                          style:
                          const TextStyle(
                            color:
                            Color(0xFF1E3A8A),
                            fontSize: 19,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),

                        const Text(
                          'steps',

                          style: TextStyle(
                            color:
                            Color(0xFF60A5FA),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 18),

              //------------------------------------------------
              // DETAILS
              //------------------------------------------------

              Expanded(
                child: Column(
                  children: [

                    //------------------------------------------------
                    // GOAL
                    //------------------------------------------------

                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,

                      children: [

                        Text(
                          '${stepState.percentage}% of goal',

                          style:
                          const TextStyle(
                            color:
                            Color(0xFF1D4ED8),
                            fontSize: 10,
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),

                        Text(
                          _formatNumber(
                            dailyGoal,
                          ),

                          style:
                          const TextStyle(
                            color:
                            Color(0xFF60A5FA),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    //------------------------------------------------
                    // PROGRESS BAR
                    //------------------------------------------------

                    ClipRRect(
                      borderRadius:
                      BorderRadius.circular(
                        20,
                      ),

                      child:
                      LinearProgressIndicator(
                        value:
                        stepPercent,

                        minHeight: 8,

                        backgroundColor:
                        const Color(
                          0xFFEFF6FF,
                        ),

                        valueColor:
                        const AlwaysStoppedAnimation(
                          Color(0xFF06B6D4),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    //------------------------------------------------
                    // DISTANCE + CALORIES
                    //------------------------------------------------

                    Row(
                      children: [

                        Expanded(
                          child:
                          TrackerSmallStat(
                            value:
                            '${stepState.distanceKm.toStringAsFixed(2)} km',

                            label:
                            'Distance',

                            background:
                            const Color(
                              0xFFEFF6FF,
                            ),

                            textColor:
                            const Color(
                              0xFF1D4ED8,
                            ),
                          ),
                        ),

                        const SizedBox(width: 5),

                        Expanded(
                          child:
                          TrackerSmallStat(
                            value:
                            '${stepState.calories.round()} cal',

                            label:
                            'Burned',

                            background:
                            const Color(
                              0xFFFFF7ED,
                            ),

                            textColor:
                            const Color(
                              0xFFEA580C,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 5),

                    //------------------------------------------------
                    // ACTIVE + REMAINING
                    //------------------------------------------------

                    Row(
                      children: [

                        Expanded(
                          child:
                          TrackerSmallStat(
                            value:
                            '${stepState.activeMinutes} min',

                            label:
                            'Active',

                            background:
                            const Color(
                              0xFFF0FDF4,
                            ),

                            textColor:
                            const Color(
                              0xFF16A34A,
                            ),
                          ),
                        ),

                        const SizedBox(width: 5),

                        Expanded(
                          child:
                          TrackerSmallStat(
                            value:
                            stepState
                                .goalCompleted
                                ? 'Done!'
                                : _formatNumber(
                              stepState
                                  .remainingSteps,
                            ),

                            label:
                            stepState
                                .goalCompleted
                                ? 'Achieved!'
                                : 'To goal',

                            background:
                            const Color(
                              0xFFFAF5FF,
                            ),

                            textColor:
                            const Color(
                              0xFF9333EA,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          //------------------------------------------------------
          // UNAVAILABLE MESSAGE
          //------------------------------------------------------

          if (!stepState.isAvailable &&
              !stepState.isLoading) ...[
            const SizedBox(height: 12),

            const Text(
              'Step tracking is currently unavailable.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 11,
              ),
            ),
          ],
        ],
      ),
    );
  }

  //----------------------------------------------------------
  // FORMAT STEPS
  //----------------------------------------------------------

  String _formatSteps(int steps) {
    if (steps >= 1000) {
      final double value =
          steps / 1000;

      if (value ==
          value.roundToDouble()) {
        return '${value.toInt()}k';
      }

      return value.toStringAsFixed(1) + 'k';
    }

    return steps.toString();
  }

  //----------------------------------------------------------
  // FORMAT NUMBER
  //----------------------------------------------------------

  String _formatNumber(int number) {
    return number
        .toString()
        .replaceAllMapped(
      RegExp(
        r'\B(?=(\d{3})+(?!\d))',
      ),
          (match) => ',',
    );
  }
}