import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_care/chat/screens/chat_screen.dart';
import 'package:health_care/home/screens/doctor_call_list_screen.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../medicines/screens/medicines_screen.dart';
import '../../symptoms/screen/symptoms_analyzer_screen.dart';
import '../models/quick_action_model.dart';
import 'quick_action_card.dart';

class QuickActions extends ConsumerWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = [
      QuickActionModel(
        icon: LucideIcons.messageSquare,
        title: "AI Consult",
        subtitle: "Chat with AI",
        gradient: const [
          AppColors.primary,
          AppColors.secondary,
        ],
        action: "chat",
      ),

      QuickActionModel(
        icon: LucideIcons.phone,
        title: "Idar Directory",
        subtitle: "Premium ₹50/mo",
        gradient: const [
          AppColors.purple,
          AppColors.pink,
        ],
        action: "doctorCall",
        isPremium: true,
      ),

      QuickActionModel(
        icon: LucideIcons.pill,
        title: "Medicines",
        subtitle: "Track meds",
        gradient: const [
          AppColors.orange,
          AppColors.red,
        ],
        action: "medicines",
      ),

      QuickActionModel(
        icon: LucideIcons.activity,
        title: "Symptoms",
        subtitle: "Check symptoms",
        gradient: const [
          AppColors.green,
          AppColors.teal,
        ],
        action: "symptoms",
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Quick Actions",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBlue,
                ),
              ),
              Icon(
                LucideIcons.chevronRight,
                color: AppColors.primary,
              ),
            ],
          ),

          const SizedBox(height: 18),

          GridView.builder(
            shrinkWrap: true,
            physics:
            const NeverScrollableScrollPhysics(),
            itemCount: actions.length,
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: .95,
            ),
            itemBuilder: (context, index) {
              final action = actions[index];

              return QuickActionCard(
                action: action,
                onTap: () {
                  switch (action.action) {
                  // ==================================================
                  // AI CHAT
                  // ==================================================

                    case "chat":
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(
                            onBack: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      );
                      break;

                  // ==================================================
                  // DOCTOR CALL LIST
                  // ==================================================

                    case "doctorCall":
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              DoctorCallListScreen(
                                onBack: () {
                                  Navigator.pop(context);
                                },
                              ),
                        ),
                      );
                      break;

                  // ==================================================
                  // MEDICINES
                  // ==================================================

                    case "medicines":
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              MedicinesScreen(
                                onBack: () {
                                  Navigator.pop(context);
                                },
                              ),
                        ),
                      );
                      break;

                  // ==================================================
                  // SYMPTOMS
                  // ==================================================

                    case "symptoms":
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              SymptomsAnalyzerScreen(
                                onBack: () {
                                  Navigator.pop(context);
                                },
                              ),
                        ),
                      );
                      break;
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}