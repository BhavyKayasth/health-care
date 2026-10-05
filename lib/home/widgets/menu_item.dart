import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class MenuItemWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDanger;
  final bool isLast;

  const MenuItemWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDanger = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 15,
        ),
        decoration: BoxDecoration(
          color: isDanger
              ? AppColors.lightRed
              : Colors.transparent,
          border: isLast
              ? null
              : const Border(
            bottom: BorderSide(
              color: AppColors.border,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 21,
              color: isDanger
                  ? AppColors.red
                  : AppColors.primary,
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDanger
                      ? AppColors.red
                      : AppColors.darkBlue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}