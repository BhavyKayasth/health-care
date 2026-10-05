import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../models/quick_action_model.dart';

class QuickActionCard extends StatefulWidget {
  final QuickActionModel action;
  final VoidCallback onTap;

  const QuickActionCard({
    super.key,
    required this.action,
    required this.onTap,
  });

  @override
  State<QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<QuickActionCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 150),
        scale: _pressed ? 0.96 : 1,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: const [
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Icon
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          gradient: LinearGradient(
                            colors: widget.action.gradient,
                          ),
                        ),
                        child: Icon(
                          widget.action.icon,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),

                      if (widget.action.isPremium)
                        Positioned(
                          right: -3,
                          bottom: -3,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: AppColors.yellow,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              LucideIcons.lock,
                              color: Colors.white,
                              size: 11,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  Text(
                    widget.action.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkBlue,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    widget.action.subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: widget.action.isPremium
                          ? AppColors.purple
                          : AppColors.textGrey,
                      fontWeight: widget.action.isPremium
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ],
              ),

              /// Premium Crown
              if (widget.action.isPremium)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.yellow,
                          AppColors.orange,
                        ],
                      ),
                    ),
                    child: const Icon(
                      LucideIcons.crown,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),

              /// Arrow
              const Positioned(
                bottom: 0,
                right: 0,
                child: Icon(
                  LucideIcons.chevronRight,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}