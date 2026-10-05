import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/screens/auth_screen.dart';
import '../../core/theme/app_colors.dart';
import '../../main_screen.dart';
import '../controller/splash_controller.dart';
import '../widgets/loading_bar.dart';
import '../widgets/splash_logo.dart';
import '../widgets/splash_particles.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _started = false;
  bool _navigating = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_started) return;

    _started = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(splashControllerProvider.notifier)
          .startLoading(
        onCompleted: _handleSplashCompleted,
      );
    });
  }

  // ============================================================
  // CHECK FIREBASE LOGIN STATE
  // ============================================================

  Future<void> _handleSplashCompleted() async {
    if (!mounted || _navigating) return;

    _navigating = true;

    try {
      // Wait for Firebase Auth to provide the current
      // authentication state.
      final User? user =
      await FirebaseAuth.instance.authStateChanges().first;

      if (!mounted) return;

      // ========================================================
      // USER ALREADY LOGGED IN
      // ========================================================

      if (user != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const MainScreen(),
          ),
        );
      }

      // ========================================================
      // USER NOT LOGGED IN
      // ========================================================

      else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const AuthScreen(),
          ),
        );
      }
    } catch (e) {
      debugPrint(
        'Splash authentication check failed: $e',
      );

      if (!mounted) return;

      // If the auth check fails, safely send the user
      // to the login screen.
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const AuthScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress =
    ref.watch(splashControllerProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.gradientStart,
              AppColors.gradientMiddle,
              AppColors.gradientEnd,
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // ==================================================
              // FLOATING PARTICLES
              // ==================================================

              const SplashParticles(),

              // ==================================================
              // MAIN CONTENT
              // ==================================================

              Center(
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 24,
                  ),
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      // ==========================================
                      // LOGO
                      // ==========================================

                      const SplashLogo(),

                      const SizedBox(
                        height: 50,
                      ),

                      // ==========================================
                      // APP NAME
                      // ==========================================

                      const Text(
                        'HealthCare AI',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkBlue,
                        ),
                      )
                          .animate()
                          .fadeIn(
                        delay: 300.ms,
                        duration: 500.ms,
                      )
                          .slideY(
                        begin: .4,
                        end: 0,
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      // ==========================================
                      // SUBTITLE
                      // ==========================================

                      const Text(
                        'Your 24/7 Virtual Healthcare Assistant',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.blue,
                          fontWeight:
                          FontWeight.w500,
                        ),
                      )
                          .animate()
                          .fadeIn(
                        delay: 500.ms,
                        duration: 500.ms,
                      )
                          .slideY(
                        begin: .3,
                        end: 0,
                      ),

                      const SizedBox(
                        height: 60,
                      ),

                      // ==========================================
                      // PROGRESS BAR
                      // ==========================================

                      LoadingBar(
                        progress: progress,
                      ),
                    ],
                  ),
                ),
              ),

              // ==================================================
              // BOTTOM TEXT
              // ==================================================

              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: const Center(
                  child: Text(
                    'Powered by AI',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.blue,
                      letterSpacing: 3,
                      fontWeight:
                      FontWeight.w500,
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(
                  delay: 1200.ms,
                  duration: 700.ms,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}