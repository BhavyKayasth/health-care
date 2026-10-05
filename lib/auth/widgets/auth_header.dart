import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_colors.dart';
import 'auth_logo.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Logo
        const AuthLogo(),

        const SizedBox(height: 28),

        // Title
        const Text(
          "Welcome to HealthCare AI",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.darkBlue,
            letterSpacing: -.4,
          ),
        )
            .animate()
            .fadeIn(
          delay: 100.ms,
          duration: 500.ms,
        )
            .slideY(
          begin: -.2,
          end: 0,
          curve: Curves.easeOut,
        ),

        const SizedBox(height: 10),

        // Subtitle
        const Text(
          "Your 24/7 Virtual Healthcare Assistant",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: AppColors.blue,
            height: 1.4,
          ),
        )
            .animate()
            .fadeIn(
          delay: 200.ms,
          duration: 500.ms,
        )
            .slideY(
          begin: -.2,
          end: 0,
          curve: Curves.easeOut,
        ),
      ],
    );
  }
}