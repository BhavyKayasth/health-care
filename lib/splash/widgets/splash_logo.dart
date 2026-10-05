import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_colors.dart';

class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      height: 170,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // ===============================
          // Animated Outer Glow
          // ===============================
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 1.0, end: 1.2),
            duration: const Duration(seconds: 2),
            curve: Curves.easeInOut,
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: Container(
                  width: 145,
                  height: 145,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withOpacity(.20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(.35),
                        blurRadius: 60,
                        spreadRadius: 20,
                      ),
                    ],
                  ),
                ),
              );
            },
          ).animate(
            onPlay: (controller) => controller.repeat(reverse: true),
          ),

          // ===============================
          // Main Circular Logo
          // ===============================
          Container(
            width: 128,
            height: 128,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.secondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: const Icon(
                LucideIcons.heartPulse,
                size: 62,
                color: Colors.white,
              )
                  .animate(
                onPlay: (controller) => controller.repeat(),
              )
                  .scale(
                begin: const Offset(.90, .90),
                end: const Offset(1.10, 1.10),
                duration: 750.ms,
                curve: Curves.easeInOut,
              )
                  .then()
                  .scale(
                begin: const Offset(1.10, 1.10),
                end: const Offset(.90, .90),
                duration: 750.ms,
                curve: Curves.easeInOut,
              ),
            ),
          ),

          // ===============================
          // Rotating Activity Badge
          // ===============================
          Positioned(
            top: 2,
            right: 4,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.10),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: const Icon(
                  LucideIcons.activity,
                  size: 22,
                  color: AppColors.primary,
                )
                    .animate(
                  onPlay: (controller) => controller.repeat(),
                )
                    .rotate(
                  duration: 3000.ms,
                ),
              ),
            ),
          ),
        ],
      ),
    )

    // Initial pop animation
        .animate()
        .scale(
      begin: const Offset(.20, .20),
      end: const Offset(1, 1),
      duration: 700.ms,
      curve: Curves.easeOutBack,
    )
        .fadeIn(
      duration: 600.ms,
    );
  }
}