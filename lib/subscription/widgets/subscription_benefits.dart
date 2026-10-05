import 'package:flutter/material.dart';

import '../model/subscription_models.dart';


class SubscriptionBenefits extends StatelessWidget {
  const SubscriptionBenefits({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics:
      const NeverScrollableScrollPhysics(),
      itemCount: subscriptionBenefits.length,
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.15,
      ),
      itemBuilder: (context, index) {
        final benefit =
        subscriptionBenefits[index];

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
            BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFDCE8FF),
              width: 1.5,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0C000000),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  gradient:
                  const LinearGradient(
                    colors: [
                      Color(0xFF3B82F6),
                      Color(0xFF06B6D4),
                    ],
                  ),
                  borderRadius:
                  BorderRadius.circular(14),
                ),
                child: Icon(
                  benefit.icon,
                  color: Colors.white,
                  size: 23,
                ),
              ),

              const SizedBox(height: 9),

              Text(
                benefit.title,
                style: const TextStyle(
                  color: Color(0xFF1E3A8A),
                  fontSize: 13,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                benefit.description,
                maxLines: 2,
                overflow:
                TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF3B82F6),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}