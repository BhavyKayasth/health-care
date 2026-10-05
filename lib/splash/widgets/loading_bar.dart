import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_colors.dart';

class LoadingBar extends StatelessWidget {
  const LoadingBar({
    super.key,
    required this.progress,
  });

  /// Value between 0.0 and 1.0
  final double progress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: Column(
        children: [
          // Background Track
          Container(
            width: 280,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.lightBlue,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                width: 280 * progress,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      AppColors.primary,
                      AppColors.secondary,
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            "Initializing...",
            style: TextStyle(
              fontSize: 15,
              color: AppColors.blue,
              fontWeight: FontWeight.w500,
              letterSpacing: .4,
            ),
          )
              .animate()
              .fadeIn(
            duration: 800.ms,
            delay: 600.ms,
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(
      duration: 500.ms,
      delay: 500.ms,
    )
        .slideY(
      begin: .2,
      end: 0,
      duration: 500.ms,
    );
  }
}