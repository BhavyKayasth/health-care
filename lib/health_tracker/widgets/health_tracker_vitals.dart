import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class HealthTrackerVitals extends StatelessWidget {
  const HealthTrackerVitals({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.02,

      children: [
        _vitalCard(
          icon: LucideIcons.wind,
          title: 'Blood Oxygen',
          value: '98%',
          subtitle: 'SpO2 · Normal',
          colors: const [Color(0xFF8B5CF6), Color(0xFF9333EA)],
          progress: .98,
        ),

        _vitalCard(
          icon: LucideIcons.thermometer,
          title: 'Body Temp',
          value: '98.6°F',
          subtitle: 'Normal range',
          colors: const [Color(0xFFF59E0B), Color(0xFFF97316)],
          progress: .70,
        ),

        _vitalCard(
          icon: LucideIcons.activity,
          title: 'Blood Pressure',
          value: '120/80',
          subtitle: 'mmHg · Normal',
          colors: const [Color(0xFF0EA5E9), Color(0xFF2563EB)],
          progress: .75,
        ),

        _vitalCard(
          icon: LucideIcons.scale,
          title: 'BMI',
          value: '22.4',
          subtitle: 'Normal weight',
          colors: const [Color(0xFF14B8A6), Color(0xFF059669)],
          progress: .55,
        ),
      ],
    );
  }

  Widget _vitalCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required List<Color> colors,
    required double progress,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Icon(icon, color: Colors.white, size: 21),

          const SizedBox(height: 8),

          Text(
            title,

            style: const TextStyle(color: Color(0xFFEDE9FE), fontSize: 10),
          ),

          const SizedBox(height: 2),

          Text(
            value,

            style: const TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
            subtitle,

            style: const TextStyle(color: Color(0xFFEDE9FE), fontSize: 9),
          ),

          const Spacer(),

          LinearProgressIndicator(
            value: progress,
            minHeight: 5,

            backgroundColor: Colors.white.withOpacity(0.20),

            valueColor: AlwaysStoppedAnimation(Colors.white.withOpacity(0.60)),
          ),
        ],
      ),
    );
  }
}
