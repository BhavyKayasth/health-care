import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../controller/subscription_payment_controller.dart';
import '../model/subscription_models.dart';

class SubscriptionPaymentMethods
    extends StatelessWidget {
  final SubscriptionPaymentState state;
  final SubscriptionPaymentController
  controller;

  const SubscriptionPaymentMethods({
    super.key,
    required this.state,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Choose Payment Option',
            style: TextStyle(
              color: Color(0xFF1E3A8A),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),

        const SizedBox(height: 12),

        ...subscriptionPaymentMethods.map(
              (method) {
            final selected =
                state.selectedPaymentMethod ==
                    method.id;

            return Padding(
              padding:
              const EdgeInsets.only(
                bottom: 10,
              ),
              child: GestureDetector(
                onTap: () {
                  controller
                      .selectPaymentMethod(
                    method.id,
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding:
                  const EdgeInsets.all(14),
                  decoration:
                  BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.circular(
                      20,
                    ),
                    border: Border.all(
                      color: selected
                          ? const Color(
                        0xFFA855F7,
                      )
                          : const Color(
                        0xFFDCE8FF,
                      ),
                      width:
                      selected ? 2 : 1.5,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color:
                        Color(0x10000000),
                        blurRadius: 8,
                        offset:
                        Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration:
                        BoxDecoration(
                          color: selected
                              ? null
                              : const Color(
                            0xFFEFF6FF,
                          ),
                          gradient: selected
                              ? LinearGradient(
                            colors:
                            method.colors,
                          )
                              : null,
                          borderRadius:
                          BorderRadius
                              .circular(
                            16,
                          ),
                        ),
                        child: Icon(
                          method.icon,
                          color: selected
                              ? Colors.white
                              : const Color(
                            0xFF2563EB,
                          ),
                          size: 25,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    method.name,
                                    style:
                                    const TextStyle(
                                      color:
                                      Color(
                                        0xFF1E3A8A,
                                      ),
                                      fontWeight:
                                      FontWeight
                                          .bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),

                                if (method.popular)
                                  Container(
                                    margin:
                                    const EdgeInsets
                                        .only(
                                      left: 6,
                                    ),
                                    padding:
                                    const EdgeInsets
                                        .symmetric(
                                      horizontal: 7,
                                      vertical: 3,
                                    ),
                                    decoration:
                                    BoxDecoration(
                                      gradient:
                                      const LinearGradient(
                                        colors: [
                                          Color(
                                            0xFFFACC15,
                                          ),
                                          Color(
                                            0xFFF97316,
                                          ),
                                        ],
                                      ),
                                      borderRadius:
                                      BorderRadius
                                          .circular(
                                        20,
                                      ),
                                    ),
                                    child:
                                    const Text(
                                      'Popular',
                                      style:
                                      TextStyle(
                                        color:
                                        Colors.white,
                                        fontSize: 8,
                                        fontWeight:
                                        FontWeight
                                            .bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),

                            const SizedBox(height: 4),

                            Text(
                              method.subtitle,
                              style:
                              const TextStyle(
                                color:
                                Color(
                                  0xFF3B82F6,
                                ),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),

                      if (selected)
                        Container(
                          width: 28,
                          height: 28,
                          decoration:
                          BoxDecoration(
                            gradient:
                            LinearGradient(
                              colors:
                              method.colors,
                            ),
                            shape:
                            BoxShape.circle,
                          ),
                          child: const Icon(
                            LucideIcons.check,
                            color:
                            Colors.white,
                            size: 16,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}