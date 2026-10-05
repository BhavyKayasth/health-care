import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../health_tracker/screens/health_tracker_screen.dart';
import '../../step_counter/screen/step_counter_screen.dart';
import '../../step_counter/widgets/step_counter_card.dart';
import 'vital_card.dart';

class HealthMetrics extends ConsumerWidget {
  const HealthMetrics({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 28),

          //------------------------------------------------
          // HEADER
          //------------------------------------------------

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Health Metrics",
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBlue,
                ),
              ),

              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                      const HealthTrackerScreen(),
                    ),
                  );
                },
                child: const Row(
                  children: [
                    Text("Track Now"),
                    SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          //------------------------------------------------
          // STEP COUNTER
          //------------------------------------------------

          StepCounterCard(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const StepCounterScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          //------------------------------------------------
          // VITAL CARDS
          //------------------------------------------------

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: .95,
            children: [
              VitalCard(
                color1: Colors.red,
                color2: Colors.redAccent,
                icon: LucideIcons.heartPulse,
                value: "72",
                title: "BPM • Heart Rate",
                subtitle: "Normal range",
                onTap: () {},
              ),
              VitalCard(
                color1: Colors.deepPurple,
                color2: Colors.purple,
                icon: LucideIcons.activity,
                value: "98%",
                title: "SpO2 • Blood Oxygen",
                subtitle: "Excellent",
                onTap: () {},
              ),
              VitalCard(
                color1: Colors.indigo,
                color2: Colors.deepPurple,
                icon: LucideIcons.moon,
                value: "7h 23m",
                title: "Last Night Sleep",
                subtitle: "Good quality",
                onTap: () {},
              ),
              VitalCard(
                color1: Colors.cyan,
                color2: Colors.blue,
                icon: LucideIcons.droplets,
                value: "5/8",
                title: "Hydration",
                subtitle: "1250 ml today",
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}