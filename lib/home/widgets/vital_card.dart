import 'package:flutter/material.dart';

class VitalCard extends StatelessWidget {
  const VitalCard({
    super.key,
    required this.color1,
    required this.color2,
    required this.icon,
    required this.value,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final Color color1;
  final Color color2;
  final IconData icon;

  final String value;
  final String title;
  final String subtitle;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: LinearGradient(
            colors: [
              color1,
              color2,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: Colors.white.withOpacity(.9),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withOpacity(.75),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}