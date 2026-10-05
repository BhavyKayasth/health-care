import 'dart:math' as math;

import 'package:flutter/material.dart';

//==========================================================
// WHITE CARD
//==========================================================

class TrackerWhiteCard
    extends StatelessWidget {
  final Widget child;

  const TrackerWhiteCard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.all(20),

      decoration:
      BoxDecoration(
        color: Colors.white,

        borderRadius:
        BorderRadius.circular(
          28,
        ),

        border:
        Border.all(
          color:
          const Color(0xFFEFF6FF),
        ),

        boxShadow: const [
          BoxShadow(
            color:
            Color(0x08000000),
            blurRadius: 10,
            offset:
            Offset(0, 3),
          ),
        ],
      ),

      child: child,
    );
  }
}

//==========================================================
// LIVE INDICATOR
//==========================================================

class LiveIndicator
    extends StatefulWidget {
  const LiveIndicator({
    super.key,
  });

  @override
  State<LiveIndicator> createState() =>
      _LiveIndicatorState();
}

class _LiveIndicatorState
    extends State<LiveIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller =
    AnimationController(
      vsync: this,
      duration:
      const Duration(
        milliseconds: 1200,
      ),
    )..repeat(
      reverse: true,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),

      decoration:
      BoxDecoration(
        color:
        const Color(0xFF22C55E)
            .withOpacity(
          0.20,
        ),

        borderRadius:
        BorderRadius.circular(
          30,
        ),

        border:
        Border.all(
          color:
          const Color(0xFF86EFAC)
              .withOpacity(
            0.35,
          ),
        ),
      ),

      child: Row(
        children: [

          FadeTransition(
            opacity:
            Tween<double>(
              begin: .3,
              end: 1,
            ).animate(controller),

            child: Container(
              width: 7,
              height: 7,

              decoration:
              const BoxDecoration(
                color:
                Color(0xFF4ADE80),
                shape:
                BoxShape.circle,
              ),
            ),
          ),

          const SizedBox(width: 6),

          const Text(
            'LIVE',

            style: TextStyle(
              color:
              Color(0xFFBBF7D0),
              fontSize: 11,
              fontWeight:
              FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

//==========================================================
// SMALL STEP STAT
//==========================================================

class TrackerSmallStat
    extends StatelessWidget {
  final String value;
  final String label;
  final Color background;
  final Color textColor;

  const TrackerSmallStat({
    super.key,
    required this.value,
    required this.label,
    required this.background,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.symmetric(
        vertical: 7,
      ),

      decoration:
      BoxDecoration(
        color: background,

        borderRadius:
        BorderRadius.circular(
          10,
        ),
      ),

      child: Column(
        children: [

          Text(
            value,

            style:
            TextStyle(
              color: textColor,
              fontSize: 9,
              fontWeight:
              FontWeight.bold,
            ),
          ),

          const SizedBox(height: 1),

          Text(
            label,

            style:
            const TextStyle(
              color:
              Color(0xFF9CA3AF),
              fontSize: 8,
            ),
          ),
        ],
      ),
    );
  }
}

//==========================================================
// ACTION BUTTON
//==========================================================

class TrackerActionButton
    extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;

  const TrackerActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.background,
    required this.foreground,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        height: 38,

        decoration:
        BoxDecoration(
          color: background,

          borderRadius:
          BorderRadius.circular(
            12,
          ),
        ),

        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.center,

          children: [

            Icon(
              icon,
              color: foreground,
              size: 14,
            ),

            const SizedBox(width: 4),

            Text(
              label,

              style:
              TextStyle(
                color: foreground,
                fontSize: 9,
                fontWeight:
                FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//==========================================================
// HEART STAT
//==========================================================

class HeartStat
    extends StatelessWidget {
  final String value;
  final String label;

  const HeartStat({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.symmetric(
        vertical: 8,
      ),

      decoration:
      BoxDecoration(
        color:
        Colors.white.withOpacity(
          .10,
        ),

        borderRadius:
        BorderRadius.circular(
          11,
        ),
      ),

      child: Column(
        children: [

          Text(
            value,

            style:
            const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight:
              FontWeight.bold,
            ),
          ),

          Text(
            label,

            style:
            const TextStyle(
              color:
              Color(0xFFFBCFE8),
              fontSize: 8,
            ),
          ),
        ],
      ),
    );
  }
}

//==========================================================
// MACRO STAT
//==========================================================

class MacroStat
    extends StatelessWidget {
  final String value;
  final String label;

  const MacroStat({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.symmetric(
        vertical: 8,
      ),

      decoration:
      BoxDecoration(
        color:
        Colors.white.withOpacity(
          .15,
        ),

        borderRadius:
        BorderRadius.circular(
          11,
        ),
      ),

      child: Column(
        children: [

          Text(
            value,

            style:
            const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight:
              FontWeight.bold,
            ),
          ),

          Text(
            label,

            style:
            const TextStyle(
              color:
              Color(0xFFFFE4C7),
              fontSize: 8,
            ),
          ),
        ],
      ),
    );
  }
}

//==========================================================
// WEEKLY STAT
//==========================================================

class WeeklyStat
    extends StatelessWidget {
  final String value;
  final String label;

  const WeeklyStat({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Text(
          value,

          style:
          const TextStyle(
            color:
            Color(0xFF1E3A8A),
            fontSize: 12,
            fontWeight:
            FontWeight.bold,
          ),
        ),

        const SizedBox(height: 2),

        Text(
          label,

          style:
          const TextStyle(
            color:
            Color(0xFF60A5FA),
            fontSize: 8,
          ),
        ),
      ],
    );
  }
}

//==========================================================
// STEP PROGRESS PAINTER
//==========================================================

class StepProgressPainter
    extends CustomPainter {
  final double progress;

  StepProgressPainter({
    required this.progress,
  });

  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {
    final center =
    Offset(
      size.width / 2,
      size.height / 2,
    );

    final radius =
        size.width / 2 - 6;

    final backgroundPaint =
    Paint()
      ..style =
          PaintingStyle.stroke
      ..strokeWidth = 9
      ..color =
      const Color(0xFFE0F2FE);

    canvas.drawCircle(
      center,
      radius,
      backgroundPaint,
    );

    final progressPaint =
    Paint()
      ..style =
          PaintingStyle.stroke
      ..strokeWidth = 9
      ..strokeCap =
          StrokeCap.round
      ..shader =
      const LinearGradient(
        colors: [
          Color(0xFF3B82F6),
          Color(0xFF06B6D4),
        ],
      ).createShader(
        Rect.fromCircle(
          center: center,
          radius: radius,
        ),
      );

    canvas.drawArc(
      Rect.fromCircle(
        center: center,
        radius: radius,
      ),
      -math.pi / 2,
      2 *
          math.pi *
          progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(
      covariant StepProgressPainter
      oldDelegate,
      ) {
    return oldDelegate.progress !=
        progress;
  }
}

//==========================================================
// ECG PAINTER
//==========================================================

class EcgPainter
    extends CustomPainter {
  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {
    final paint =
    Paint()
      ..color =
      Colors.white.withOpacity(
        .85,
      )
      ..style =
          PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap =
          StrokeCap.round;

    final path = Path();

    final points = [
      const Offset(0, 27),
      const Offset(20, 27),
      const Offset(23, 27),
      const Offset(27, 7),
      const Offset(31, 47),
      const Offset(35, 27),
      const Offset(53, 27),
      const Offset(58, 17),
      const Offset(62, 27),
      const Offset(85, 27),
      const Offset(105, 27),
      const Offset(109, 7),
      const Offset(113, 47),
      const Offset(117, 27),
      const Offset(135, 27),
      const Offset(140, 17),
      const Offset(144, 27),
      const Offset(168, 27),
      const Offset(188, 27),
      const Offset(192, 7),
      const Offset(196, 47),
      const Offset(200, 27),
    ];

    path.moveTo(
      points.first.dx,
      points.first.dy,
    );

    for (final point
    in points.skip(1)) {
      path.lineTo(
        point.dx,
        point.dy,
      );
    }

    canvas.drawPath(
      path,
      paint,
    );
  }

  @override
  bool shouldRepaint(
      covariant CustomPainter oldDelegate,
      ) {
    return false;
  }
}

//==========================================================
// BOTTLE
//==========================================================

class BottlePainter
    extends CustomPainter {
  final double fill;

  BottlePainter({
    required this.fill,
  });

  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {
    final bottleRect =
    Rect.fromLTWH(
      16,
      15,
      40,
      88,
    );

    final bottlePaint =
    Paint()
      ..color =
      const Color(0xFFE0F2FE);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        bottleRect,
        const Radius.circular(
          12,
        ),
      ),
      bottlePaint,
    );

    final fillHeight =
        88 * fill;

    final waterRect =
    Rect.fromLTWH(
      16,
      103 - fillHeight,
      40,
      fillHeight,
    );

    final waterPaint =
    Paint()
      ..shader =
      const LinearGradient(
        begin:
        Alignment.bottomCenter,
        end:
        Alignment.topCenter,
        colors: [
          Color(0xFF06B6D4),
          Color(0xFF67E8F9),
        ],
      ).createShader(
        waterRect,
      );

    canvas.save();

    canvas.clipRRect(
      RRect.fromRectAndRadius(
        bottleRect,
        const Radius.circular(
          12,
        ),
      ),
    );

    canvas.drawRect(
      waterRect,
      waterPaint,
    );

    canvas.restore();

    final capPaint =
    Paint()
      ..color =
      const Color(0xFFBAE6FD);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(
          21,
          7,
          30,
          10,
        ),
        const Radius.circular(
          2,
        ),
      ),
      capPaint,
    );

    final dropPaint =
    Paint()
      ..color =
          Colors.white;

    canvas.drawCircle(
      const Offset(36, 57),
      7,
      dropPaint,
    );
  }

  @override
  bool shouldRepaint(
      covariant BottlePainter oldDelegate,
      ) {
    return oldDelegate.fill !=
        fill;
  }
}

//==========================================================
// CIRCULAR PROGRESS
//==========================================================

class CircularProgressPainter
    extends CustomPainter {
  final double progress;

  CircularProgressPainter({
    required this.progress,
  });

  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {
    final center =
    Offset(
      size.width / 2,
      size.height / 2,
    );

    final radius =
        size.width / 2 - 7;

    final backgroundPaint =
    Paint()
      ..style =
          PaintingStyle.stroke
      ..strokeWidth = 7
      ..color =
      Colors.white
          .withOpacity(
        .25,
      );

    canvas.drawCircle(
      center,
      radius,
      backgroundPaint,
    );

    final progressPaint =
    Paint()
      ..style =
          PaintingStyle.stroke
      ..strokeCap =
          StrokeCap.round
      ..strokeWidth = 7
      ..color =
          Colors.white;

    canvas.drawArc(
      Rect.fromCircle(
        center: center,
        radius: radius,
      ),
      -math.pi / 2,
      2 *
          math.pi *
          progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(
      covariant CircularProgressPainter
      oldDelegate,
      ) {
    return oldDelegate.progress !=
        progress;
  }
}

//==========================================================
// WEEKLY BAR CHART
//==========================================================

class WeeklyBarChartPainter
    extends CustomPainter {
  final List<Map<String, dynamic>> data;

  WeeklyBarChartPainter({
    required this.data,
  });

  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {
    const double maxValue =
    12000.0;

    final double chartHeight =
        size.height - 25;

    final double barWidth =
        size.width /
            data.length *
            .35;

    final textPainter =
    TextPainter(
      textDirection:
      TextDirection.ltr,
    );

    final barPaint =
    Paint()
      ..shader =
      const LinearGradient(
        begin:
        Alignment.topCenter,
        end:
        Alignment.bottomCenter,
        colors: [
          Color(0xFF3B82F6),
          Color(0xFF06B6D4),
        ],
      ).createShader(
        Rect.fromLTWH(
          0,
          0,
          size.width,
          chartHeight,
        ),
      );

    for (int i = 0;
    i < data.length;
    i++) {
      final double value =
      (data[i]['steps'] as num)
          .toDouble();

      final double barHeight =
          (value / maxValue) *
              chartHeight;

      final double centerX =
          size.width /
              data.length *
              i +
              size.width /
                  data.length /
                  2;

      final Rect rect =
      Rect.fromLTWH(
        centerX -
            barWidth / 2,
        chartHeight -
            barHeight,
        barWidth,
        barHeight,
      );

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          rect,
          const Radius.circular(
            7,
          ),
        ),
        barPaint,
      );

      textPainter.text =
          TextSpan(
            text:
            data[i]['day'].toString(),

            style:
            const TextStyle(
              color:
              Color(0xFF93C5FD),
              fontSize: 9,
            ),
          );

      textPainter.layout();

      textPainter.paint(
        canvas,
        Offset(
          centerX -
              textPainter.width /
                  2,
          size.height - 17,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(
      covariant WeeklyBarChartPainter
      oldDelegate,
      ) {
    return true;
  }
}