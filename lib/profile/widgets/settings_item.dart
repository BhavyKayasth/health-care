import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? badge;
  final VoidCallback? onTap;
  final bool showDivider;
  final Color iconColor;

  const SettingsItem({
    super.key,
    required this.icon,
    required this.title,
    this.badge,
    this.onTap,
    this.showDivider = true,
    this.iconColor = const Color(0xFF3B82F6),
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 16,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: iconColor,
                  size: 22,
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ),

                if (badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      badge!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                if (badge != null)
                  const SizedBox(width: 10),

                const Icon(
                  LucideIcons.chevronRight,
                  color: Color(0xFF94A3B8),
                  size: 20,
                ),
              ],
            ),
          ),

          if (showDivider)
            const Divider(
              height: 1,
              indent: 54,
              endIndent: 18,
            ),
        ],
      ),
    );
  }
}