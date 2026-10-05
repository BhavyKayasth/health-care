import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../models/bottom_nav_item.dart';

class AppBottomNavigation extends StatelessWidget {
  final String activeTab;
  final ValueChanged<String> onTabChanged;

  const AppBottomNavigation({
    super.key,
    required this.activeTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    const items = [
      BottomNavItem(
        id: "home",
        label: "Home",
        icon: LucideIcons.house,
      ),
      BottomNavItem(
        id: "chat",
        label: "Chat",
        icon: LucideIcons.messageCircle,
      ),
      BottomNavItem(
        id: "nearby",
        label: "Nearby",
        icon: LucideIcons.mapPin,
      ),
      BottomNavItem(
        id: "appointments",
        label: "Schedule",
        icon: LucideIcons.calendar,
      ),
      BottomNavItem(
        id: "profile",
        label: "Profile",
        icon: LucideIcons.user,
      ),
    ];

    return Material(
      elevation: 18,
      color: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 25,
              offset: Offset(0, -5),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 14,
        ),
        child: SafeArea(
          top: false,
          bottom: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: items.map((item) {
              final selected = activeTab == item.id;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onTabChanged(item.id),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOutBack,
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: selected
                                ? const LinearGradient(
                              colors: [
                                AppColors.primary,
                                AppColors.secondary,
                              ],
                            )
                                : null,
                          ),
                          child: Icon(
                            item.icon,
                            size: 24,
                            color: selected
                                ? Colors.white
                                : AppColors.textGrey,
                          ),
                        ),

                        const SizedBox(height: 5),

                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 250),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: selected
                                ? AppColors.primary
                                : AppColors.textGrey,
                          ),
                          child: Text(item.label),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}