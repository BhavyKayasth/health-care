import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'health_tracker_components.dart';

class HealthTrackerWeeklySteps extends StatefulWidget {
  final List<Map<String, dynamic>> data;

  const HealthTrackerWeeklySteps({super.key, required this.data});

  @override
  State<HealthTrackerWeeklySteps> createState() =>
      _HealthTrackerWeeklyStepsState();
}

class _HealthTrackerWeeklyStepsState extends State<HealthTrackerWeeklySteps> {
  int? selectedIndex;

  Timer? _holdTimer;

  @override
  void didUpdateWidget(covariant HealthTrackerWeeklySteps oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (selectedIndex != null) {
      if (selectedIndex! >= widget.data.length ||
          widget.data[selectedIndex!]['steps'] is! num) {
        selectedIndex = null;
      }
    }
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //----------------------------------------------------------
    // ONLY DAYS WITH REAL DATA
    //----------------------------------------------------------

    final actualData = widget.data.where((item) => item['steps'] is num);

    //----------------------------------------------------------
    // WEEKLY TOTAL
    //----------------------------------------------------------

    final int weeklyTotal = actualData.fold<int>(0, (sum, item) {
      return sum + (item['steps'] as num).toInt();
    });

    //----------------------------------------------------------
    // AVERAGE
    //----------------------------------------------------------

    final int average = actualData.isEmpty
        ? 0
        : (weeklyTotal / actualData.length).round();

    //----------------------------------------------------------
    // BEST DAY
    //----------------------------------------------------------

    int bestSteps = -1;
    String bestDay = '-';

    for (final item in actualData) {
      final int steps = (item['steps'] as num).toInt();

      if (steps > bestSteps) {
        bestSteps = steps;
        bestDay = item['day']?.toString() ?? '-';
      }
    }

    //----------------------------------------------------------
    // GRAPH SCALE
    //----------------------------------------------------------

    final int maxSteps = _calculateMaxSteps();

    //----------------------------------------------------------
    // SELECTED BAR
    //----------------------------------------------------------

    Map<String, dynamic>? selectedData;

    if (selectedIndex != null &&
        selectedIndex! >= 0 &&
        selectedIndex! < widget.data.length) {
      final item = widget.data[selectedIndex!];

      if (item['steps'] is num) {
        selectedData = item;
      }
    }

    return TrackerWhiteCard(
      child: Column(
        children: [
          //------------------------------------------------------
          // HEADER
          //------------------------------------------------------
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weekly Steps',
                      style: TextStyle(
                        color: AppColors.darkText,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Steps per day this week',
                      style: TextStyle(color: AppColors.greyText, fontSize: 10),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.10),
                  ),
                ),
                child: Text(
                  _weekLabel(),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          //------------------------------------------------------
          // CHART
          //------------------------------------------------------
          SizedBox(
            height: 190,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final int itemCount = widget.data.isEmpty
                    ? 1
                    : widget.data.length;

                final double cellWidth = constraints.maxWidth / itemCount;

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    //------------------------------------------------
                    // BARS
                    //------------------------------------------------
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: List.generate(widget.data.length, (index) {
                        final item = widget.data[index];

                        final int? steps = item['steps'] is num
                            ? (item['steps'] as num).toInt()
                            : null;

                        return Expanded(
                          child: _StepBar(
                            day: item['day']?.toString() ?? '-',
                            steps: steps,
                            maxSteps: maxSteps,
                            isSelected: selectedIndex == index,
                            onHoldStart: () {
                              _startHold(index);
                            },
                            onHoldEnd: _cancelHold,
                          ),
                        );
                      }),
                    ),

                    //------------------------------------------------
                    // TOOLTIP
                    //------------------------------------------------
                    if (selectedData != null)
                      Positioned(
                        top: 0,
                        left: _tooltipLeft(
                          selectedIndex!,
                          cellWidth,
                          constraints.maxWidth,
                        ),
                        child: Transform.translate(
                          offset: const Offset(-75, 0),
                          child: _StepTooltip(
                            day: selectedData['day'].toString(),
                            steps: (selectedData['steps'] as num).toInt(),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),

          const SizedBox(height: 2),

          //------------------------------------------------------
          // INSTRUCTION
          //------------------------------------------------------
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Hold a bar to view that day\'s steps',
              style: TextStyle(
                color: AppColors.greyText.withOpacity(.8),
                fontSize: 9,
              ),
            ),
          ),

          const SizedBox(height: 12),

          //------------------------------------------------------
          // DIVIDER
          //------------------------------------------------------
          const Divider(color: Color(0xFFEFF6FF), height: 1),

          const SizedBox(height: 14),

          //------------------------------------------------------
          // SUMMARY
          //------------------------------------------------------
          Row(
            children: [
              Expanded(
                child: WeeklyStat(
                  value: _formatNumber(weeklyTotal),
                  label: 'Weekly Steps',
                ),
              ),

              Container(width: 1, height: 32, color: const Color(0xFFEFF6FF)),

              Expanded(
                child: WeeklyStat(
                  value: _formatNumber(average),
                  label: 'Avg / Day',
                ),
              ),

              Container(width: 1, height: 32, color: const Color(0xFFEFF6FF)),

              Expanded(
                child: WeeklyStat(value: bestDay, label: 'Best Day'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //----------------------------------------------------------
  // HOLD START
  //----------------------------------------------------------

  void _startHold(int index) {
    _holdTimer?.cancel();

    _holdTimer = Timer(const Duration(milliseconds: 160), () {
      if (!mounted) return;

      if (index < 0 || index >= widget.data.length) {
        return;
      }

      final item = widget.data[index];

      // Future/empty days cannot be selected.
      if (item['steps'] is! num) {
        return;
      }

      setState(() {
        selectedIndex = index;
      });
    });
  }

  //----------------------------------------------------------
  // HOLD END
  //----------------------------------------------------------

  void _cancelHold() {
    _holdTimer?.cancel();
    _holdTimer = null;
  }

  //----------------------------------------------------------
  // TOOLTIP POSITION
  //----------------------------------------------------------

  double _tooltipLeft(int index, double cellWidth, double totalWidth) {
    final double center = (index * cellWidth) + (cellWidth / 2);

    // Tooltip width is approximately 150 px.
    // Keep it inside the chart.
    const double tooltipWidth = 150;

    final double minLeft = tooltipWidth / 2;
    final double maxLeft = totalWidth - (tooltipWidth / 2);

    return center.clamp(minLeft, maxLeft);
  }

  //----------------------------------------------------------
  // MAX STEPS
  //----------------------------------------------------------

  int _calculateMaxSteps() {
    int maxValue = 1000;

    for (final item in widget.data) {
      if (item['steps'] is! num) {
        continue;
      }

      final int value = (item['steps'] as num).toInt();

      maxValue = math.max(maxValue, value);
    }

    if (maxValue <= 4000) {
      return 4000;
    }

    if (maxValue <= 7500) {
      return 7500;
    }

    if (maxValue <= 10000) {
      return 10000;
    }

    if (maxValue <= 12000) {
      return 12000;
    }

    return ((maxValue / 2000).ceil()) * 2000;
  }

  //----------------------------------------------------------
  // WEEK LABEL
  //----------------------------------------------------------

  String _weekLabel() {
    final now = DateTime.now();

    final monday = DateTime(now.year, now.month, now.day - (now.weekday - 1));

    final sunday = monday.add(const Duration(days: 6));

    // Handles weeks that cross months correctly.
    if (monday.month == sunday.month) {
      return '${monday.day}-${sunday.day} '
          '${_monthName(monday.month)}';
    }

    return '${monday.day} ${_monthName(monday.month)} - '
        '${sunday.day} ${_monthName(sunday.month)}';
  }

  //----------------------------------------------------------
  // MONTH NAME
  //----------------------------------------------------------

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return months[month - 1];
  }

  //----------------------------------------------------------
  // NUMBER FORMAT
  //----------------------------------------------------------

  String _formatNumber(int value) {
    return value.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ',',
    );
  }
}

//==========================================================
// STEP BAR
//==========================================================

class _StepBar extends StatelessWidget {
  final String day;
  final int? steps;
  final int maxSteps;
  final bool isSelected;
  final VoidCallback onHoldStart;
  final VoidCallback onHoldEnd;

  const _StepBar({
    required this.day,
    required this.steps,
    required this.maxSteps,
    required this.isSelected,
    required this.onHoldStart,
    required this.onHoldEnd,
  });

  @override
  Widget build(BuildContext context) {
    final double ratio = steps == null || maxSteps <= 0
        ? 0
        : (steps! / maxSteps).clamp(0.0, 1.0);

    final double barHeight = 125 * ratio;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,

      onTapDown: (_) {
        if (steps != null) {
          onHoldStart();
        }
      },

      onTapUp: (_) {
        onHoldEnd();
      },

      onTapCancel: onHoldEnd,

      child: Column(
        children: [
          //----------------------------------------------------
          // BAR
          //----------------------------------------------------
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: steps == null
                  ? const SizedBox(width: 22)
                  : AnimatedContainer(
                      duration: const Duration(milliseconds: 120),
                      curve: Curves.easeOut,

                      width: isSelected ? 27 : 22,
                      height: barHeight,

                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF3B82F6), Color(0xFF06B6D4)],
                        ),

                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(7),
                        ),

                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(.25),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : null,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 8),

          //----------------------------------------------------
          // DAY
          //----------------------------------------------------
          Text(
            day,
            style: TextStyle(
              color: isSelected ? AppColors.darkText : AppColors.greyText,
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

//==========================================================
// TOOLTIP
//==========================================================

class _StepTooltip extends StatelessWidget {
  final String day;
  final int steps;

  const _StepTooltip({required this.day, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        children: [
          Container(
            constraints: const BoxConstraints(minWidth: 150),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x18000000),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${_formatNumber(steps)} steps',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' on $day',
                    style: const TextStyle(
                      color: AppColors.greyText,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          //----------------------------------------------------
          // ARROW
          //----------------------------------------------------
          ClipPath(
            clipper: _TooltipArrowClipper(),
            child: Container(width: 20, height: 10, color: Colors.white),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int value) {
    return value.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ',',
    );
  }
}

//==========================================================
// TOOLTIP ARROW
//==========================================================

class _TooltipArrowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
