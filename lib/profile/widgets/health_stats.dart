import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class HealthStats extends StatelessWidget {
  final String bloodGroup;
  final String age;
  final String height;
  final String weight;

  const HealthStats({
    super.key,
    required this.bloodGroup,
    required this.age,
    required this.height,
    required this.weight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),

        const SizedBox(height: 18),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _HealthStat(
              icon: LucideIcons.heart,
              iconColor: Colors.red,
              value: bloodGroup,
              label: "Blood",
            ),
            _HealthStat(
              icon: LucideIcons.calendar,
              iconColor: Colors.purple,
              value: age,
              label: "Age",
            ),
            _HealthStat(
              icon: LucideIcons.activity,
              iconColor: Colors.green,
              value: height,
              label: "Height",
            ),
            _HealthStat(
              icon: LucideIcons.activity,
              iconColor: Colors.orange,
              value: weight,
              label: "Weight",
            ),
          ],
        ),
      ],
    );
  }
}

class _HealthStat extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _HealthStat({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: iconColor,
          size: 24,
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF94A3B8),
          ),
        ),
      ],
    );
  }
}