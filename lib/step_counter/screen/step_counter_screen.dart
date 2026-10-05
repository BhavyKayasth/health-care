import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../controller/step_controller.dart';

class StepCounterScreen extends ConsumerWidget {
  const StepCounterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(stepControllerProvider);

    final steps = state.steps;
    final goal = state.goal;
    final progress = state.progress;

    return Scaffold(
      backgroundColor: const Color(0xFF202124),

      //========================================================
      // APP BAR
      //========================================================
      appBar: AppBar(
        backgroundColor: const Color(0xFF202124),
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
        ),

        title: const Text(
          'Step Counter',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            onPressed: () {
              ref.read(stepControllerProvider.notifier).refresh();
            },
            icon: const Icon(LucideIcons.rotateCw, color: Colors.white),
          ),
        ],
      ),

      //========================================================
      // BODY
      //========================================================
      body: SafeArea(
        child: state.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF00D6A3)),
              )
            : !state.isAvailable
            ? _UnavailableView(
                onRetry: () {
                  ref.read(stepControllerProvider.notifier).refresh();
                },
              )
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                child: Column(
                  children: [
                    //==================================================
                    // DATE
                    //==================================================
                    const SizedBox(height: 10),

                    Text(
                      _todayDate(),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 28),

                    //==================================================
                    // MAIN CIRCLE
                    //==================================================
                    _MainStepCircle(
                      steps: steps,
                      goal: goal,
                      progress: progress,
                    ),

                    const SizedBox(height: 30),

                    //==================================================
                    // GOAL MESSAGE
                    //==================================================
                    Text(
                      steps >= goal
                          ? 'Daily goal completed! 🎉'
                          : '${_formatNumber(state.remainingSteps)} steps to go',
                      style: TextStyle(
                        color: steps >= goal
                            ? const Color(0xFF00D6A3)
                            : Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 30),

                    //==================================================
                    // LEGEND
                    //==================================================
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _LegendItem(
                          icon: LucideIcons.heart,
                          color: Color(0xFF00D6A3),
                          text: 'Heart Pts',
                        ),
                        SizedBox(width: 45),
                        _LegendItem(
                          icon: LucideIcons.footprints,
                          color: Color(0xFF6EA8FF),
                          text: 'Steps',
                        ),
                      ],
                    ),

                    const SizedBox(height: 35),

                    //==================================================
                    // STATISTICS
                    //==================================================
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            icon: LucideIcons.flame,
                            value: '${state.calories.round()}',
                            label: 'Cal',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            icon: LucideIcons.map,
                            value: state.distanceKm.toStringAsFixed(2),
                            label: 'km',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            icon: LucideIcons.clock3,
                            value: '${state.activeMinutes}',
                            label: 'Move Min',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    //==================================================
                    // DAILY GOAL
                    //==================================================
                    _DailyGoalCard(
                      steps: steps,
                      goal: goal,
                      progress: progress,
                    ),

                    const SizedBox(height: 18),

                    //==================================================
                    // ACTIVITY STATUS
                    //==================================================
                    _ActivityCard(isTracking: state.isAvailable),

                    const SizedBox(height: 18),

                    //==================================================
                    // INFORMATION
                    //==================================================
                    const _InfoCard(),

                    const SizedBox(height: 10),
                  ],
                ),
              ),
      ),
    );
  }

  //==========================================================
  // TODAY DATE
  //==========================================================

  String _todayDate() {
    final now = DateTime.now();

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

    return '${months[now.month - 1]} ${now.day}, ${now.year}';
  }

  //==========================================================
  // NUMBER FORMAT
  //==========================================================

  static String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ',',
    );
  }
}

//================================================================
// MAIN STEP CIRCLE
//================================================================

class _MainStepCircle extends StatelessWidget {
  const _MainStepCircle({
    required this.steps,
    required this.goal,
    required this.progress,
  });

  final int steps;
  final int goal;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 320,
      child: Stack(
        alignment: Alignment.center,
        children: [
          //======================================================
          // OUTER RING
          //======================================================
          SizedBox(
            width: 300,
            height: 300,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 18,
              backgroundColor: const Color(0xFF111214),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF00D6A3),
              ),
            ),
          ),

          //======================================================
          // INNER RING
          //======================================================
          SizedBox(
            width: 245,
            height: 245,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 14,
              backgroundColor: const Color(0xFF111214),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF6EA8FF),
              ),
            ),
          ),

          //======================================================
          // CENTER
          //======================================================
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _formatSteps(steps),
                style: const TextStyle(
                  color: Color(0xFF00D6A3),
                  fontSize: 66,
                  fontWeight: FontWeight.w300,
                  height: 1,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'steps',
                style: TextStyle(color: Colors.white70, fontSize: 17),
              ),

              const SizedBox(height: 12),

              Text(
                'Goal ${_formatSteps(goal)}',
                style: const TextStyle(color: Color(0xFF6EA8FF), fontSize: 15),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatSteps(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    }

    if (value >= 1000) {
      final result = (value / 1000).toStringAsFixed(1);

      if (result.endsWith('.0')) {
        return '${result.substring(0, result.length - 2)}k';
      }

      return '${result}k';
    }

    return value.toString();
  }
}

//================================================================
// LEGEND ITEM
//================================================================

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.icon,
    required this.color,
    required this.text,
  });

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 27),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

//================================================================
// STAT CARD
//================================================================

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: const Color(0xFF2A2B2E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF6EA8FF), size: 23),

          const SizedBox(height: 9),

          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            label,
            style: const TextStyle(color: Colors.white60, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

//================================================================
// DAILY GOAL CARD
//================================================================

class _DailyGoalCard extends StatelessWidget {
  const _DailyGoalCard({
    required this.steps,
    required this.goal,
    required this.progress,
  });

  final int steps;
  final int goal;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final percentage = (progress * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2B2E),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Daily Goal',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$percentage%',
                style: const TextStyle(
                  color: Color(0xFF6EA8FF),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 9,
              backgroundColor: const Color(0xFF404145),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF6EA8FF),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_formatNumber(steps)} steps',
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              Text(
                '${_formatNumber(goal)} steps',
                style: const TextStyle(color: Colors.white54, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ',',
    );
  }
}

//================================================================
// ACTIVITY CARD
//================================================================

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({required this.isTracking});

  final bool isTracking;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2B2E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF00D6A3).withOpacity(.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.footprints,
              color: Color(0xFF00D6A3),
              size: 25,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isTracking
                      ? "Step tracking active"
                      : "Step tracking inactive",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isTracking
                      ? "Your phone is tracking your steps."
                      : "Step tracking is currently unavailable.",
                  style: const TextStyle(color: Colors.white54, fontSize: 13),
                ),
              ],
            ),
          ),

          Icon(
            isTracking ? LucideIcons.circleCheck : LucideIcons.circleAlert,
            color: isTracking ? const Color(0xFF00D6A3) : Colors.orange,
            size: 24,
          ),
        ],
      ),
    );
  }
}

//================================================================
// INFO CARD
//================================================================

class _InfoCard extends StatelessWidget {
  const _InfoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF26272A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(LucideIcons.info, color: Color(0xFF6EA8FF), size: 22),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Steps are counted using your phone\'s built-in activity sensor. Keep your phone with you while walking for better accuracy.',
              style: TextStyle(
                color: Colors.white60,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//================================================================
// UNAVAILABLE VIEW
//================================================================

class _UnavailableView extends StatelessWidget {
  const _UnavailableView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              LucideIcons.footprints,
              color: Color(0xFF6EA8FF),
              size: 70,
            ),

            const SizedBox(height: 20),

            const Text(
              'Step Counter Unavailable',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'Your device may not support the required step sensor.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white60,
                fontSize: 14,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 25),

            ElevatedButton(onPressed: onRetry, child: const Text('Try Again')),
          ],
        ),
      ),
    );
  }
}
