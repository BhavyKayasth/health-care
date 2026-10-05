import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../controller/step_controller.dart';

class StepCounterCard extends ConsumerWidget {
  const StepCounterCard({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stepState = ref.watch(stepControllerProvider);

    final int steps = stepState.steps;
    final int _ = stepState.goal;
    final double progress = stepState.progress;
    final int percentage = stepState.percentage;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            //--------------------------------------------------
            // CIRCULAR PROGRESS
            //--------------------------------------------------

            SizedBox(
              width: 78,
              height: 78,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 78,
                    height: 78,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 7,
                      backgroundColor: AppColors.lightBlue,
                      valueColor:
                      const AlwaysStoppedAnimation(
                        AppColors.primary,
                      ),
                    ),
                  ),

                  //------------------------------------------------
                  // STEP COUNT
                  //------------------------------------------------

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _formatSteps(steps),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: AppColors.darkBlue,
                        ),
                      ),
                      const Text(
                        "steps",
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 18),

            //--------------------------------------------------
            // DETAILS
            //--------------------------------------------------

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //------------------------------------------------
                  // TITLE + PERCENTAGE
                  //------------------------------------------------

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Daily Steps",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.darkBlue,
                        ),
                      ),
                      Text(
                        "$percentage%",
                        style: const TextStyle(
                          color: AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  //------------------------------------------------
                  // LINEAR PROGRESS
                  //------------------------------------------------

                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: AppColors.lightBlue,
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(height: 10),

                  //------------------------------------------------
                  // STATS
                  //------------------------------------------------

                  Text(
                    "${stepState.distanceKm.toStringAsFixed(2)} km • "
                        "${stepState.activeMinutes} min active • "
                        "${_formatRemaining(stepState.remainingSteps)} to goal",
                    style: const TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //----------------------------------------------------------
  // FORMAT STEPS
  //----------------------------------------------------------

  String _formatSteps(int steps) {
    if (steps >= 1000) {
      final double value = steps / 1000;

      if (value == value.roundToDouble()) {
        return "${value.toInt()}k";
      }

      return "${value.toStringAsFixed(1)}k";
    }

    return steps.toString();
  }

  //----------------------------------------------------------
  // FORMAT REMAINING STEPS
  //----------------------------------------------------------

  String _formatRemaining(int steps) {
    if (steps <= 0) {
      return "Goal reached";
    }

    if (steps >= 1000) {
      final double value = steps / 1000;

      if (value == value.roundToDouble()) {
        return "${value.toInt()}k";
      }

      return "${value.toStringAsFixed(1)}k";
    }

    return steps.toString();
  }
}