import 'package:flutter/material.dart';

import '../model/subscription_models.dart';


class SubscriptionPriceSummary
    extends StatelessWidget {
  final SubscriptionPlanData plan;

  const SubscriptionPriceSummary({
    super.key,
    required this.plan,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF5FF),
        border: Border.all(
          color: const Color(0xFFE9D5FF),
          width: 1.5,
        ),
        borderRadius:
        BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          _Row(
            title: 'Subscription Fee',
            value:
            '₹${plan.amount}',
          ),

          const SizedBox(height: 7),

          const _Row(
            title: 'Platform Fee',
            value: 'FREE',
            valueColor:
            Color(0xFF16A34A),
          ),

          if (plan.savings != null) ...[
            const SizedBox(height: 7),
            const _Row(
              title: 'You Save',
              value: '₹100',
              valueColor:
              Color(0xFF16A34A),
            ),
          ],

          const Padding(
            padding:
            EdgeInsets.symmetric(
              vertical: 9,
            ),
            child: Divider(
              color: Color(0xFFE9D5FF),
            ),
          ),

          _Row(
            title: 'Total Amount',
            value: '₹${plan.amount}',
            bold: true,
            large: true,
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String title;
  final String value;
  final Color valueColor;
  final bool bold;
  final bool large;

  const _Row({
    required this.title,
    required this.value,
    this.valueColor =
    const Color(0xFF7E22CE),
    this.bold = false,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: bold
                ? const Color(0xFF581C87)
                : const Color(0xFF9333EA),
            fontSize: large ? 13 : 11,
            fontWeight: bold
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: large ? 20 : 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}