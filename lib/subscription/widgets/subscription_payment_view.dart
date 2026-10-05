import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../controller/subscription_payment_controller.dart';
import '../model/subscription_models.dart';
import 'subscription_payment_methods.dart';
import 'subscription_price_summary.dart';
import 'subscription_security_badge.dart';

class SubscriptionPaymentView
    extends StatelessWidget {
  final SubscriptionPaymentState state;
  final SubscriptionPaymentController
  controller;
  final VoidCallback onPayment;

  const SubscriptionPaymentView({
    super.key,
    required this.state,
    required this.controller,
    required this.onPayment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //----------------------------------------------------
        // HEADER
        //----------------------------------------------------

        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(
            20,
            18,
            20,
            22,
          ),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFA855F7),
                Color(0xFFEC4899),
              ],
            ),
            borderRadius:
            BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed:
                  controller.backToPlans,
                  icon: const Icon(
                    LucideIcons.arrowLeft,
                    color: Colors.white,
                  ),
                ),
              ),

              Container(
                width: 72,
                height: 72,
                decoration:
                BoxDecoration(
                  color: Colors.white
                      .withOpacity(.20),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.creditCard,
                  color: Colors.white,
                  size: 35,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Select Payment Method',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                state.plan.period ==
                    '/month'
                    ? '₹50/month'
                    : '₹500/year',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),

        //----------------------------------------------------
        // CONTENT
        //----------------------------------------------------

        Expanded(
          child: SingleChildScrollView(
            padding:
            const EdgeInsets.fromLTRB(
              20,
              16,
              20,
              20,
            ),
            child: Column(
              children: [
                _PlanSummary(
                  state: state,
                ),

                const SizedBox(height: 18),

                SubscriptionPaymentMethods(
                  state: state,
                  controller: controller,
                ),

                const SizedBox(height: 18),

                const SubscriptionSecurityBadge(),

                const SizedBox(height: 14),

                SubscriptionPriceSummary(
                  plan: state.plan,
                ),

                const SizedBox(height: 14),

                const _BenefitsReminder(),
              ],
            ),
          ),
        ),

        //----------------------------------------------------
        // PAY BUTTON
        //----------------------------------------------------

        Padding(
          padding:
          const EdgeInsets.fromLTRB(
            20,
            8,
            20,
            16,
          ),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
              state.selectedPaymentMethod ==
                  null ||
                  state.isProcessing
                  ? null
                  : onPayment,
              style:
              ElevatedButton.styleFrom(
                backgroundColor:
                const Color(0xFFA855F7),
                foregroundColor:
                Colors.white,
                disabledBackgroundColor:
                const Color(0xFFE2E8F0),
                padding:
                const EdgeInsets.symmetric(
                  vertical: 16,
                ),
                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(20),
                ),
              ),
              child: state.isProcessing
                  ? const Row(
                mainAxisAlignment:
                MainAxisAlignment
                    .center,
                children: [
                  SizedBox(
                    width: 21,
                    height: 21,
                    child:
                    CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color:
                      Colors.white,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Processing Payment...',
                    style:
                    TextStyle(
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ],
              )
                  : Text(
                'Pay ₹${state.plan.amount} Now',
                style:
                const TextStyle(
                  fontSize: 16,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PlanSummary extends StatelessWidget {
  final SubscriptionPaymentState state;

  const _PlanSummary({
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final yearly =
        state.selectedPlan ==
            SubscriptionPlan.yearly;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE9D5FF),
          width: 1.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                LucideIcons.crown,
                color: Color(0xFF9333EA),
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  state.plan.name,
                  style:
                  const TextStyle(
                    color:
                    Color(0xFF581C87),
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '₹${state.plan.amount}',
                style:
                const TextStyle(
                  color:
                  Color(0xFF9333EA),
                  fontWeight:
                  FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),

          if (yearly) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding:
              const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 10,
              ),
              decoration:
              BoxDecoration(
                color:
                const Color(0xFFDCFCE7),
                borderRadius:
                BorderRadius.circular(
                  10,
                ),
              ),
              child: const Text(
                "🎉 You're saving ₹100 with the yearly plan!",
                textAlign:
                TextAlign.center,
                style:
                TextStyle(
                  color:
                  Color(0xFF15803D),
                  fontSize: 10,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),
            ),
          ],

          const SizedBox(height: 10),

          ...const [
            'Access to 60+ verified doctors',
            'Emergency video consultations',
            '24/7 phone support',
          ].map(
                (feature) => Padding(
              padding:
              const EdgeInsets.only(
                bottom: 5,
              ),
              child: Row(
                children: [
                  Icon(
                    LucideIcons.check,
                    size: 14,
                    color:
                    Color(0xFF16A34A),
                  ),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      feature,
                      style:
                      TextStyle(
                        color:
                        Color(0xFF2563EB),
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BenefitsReminder
    extends StatelessWidget {
  const _BenefitsReminder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient:
        const LinearGradient(
          colors: [
            Color(0xFFFACC15),
            Color(0xFFF97316),
          ],
        ),
        borderRadius:
        BorderRadius.circular(18),
      ),
      child: const Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                LucideIcons.crown,
                color: Colors.white,
                size: 19,
              ),
              SizedBox(width: 7),
              Text(
                'What You Get:',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight:
                  FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          SizedBox(height: 7),
          Text(
            '✓ Access to 60+ verified doctors\n'
                '✓ Emergency video consultations\n'
                '✓ 24/7 phone support\n'
                '✓ Instant directory unlocking',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}