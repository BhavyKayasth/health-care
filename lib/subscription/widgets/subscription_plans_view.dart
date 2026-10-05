import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../controller/subscription_payment_controller.dart';
import '../model/subscription_models.dart';
import 'subscription_benefits.dart';
import 'subscription_plan_card.dart';

class SubscriptionPlansView
    extends StatelessWidget {
  final SubscriptionPaymentState state;
  final SubscriptionPaymentController
  controller;

  const SubscriptionPlansView({
    super.key,
    required this.state,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final amount = state.plan.amount;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        20,
        0,
        20,
        25,
      ),
      child: Column(
        children: [
          //--------------------------------------------------
          // PREMIUM HERO
          //--------------------------------------------------

          const _PremiumHero(),

          const SizedBox(height: 20),

          //--------------------------------------------------
          // BENEFITS
          //--------------------------------------------------

          const SubscriptionBenefits(),

          const SizedBox(height: 24),

          const Text(
            'Choose Your Plan',
            style: TextStyle(
              color: Color(0xFF1E3A8A),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 14),

          //--------------------------------------------------
          // PLANS
          //--------------------------------------------------

          ...subscriptionPlans.map(
                (plan) => SubscriptionPlanCard(
              plan: plan,
              selected:
              state.selectedPlan ==
                  plan.id,
              onTap: () {
                controller.selectPlan(
                  plan.id,
                );
              },
            ),
          ),

          //--------------------------------------------------
          // UNLOCK BUTTON
          //--------------------------------------------------

          const SizedBox(height: 2),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
              controller.proceedToPayment,
              style:
              ElevatedButton.styleFrom(
                backgroundColor:
                const Color(0xFFA855F7),
                foregroundColor:
                Colors.white,
                padding:
                const EdgeInsets.symmetric(
                  vertical: 17,
                ),
                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(20),
                ),
                elevation: 7,
              ),
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  const Icon(
                    LucideIcons.unlock,
                    size: 21,
                  ),
                  const SizedBox(width: 9),
                  Text(
                    'Unlock Now - ₹$amount',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 9),
                  const Icon(
                    LucideIcons.zap,
                    size: 21,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          Container(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              border: Border.all(
                color: const Color(0xFFFDE68A),
              ),
              borderRadius:
              BorderRadius.circular(16),
            ),
            child: const Row(
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: [
                Icon(
                  LucideIcons.star,
                  color: Color(0xFFEAB308),
                  size: 18,
                ),
                SizedBox(width: 7),
                Text(
                  '30-Day Money Back Guarantee',
                  style: TextStyle(
                    color: Color(0xFF854D0E),
                    fontSize: 12,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            'Cancel anytime • No hidden fees • Secure payment',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF60A5FA),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumHero extends StatelessWidget {
  const _PremiumHero();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 92,
          height: 92,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFACC15),
                Color(0xFFF97316),
              ],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0x40F97316),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            LucideIcons.crown,
            color: Colors.white,
            size: 46,
          ),
        ),

        const SizedBox(height: 18),

        ShaderMask(
          shaderCallback: (bounds) {
            return const LinearGradient(
              colors: [
                Color(0xFF9333EA),
                Color(0xFFEC4899),
              ],
            ).createShader(bounds);
          },
          child: const Text(
            'Unlock Premium Access',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 7),

        const Text(
          'Get instant access to 60+ verified doctors',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF2563EB),
            fontSize: 13,
          ),
        ),

        const SizedBox(height: 8),

        const Row(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.lockKeyhole,
              color: Colors.red,
              size: 15,
            ),
            SizedBox(width: 5),
            Text(
              'Currently Locked',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}