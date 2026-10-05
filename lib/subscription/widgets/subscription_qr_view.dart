import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../controller/subscription_payment_controller.dart';
import '../model/subscription_models.dart';

class SubscriptionQrView
    extends StatelessWidget {
  final SubscriptionPaymentState state;
  final SubscriptionPaymentController
  controller;
  final VoidCallback onVerifyPayment;

  const SubscriptionQrView({
    super.key,
    required this.state,
    required this.controller,
    required this.onVerifyPayment,
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
                  controller.closeQrPayment,
                  icon: const Icon(
                    LucideIcons.arrowLeft,
                    color: Colors.white,
                  ),
                ),
              ),

              const Text(
                'Scan QR Code to Pay',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'Use any UPI app to complete payment',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),

        //----------------------------------------------------
        // QR CONTENT
        //----------------------------------------------------

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration:
                  BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.circular(
                      28,
                    ),
                    border: Border.all(
                      color:
                      const Color(
                        0xFFE9D5FF,
                      ),
                      width: 4,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color:
                        Color(
                          0x18000000,
                        ),
                        blurRadius: 18,
                        offset:
                        Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 240,
                        height: 240,
                        decoration:
                        BoxDecoration(
                          color:
                          const Color(
                            0xFFF3E8FF,
                          ),
                          borderRadius:
                          BorderRadius
                              .circular(
                            18,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            LucideIcons.qrCode,
                            size: 125,
                            color:
                            Color(
                              0xFFA855F7,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      Text(
                        '₹${state.plan.amount}',
                        style:
                        const TextStyle(
                          color:
                          Color(
                            0xFF1E3A8A,
                          ),
                          fontWeight:
                          FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        state.selectedPlan ==
                            SubscriptionPlan.monthly
                            ? 'Monthly Subscription'
                            : 'Yearly Subscription',
                        style:
                        const TextStyle(
                          color:
                          Color(
                            0xFF2563EB,
                          ),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                Container(
                  width: double.infinity,
                  padding:
                  const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color:
                    const Color(
                      0xFFFAF5FF,
                    ),
                    borderRadius:
                    BorderRadius.circular(
                      15,
                    ),
                  ),
                  child: const Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                    children: [
                      Text(
                        'How to pay:',
                        style:
                        TextStyle(
                          color:
                          Color(
                            0xFF581C87,
                          ),
                          fontWeight:
                          FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 7),
                      Text(
                        '1. Open any UPI app (GPay, PhonePe, Paytm)\n'
                            '2. Scan the QR code above\n'
                            '3. Enter your UPI PIN to complete payment\n'
                            '4. Premium access will be unlocked instantly',
                        style:
                        TextStyle(
                          color:
                          Color(
                            0xFF7E22CE,
                          ),
                          fontSize: 10,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                Container(
                  width: double.infinity,
                  padding:
                  const EdgeInsets.all(
                    12,
                  ),
                  decoration: BoxDecoration(
                    gradient:
                    const LinearGradient(
                      colors: [
                        Color(0xFFFACC15),
                        Color(0xFFF97316),
                      ],
                    ),
                    borderRadius:
                    BorderRadius.circular(
                      14,
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        LucideIcons.crown,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Get instant access to 60+ verified doctors!',
                          style:
                          TextStyle(
                            color:
                            Colors.white,
                            fontSize: 10,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        //----------------------------------------------------
        // VERIFY BUTTON
        //----------------------------------------------------

        Padding(
          padding:
          const EdgeInsets.fromLTRB(
            20,
            8,
            20,
            18,
          ),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: state.isProcessing
                  ? null
                  : onVerifyPayment,
              style:
              ElevatedButton.styleFrom(
                backgroundColor:
                const Color(0xFF16A34A),
                foregroundColor:
                Colors.white,
                disabledBackgroundColor:
                const Color(0xFFD1D5DB),
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
                    width: 20,
                    height: 20,
                    child:
                    CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color:
                      Colors.white,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Verifying Payment...',
                    style:
                    TextStyle(
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ],
              )
                  : const Text(
                "I've Completed Payment",
                style:
                TextStyle(
                  fontWeight:
                  FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}