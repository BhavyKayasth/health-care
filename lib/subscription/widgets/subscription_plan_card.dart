import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../model/subscription_models.dart';


class SubscriptionPlanCard extends StatelessWidget {
  final SubscriptionPlanData plan;
  final bool selected;
  final VoidCallback onTap;

  const SubscriptionPlanCard({
    super.key,
    required this.plan,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(
          bottom: 14,
        ),
        padding: const EdgeInsets.all(19),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
          BorderRadius.circular(26),
          border: Border.all(
            color: selected
                ? const Color(0xFFA855F7)
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x15000000),
              blurRadius: 12,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  gradient:
                  LinearGradient(
                    colors: plan.colors,
                  ),
                  borderRadius:
                  BorderRadius.circular(20),
                ),
                child: Text(
                  plan.badge,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ),
            ),

            if (plan.savings != null)
              Positioned(
                top: 34,
                right: 0,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration:
                  BoxDecoration(
                    color:
                    const Color(0xFF22C55E),
                    borderRadius:
                    BorderRadius.circular(
                      20,
                    ),
                  ),
                  child: Text(
                    plan.savings!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ),
              ),

            Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                if (selected)
                  Container(
                    width: 30,
                    height: 30,
                    decoration:
                    const BoxDecoration(
                      gradient:
                      LinearGradient(
                        colors: [
                          Color(0xFFA855F7),
                          Color(0xFFEC4899),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LucideIcons.check,
                      color: Colors.white,
                      size: 17,
                    ),
                  ),

                SizedBox(
                  height: selected ? 8 : 0,
                ),

                Text(
                  plan.name,
                  style: const TextStyle(
                    color: Color(0xFF1E3A8A),
                    fontSize: 19,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 7),

                Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.end,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) {
                        return const LinearGradient(
                          colors: [
                            Color(0xFF9333EA),
                            Color(0xFFEC4899),
                          ],
                        ).createShader(bounds);
                      },
                      child: Text(
                        plan.price,
                        style:
                        const TextStyle(
                          color: Colors.white,
                          fontSize: 38,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(width: 4),

                    Padding(
                      padding:
                      const EdgeInsets.only(
                        bottom: 5,
                      ),
                      child: Text(
                        plan.period,
                        style: const TextStyle(
                          color:
                          Color(0xFF3B82F6),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                ...plan.features.map(
                      (feature) {
                    return Padding(
                      padding:
                      const EdgeInsets.only(
                        bottom: 7,
                      ),
                      child: Row(
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration:
                            const BoxDecoration(
                              color:
                              Color(0xFFDCFCE7),
                              shape:
                              BoxShape.circle,
                            ),
                            child:
                            const Icon(
                              LucideIcons.check,
                              size: 12,
                              color:
                              Color(
                                0xFF16A34A,
                              ),
                            ),
                          ),

                          const SizedBox(
                            width: 8,
                          ),

                          Expanded(
                            child: Text(
                              feature,
                              style:
                              const TextStyle(
                                color:
                                Color(
                                  0xFF2563EB,
                                ),
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}