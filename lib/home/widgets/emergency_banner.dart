// lib/home/widgets/emergency_banner.dart

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyBanner extends StatefulWidget {
  const EmergencyBanner({
    super.key,
  });

  @override
  State<EmergencyBanner> createState() =>
      _EmergencyBannerState();
}

class _EmergencyBannerState
    extends State<EmergencyBanner>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _pulseController;
  late final AnimationController _liveController;
  late final AnimationController _alertController;
  late final AnimationController _ambulanceController;

  late final Animation<double> _entranceOpacity;
  late final Animation<Offset> _entranceOffset;

  @override
  void initState() {
    super.initState();

    // ==========================================================
    // 1. BANNER ENTRANCE
    // ==========================================================

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 500,
      ),
    );

    _entranceOpacity = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOut,
    );

    _entranceOffset = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: Curves.easeOut,
      ),
    );

    Future.delayed(
      const Duration(
        milliseconds: 1200,
      ),
          () {
        if (!mounted) {
          return;
        }

        _entranceController.forward();
      },
    );

    // ==========================================================
    // 2. SOFT LOCALIZED GLOW
    // ==========================================================

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 2,
      ),
    )..repeat();

    // ==========================================================
    // 3. LIVE DOT
    // ==========================================================

    _liveController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 1,
      ),
    )..repeat(
      reverse: true,
    );

    // ==========================================================
    // 4. ALERT ICON
    // ==========================================================

    _alertController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 500,
      ),
    );

    _startAlertAnimation();

    // ==========================================================
    // 5. AMBULANCE ANIMATION
    // ==========================================================

    _ambulanceController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 2,
      ),
    )..repeat();
  }

  // ============================================================
  // ALERT LOOP
  // ============================================================

  Future<void> _startAlertAnimation() async {
    while (mounted) {
      await Future.delayed(
        const Duration(
          seconds: 2,
        ),
      );

      if (!mounted) {
        return;
      }

      await _alertController.forward();

      if (!mounted) {
        return;
      }

      await _alertController.reverse();
    }
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _entranceController.dispose();
    _pulseController.dispose();
    _liveController.dispose();
    _alertController.dispose();
    _ambulanceController.dispose();

    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      child: SlideTransition(
        position: _entranceOffset,
        child: FadeTransition(
          opacity: _entranceOpacity,
          child: Container(
            margin: const EdgeInsets.only(
              top: 24,
            ),
            padding: const EdgeInsets.all(
              20,
            ),
            decoration: BoxDecoration(
              borderRadius:
              BorderRadius.circular(16),
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFFEF4444),
                  Color(0xFFE11D48),
                ],
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 12,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                // =================================================
                // SOFT LOCALIZED GLOW
                // =================================================

                Positioned(
                  right: -28,
                  top: -32,
                  child: IgnorePointer(
                    child: AnimatedBuilder(
                      animation:
                      _pulseController,
                      builder:
                          (context, child) {
                        final progress =
                        Curves.easeInOut.transform(
                          _pulseController.value,
                        );

                        final glowScale =
                            0.95 +
                                (progress * 0.12);

                        final glowOpacity =
                            0.04 +
                                (0.08 *
                                    (1 -
                                        ((progress - 0.5)
                                            .abs() *
                                            2)));

                        return Transform.scale(
                          scale: glowScale,
                          child: Opacity(
                            opacity:
                            glowOpacity
                                .clamp(
                              0.0,
                              0.12,
                            ),
                            child: child,
                          ),
                        );
                      },
                      child: Container(
                        width: 160,
                        height: 160,
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

                Column(
                  children: [
                    Row(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                            children: [
                              // ===================================
                              // TITLE
                              // ===================================

                              Row(
                                children: [
                                  AnimatedBuilder(
                                    animation:
                                    _alertController,
                                    builder:
                                        (
                                        context,
                                        child,
                                        ) {
                                      final angle =
                                      TweenSequence<
                                          double>(
                                        [
                                          TweenSequenceItem(
                                            tween:
                                            Tween<double>(
                                              begin: 0,
                                              end: 10 *
                                                  math.pi /
                                                  180,
                                            ),
                                            weight: 1,
                                          ),
                                          TweenSequenceItem(
                                            tween:
                                            Tween<double>(
                                              begin: 10 *
                                                  math.pi /
                                                  180,
                                              end: -10 *
                                                  math.pi /
                                                  180,
                                            ),
                                            weight: 1,
                                          ),
                                          TweenSequenceItem(
                                            tween:
                                            Tween<double>(
                                              begin: -10 *
                                                  math.pi /
                                                  180,
                                              end: 0,
                                            ),
                                            weight: 1,
                                          ),
                                        ],
                                      ).transform(
                                        _alertController
                                            .value,
                                      );

                                      return Transform.rotate(
                                        angle: angle,
                                        child: child,
                                      );
                                    },
                                    child:
                                    const Icon(
                                      LucideIcons
                                          .triangleAlert,
                                      color:
                                      Colors.white,
                                      size: 24,
                                    ),
                                  ),

                                  const SizedBox(
                                    width: 8,
                                  ),

                                  const Text(
                                    'Emergency',
                                    style:
                                    TextStyle(
                                      color:
                                      Colors.white,
                                      fontSize: 18,
                                      fontWeight:
                                      FontWeight
                                          .bold,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(
                                height: 10,
                              ),

                              // ===================================
                              // DESCRIPTION
                              // ===================================

                              const Text(
                                'Call ambulance for immediate medical assistance',
                                style:
                                TextStyle(
                                  color:
                                  Colors.white,
                                  fontSize: 14,
                                  height: 1.35,
                                ),
                              ),

                              const SizedBox(
                                height: 16,
                              ),

                              // ===================================
                              // BUTTONS
                              // ===================================

                              Row(
                                children: [
                                  Expanded(
                                    child:
                                    _Call108Button(
                                      onTap: () {
                                        _makeCall(
                                          '108',
                                        );
                                      },
                                    ),
                                  ),

                                  const SizedBox(
                                    width: 8,
                                  ),

                                  Expanded(
                                    child:
                                    _Call102Button(
                                      onTap: () {
                                        _makeCall(
                                          '102',
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                          width: 12,
                        ),

                        // ========================================
                        // AMBULANCE
                        // ========================================

                        AnimatedBuilder(
                          animation:
                          _ambulanceController,
                          builder:
                              (
                              context,
                              child,
                              ) {
                            final value =
                                _ambulanceController
                                    .value;

                            final scale =
                                1 +
                                    (0.06 *
                                        math.sin(
                                          value *
                                              2 *
                                              math.pi,
                                        ));

                            final rotation =
                                3 *
                                    math.sin(
                                      value *
                                          2 *
                                          math.pi,
                                    ) *
                                    math.pi /
                                    180;

                            return Transform.rotate(
                              angle: rotation,
                              child:
                              Transform.scale(
                                scale: scale,
                                child: child,
                              ),
                            );
                          },
                          child: Container(
                            width: 82,
                            height: 82,
                            decoration:
                            BoxDecoration(
                              color: Colors.white
                                  .withOpacity(
                                0.10,
                              ),
                              shape:
                              BoxShape.circle,
                            ),
                            child: const Icon(
                              LucideIcons
                                  .ambulance,
                              size: 46,
                              color:
                              Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    // =================================================
                    // FOOTER
                    // =================================================

                    Container(
                      width:
                      double.infinity,
                      padding:
                      const EdgeInsets.only(
                        top: 14,
                      ),
                      decoration:
                      const BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color:
                            Colors.white24,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '📞 108 - Ambulance',
                              maxLines: 1,
                              overflow:
                              TextOverflow
                                  .ellipsis,
                              textAlign:
                              TextAlign.left,
                              style:
                              const TextStyle(
                                color:
                                Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),

                          const SizedBox(
                            width: 8,
                          ),

                          Expanded(
                            child: Text(
                              '📞 102 - Emergency Medical',
                              maxLines: 1,
                              overflow:
                              TextOverflow
                                  .ellipsis,
                              textAlign:
                              TextAlign.right,
                              style:
                              const TextStyle(
                                color:
                                Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // =================================================
                // LIVE INDICATOR
                // =================================================

                Positioned(
                  top: 0,
                  right: 0,
                  child: Row(
                    mainAxisSize:
                    MainAxisSize.min,
                    children: [
                      FadeTransition(
                        opacity: Tween<double>(
                          begin: 1,
                          end: 0.3,
                        ).animate(
                          _liveController,
                        ),
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration:
                          const BoxDecoration(
                            color: Colors.white,
                            shape:
                            BoxShape.circle,
                          ),
                        ),
                      ),

                      const SizedBox(
                        width: 6,
                      ),

                      const Text(
                        'LIVE',
                        style:
                        TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight:
                          FontWeight.bold,
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

  // ============================================================
  // PHONE CALL
  // ============================================================

  Future<void> _makeCall(
      String number,
      ) async {
    final Uri phoneUri =
    Uri.parse('tel:$number');

    try {
      final canCall =
      await canLaunchUrl(phoneUri);

      if (!canCall) {
        return;
      }

      await launchUrl(phoneUri);
    } catch (_) {
      // Ignore launch errors.
    }
  }
}

// ================================================================
// CALL 108 BUTTON
// ================================================================

class _Call108Button extends StatelessWidget {
  final VoidCallback onTap;

  const _Call108Button({
    required this.onTap,
  });

  @override
  Widget build(
      BuildContext context,
      ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius:
        BorderRadius.circular(30),
        child: Ink(
          padding:
          const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 11,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
            BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                color: Color(0x30000000),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              Icon(
                LucideIcons.phone,
                color: Color(0xFFDC2626),
                size: 16,
              ),
              SizedBox(width: 6),
              Flexible(
                child: Text(
                  'Call 108',
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: TextStyle(
                    color:
                    Color(0xFFDC2626),
                    fontSize: 12,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================================================================
// CALL 102 BUTTON
// ================================================================

class _Call102Button extends StatelessWidget {
  final VoidCallback onTap;

  const _Call102Button({
    required this.onTap,
  });

  @override
  Widget build(
      BuildContext context,
      ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius:
        BorderRadius.circular(30),
        child: Ink(
          padding:
          const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color:
            Colors.white.withOpacity(
              0.20,
            ),
            borderRadius:
            BorderRadius.circular(30),
            border: Border.all(
              color: Colors.white30,
              width: 1.5,
            ),
          ),
          child: const Center(
            child: Text(
              'Call 102',
              maxLines: 1,
              overflow:
              TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight:
                FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}