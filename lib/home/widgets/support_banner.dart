import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../controller/home_controller.dart';
import '../screens/doctor_call_list_screen.dart';

class SupportBanner extends ConsumerStatefulWidget {
  const SupportBanner({super.key});

  @override
  ConsumerState<SupportBanner> createState() =>
      _SupportBannerState();
}

class _SupportBannerState
    extends ConsumerState<SupportBanner>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _pulseController;
  late final AnimationController _iconController;

  bool _isButtonPressed = false;

  @override
  void initState() {
    super.initState();

    // ==========================================================
    // 1. BANNER ENTRANCE
    // ==========================================================

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    Future.delayed(
      const Duration(milliseconds: 1400),
          () {
        if (!mounted) return;

        _entranceController.forward();
      },
    );

    // ==========================================================
    // 2. SOFT INTERNAL GLOW
    // ==========================================================

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // ==========================================================
    // 3. HEART PULSE
    // ==========================================================

    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _pulseController.dispose();
    _iconController.dispose();

    super.dispose();
  }

  // ============================================================
  // OPEN DOCTORS
  // ============================================================

  void _openDoctors() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DoctorCallListScreen(
          onBack: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 22,
      ),
      child: AnimatedBuilder(
        animation: _entranceController,
        builder: (context, child) {
          final value =
          Curves.easeOutCubic.transform(
            _entranceController.value,
          );

          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(
                0,
                20 * (1 - value),
              ),
              child: child,
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(
            top: 26,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xff8b5cf6),
                Color(0xffec4899),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xff8b5cf6)
                    .withOpacity(0.28),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                // =================================================
                // LOCALIZED GLOW
                // =================================================

                Positioned(
                  right: -30,
                  top: -25,
                  child: IgnorePointer(
                    child: AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        final progress =
                            _pulseController.value;

                        final scale =
                            0.95 +
                                (0.10 *
                                    math.sin(
                                      progress *
                                          math.pi *
                                          2,
                                    ));

                        final opacity =
                            0.04 +
                                (0.05 *
                                    ((math.sin(
                                      progress *
                                          math.pi *
                                          2,
                                    ) +
                                        1) /
                                        2));

                        return Transform.scale(
                          scale: scale,
                          child: Opacity(
                            opacity: opacity.clamp(
                              0.0,
                              0.09,
                            ),
                            child: child,
                          ),
                        );
                      },
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration:
                        const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient:
                          RadialGradient(
                            colors: [
                              Colors.white,
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // =================================================
                // MAIN CONTENT
                // =================================================

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.center,
                    children: [
                      // ==========================================
                      // LEFT SIDE
                      // ==========================================

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            // ====================================
                            // HEADER
                            // ====================================

                            Row(
                              children: [
                                AnimatedBuilder(
                                  animation:
                                  _pulseController,
                                  builder:
                                      (context, child) {
                                    final scale =
                                        1.0 +
                                            (0.04 *
                                                math.sin(
                                                  _pulseController
                                                      .value *
                                                      math.pi *
                                                      2,
                                                ));

                                    return Transform.scale(
                                      scale: scale,
                                      child: child,
                                    );
                                  },
                                  child: const Icon(
                                    LucideIcons.clock3,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),

                                const SizedBox(
                                  width: 8,
                                ),

                                const Text(
                                  '24/7 Available',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight:
                                    FontWeight.bold,
                                    fontSize: 19,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            // ====================================
                            // DESCRIPTION
                            // ====================================

                            const Text(
                              'Need urgent care?',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),

                            const SizedBox(
                              height: 16,
                            ),

                            // ====================================
                            // VIEW DOCTORS BUTTON
                            // ====================================

                            Listener(
                              onPointerDown: (_) {
                                setState(() {
                                  _isButtonPressed = true;
                                });
                              },
                              onPointerUp: (_) {
                                setState(() {
                                  _isButtonPressed = false;
                                });
                              },
                              onPointerCancel: (_) {
                                setState(() {
                                  _isButtonPressed = false;
                                });
                              },
                              child: GestureDetector(
                                onTap: _openDoctors,
                                child: AnimatedScale(
                                  scale:
                                  _isButtonPressed
                                      ? 0.95
                                      : 1.0,
                                  duration:
                                  const Duration(
                                    milliseconds: 100,
                                  ),
                                  curve: Curves.easeOut,
                                  child: Container(
                                    padding:
                                    const EdgeInsets
                                        .symmetric(
                                      horizontal: 18,
                                      vertical: 11,
                                    ),
                                    decoration:
                                    BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                      BorderRadius
                                          .circular(
                                        999,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors
                                              .black
                                              .withOpacity(
                                            0.16,
                                          ),
                                          blurRadius: 10,
                                          offset:
                                          const Offset(
                                            0,
                                            5,
                                          ),
                                        ),
                                      ],
                                    ),
                                    child: const Row(
                                      mainAxisSize:
                                      MainAxisSize.min,
                                      children: [
                                        Icon(
                                          LucideIcons.phone,
                                          size: 17,
                                          color:
                                          Color(
                                            0xff8b5cf6,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          'View Doctors',
                                          style:
                                          TextStyle(
                                            color:
                                            Color(
                                              0xff8b5cf6,
                                            ),
                                            fontWeight:
                                            FontWeight
                                                .bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        width: 8,
                      ),

                      // ==========================================
                      // HEART PULSE
                      // ==========================================

                      AnimatedBuilder(
                        animation: _iconController,
                        builder:
                            (context, child) {
                          final t =
                              _iconController.value;

                          final scale =
                              1.0 +
                                  (0.05 *
                                      math.sin(
                                        t *
                                            math.pi *
                                            2,
                                      ));

                          final rotation =
                              0.02 *
                                  math.sin(
                                    t *
                                        math.pi *
                                        2,
                                  );

                          return Transform.rotate(
                            angle: rotation,
                            child: Transform.scale(
                              scale: scale,
                              child: child,
                            ),
                          );
                        },
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration:
                          BoxDecoration(
                            color: Colors.white
                                .withOpacity(
                              0.10,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              LucideIcons.heartPulse,
                              size: 42,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}