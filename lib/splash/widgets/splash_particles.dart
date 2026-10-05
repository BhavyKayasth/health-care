import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class SplashParticles extends StatelessWidget {
  const SplashParticles({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(
        8,
            (index) => _Particle(seed: index),
      ),
    );
  }
}

class _Particle extends StatefulWidget {
  const _Particle({
    required this.seed,
  });

  final int seed;

  @override
  State<_Particle> createState() => _ParticleState();
}

class _ParticleState extends State<_Particle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final double leftFactor;
  late final double topFactor;
  late final double size;
  late final double moveDistance;
  late final Duration duration;
  late final Duration delay;

  @override
  void initState() {
    super.initState();

    final random = Random(widget.seed * 31);

    leftFactor = random.nextDouble();
    topFactor = random.nextDouble();

    size = 6 + random.nextDouble() * 8;

    moveDistance = 20 + random.nextDouble() * 35;

    duration = Duration(
      milliseconds: 3000 + random.nextInt(2000),
    );

    delay = Duration(
      milliseconds: random.nextInt(1500),
    );

    _controller = AnimationController(
      vsync: this,
      duration: duration,
    );

    Future.delayed(delay, () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.sizeOf(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final animation =
        Curves.easeInOut.transform(_controller.value);

        return Positioned(
          left: leftFactor * screen.width,
          top: topFactor * screen.height +
              sin(animation * pi * 2) * moveDistance,
          child: Opacity(
            opacity: 0.15 + (0.45 * animation),
            child: Container(
              width: size,
              height: size,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }
}