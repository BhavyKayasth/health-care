import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/subscription_models.dart';


class SubscriptionPaymentState {
  final SubscriptionPlan selectedPlan;
  final SubscriptionView view;
  final SubscriptionPaymentMethod? selectedPaymentMethod;
  final bool isProcessing;

  const SubscriptionPaymentState({
    this.selectedPlan = SubscriptionPlan.monthly,
    this.view = SubscriptionView.plans,
    this.selectedPaymentMethod,
    this.isProcessing = false,
  });

  SubscriptionPaymentState copyWith({
    SubscriptionPlan? selectedPlan,
    SubscriptionView? view,
    SubscriptionPaymentMethod?
    selectedPaymentMethod,
    bool clearPaymentMethod = false,
    bool? isProcessing,
  }) {
    return SubscriptionPaymentState(
      selectedPlan:
      selectedPlan ?? this.selectedPlan,
      view: view ?? this.view,
      selectedPaymentMethod:
      clearPaymentMethod
          ? null
          : selectedPaymentMethod ??
          this.selectedPaymentMethod,
      isProcessing:
      isProcessing ?? this.isProcessing,
    );
  }

  SubscriptionPlanData get plan {
    return subscriptionPlans.firstWhere(
          (item) => item.id == selectedPlan,
    );
  }
}

final subscriptionPaymentControllerProvider =
StateNotifierProvider<
    SubscriptionPaymentController,
    SubscriptionPaymentState>(
      (ref) {
    return SubscriptionPaymentController();
  },
);

class SubscriptionPaymentController
    extends StateNotifier<SubscriptionPaymentState> {
  SubscriptionPaymentController()
      : super(
    const SubscriptionPaymentState(),
  );

  void selectPlan(SubscriptionPlan plan) {
    state = state.copyWith(
      selectedPlan: plan,
    );
  }

  void proceedToPayment() {
    state = state.copyWith(
      view: SubscriptionView.payment,
      clearPaymentMethod: true,
      isProcessing: false,
    );
  }

  void backToPlans() {
    state = state.copyWith(
      view: SubscriptionView.plans,
      clearPaymentMethod: true,
      isProcessing: false,
    );
  }

  void selectPaymentMethod(
      SubscriptionPaymentMethod method,
      ) {
    state = state.copyWith(
      selectedPaymentMethod: method,
    );
  }

  void openQrPayment() {
    state = state.copyWith(
      view: SubscriptionView.qr,
      isProcessing: false,
    );
  }

  void closeQrPayment() {
    state = state.copyWith(
      view: SubscriptionView.payment,
      isProcessing: false,
    );
  }

  void setProcessing(bool value) {
    state = state.copyWith(
      isProcessing: value,
    );
  }
}