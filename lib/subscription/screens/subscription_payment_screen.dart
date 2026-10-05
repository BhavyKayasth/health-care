import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/subscription_payment_controller.dart';
import '../model/subscription_models.dart';
import '../widgets/subscription_header.dart';
import '../widgets/subscription_payment_view.dart';
import '../widgets/subscription_plans_view.dart';
import '../widgets/subscription_qr_view.dart';

class SubscriptionPaymentScreen
    extends ConsumerWidget {
  final VoidCallback onBack;
  final VoidCallback onPaymentSuccess;

  const SubscriptionPaymentScreen({
    super.key,
    required this.onBack,
    required this.onPaymentSuccess,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final state = ref.watch(
      subscriptionPaymentControllerProvider,
    );

    final controller = ref.read(
      subscriptionPaymentControllerProvider
          .notifier,
    );

    return Scaffold(
      backgroundColor:
      const Color(0xFFF8FAFF),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFEFF6FF),
                Colors.white,
                Color(0xFFFDF2F8),
              ],
            ),
          ),
          child: Column(
            children: [
              //------------------------------------------------
              // TOP BACK BUTTON
              //------------------------------------------------

              if (state.view ==
                  SubscriptionView.plans)
                SubscriptionHeader(
                  onBack: onBack,
                ),

              //------------------------------------------------
              // CURRENT VIEW
              //------------------------------------------------

              Expanded(
                child: AnimatedSwitcher(
                  duration:
                  const Duration(
                    milliseconds: 250,
                  ),
                  child: _buildView(
                    context,
                    state,
                    controller,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildView(
      BuildContext context,
      SubscriptionPaymentState state,
      SubscriptionPaymentController
      controller,
      ) {
    switch (state.view) {
      case SubscriptionView.plans:
        return SubscriptionPlansView(
          key: const ValueKey('plans'),
          state: state,
          controller: controller,
        );

      case SubscriptionView.payment:
        return SubscriptionPaymentView(
          key: const ValueKey('payment'),
          state: state,
          controller: controller,
          onPayment: () {
            _handlePayment(
              context,
              state,
              controller,
            );
          },
        );

      case SubscriptionView.qr:
        return SubscriptionQrView(
          key: const ValueKey('qr'),
          state: state,
          controller: controller,
          onVerifyPayment: () {
            _handleQrPayment(
              context,
              controller,
            );
          },
        );
    }
  }

  Future<void> _handlePayment(
      BuildContext context,
      SubscriptionPaymentState state,
      SubscriptionPaymentController
      controller,
      ) async {
    final paymentMethod =
        state.selectedPaymentMethod;

    if (paymentMethod == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Please select a payment method.',
          ),
        ),
      );
      return;
    }

    //--------------------------------------------------------
    // QR PAYMENT
    //--------------------------------------------------------

    if (paymentMethod ==
        SubscriptionPaymentMethod.qr) {
      controller.openQrPayment();
      return;
    }

    //--------------------------------------------------------
    // SIMULATED PAYMENT
    //--------------------------------------------------------

    controller.setProcessing(true);

    await Future.delayed(
      const Duration(
        milliseconds: 2500,
      ),
    );

    if (!context.mounted) return;

    controller.setProcessing(false);

    _showPaymentSuccess(
      context,
    );
  }

  Future<void> _handleQrPayment(
      BuildContext context,
      SubscriptionPaymentController
      controller,
      ) async {
    controller.setProcessing(true);

    await Future.delayed(
      const Duration(
        milliseconds: 2000,
      ),
    );

    if (!context.mounted) return;

    controller.setProcessing(false);

    _showPaymentSuccess(
      context,
    );
  }

  void _showPaymentSuccess(
      BuildContext context,
      ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(24),
          ),
          title: const Text(
            'Payment Successful! 🎉',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Welcome to Health Buddy Premium. '
                'Your access to the doctor directory has been unlocked.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onPaymentSuccess();
              },
              child: const Text(
                'Continue',
              ),
            ),
          ],
        );
      },
    );
  }
}