import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../controller/home_controller.dart';
import 'health_score_card.dart';
import 'popup_menu.dart';

class HomeHeader extends ConsumerStatefulWidget {
  const HomeHeader({super.key});

  @override
  ConsumerState<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends ConsumerState<HomeHeader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  // ============================================================
  // GET CURRENT USER NAME
  // ============================================================

  String _getUserName() {
    final User? user = FirebaseAuth.instance.currentUser;

    final displayName = user?.displayName?.trim();

    if (displayName != null && displayName.isNotEmpty) {
      return displayName;
    }

    // Fallback if displayName is unavailable.
    final email = user?.email?.trim();

    if (email != null && email.isNotEmpty) {
      final emailName = email.split('@').first.trim();

      if (emailName.isNotEmpty) {
        return emailName;
      }
    }

    return 'User';
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(
      homeControllerProvider.notifier,
    );

    final state = ref.watch(
      homeControllerProvider,
    );

    final userName = _getUserName();

    return Container(
      padding: const EdgeInsets.fromLTRB(
        24,
        56,
        24,
        28,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.secondary,
          ],
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(40),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Good Morning,',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),

                          const SizedBox(
                            height: 6,
                          ),

                          Text(
                            userName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ==========================================
                    // NOTIFICATION
                    // ==========================================

                    Stack(
                      children: [
                        _CircleButton(
                          icon: LucideIcons.bell,
                          onTap: () {},
                        ),

                        Positioned(
                          right: 10,
                          top: 10,
                          child: ScaleTransition(
                            scale: Tween<double>(
                              begin: 1.0,
                              end: 1.5,
                            ).animate(
                              _pulseController,
                            ),
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration:
                              const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      width: 12,
                    ),

                    // ==========================================
                    // MENU BUTTON
                    // ==========================================

                    AnimatedRotation(
                      turns: state.showMenu ? 0.25 : 0,
                      duration:
                      const Duration(
                        milliseconds: 250,
                      ),
                      child: _CircleButton(
                        icon:
                        LucideIcons.ellipsisVertical,
                        onTap:
                        controller.toggleMenu,
                      ),
                    ),
                  ],
                ),

                // ==============================================
                // POPUP MENU
                // ==============================================

                if (state.showMenu)
                  const Positioned(
                    top: 60,
                    right: 0,
                    child: PopupMenuWidget(),
                  ),
              ],
            ),

            const SizedBox(
              height: 28,
            ),

            // ================================================
            // HEALTH SCORE
            // ================================================

            HealthScoreCard(
              onTap: controller.openHealthScore,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// CIRCLE BUTTON
// ============================================================

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white24,
      shape: const CircleBorder(),
      child: InkWell(
        borderRadius:
        BorderRadius.circular(100),
        onTap: onTap,
        child: SizedBox(
          width: 46,
          height: 46,
          child: Icon(
            icon,
            color: Colors.white,
            size: 22,
          ),
        ),
      ),
    );
  }
}