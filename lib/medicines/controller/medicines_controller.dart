import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/medicine_data.dart';
import '../model/medicine_model.dart';

enum MedicineTab {
  buy,
  scan,
  symptoms,
  orders,
}

enum CheckoutStep {
  address,
  payment,
}

class DeliveryAddress {
  final String street;
  final String area;
  final String city;
  final String pincode;
  final String phone;

  const DeliveryAddress({
    this.street = '',
    this.area = '',
    this.city = '',
    this.pincode = '',
    this.phone = '',
  });

  DeliveryAddress copyWith({
    String? street,
    String? area,
    String? city,
    String? pincode,
    String? phone,
  }) {
    return DeliveryAddress(
      street: street ?? this.street,
      area: area ?? this.area,
      city: city ?? this.city,
      pincode: pincode ?? this.pincode,
      phone: phone ?? this.phone,
    );
  }

  bool get isComplete {
    return street.trim().isNotEmpty &&
        area.trim().isNotEmpty &&
        city.trim().isNotEmpty &&
        pincode.trim().length == 6 &&
        phone.trim().length == 10;
  }
}

class MedicinesState {
  final MedicineTab activeTab;
  final String selectedCategory;
  final String searchQuery;

  final Map<int, int> cart;

  final bool scanning;
  final MedicineModel? scannedMedicine;

  final String symptoms;
  final bool analyzingSymptoms;
  final List<MedicineModel> aiSuggestions;

  final String? selectedPlatform;

  final bool checkoutVisible;
  final CheckoutStep checkoutStep;
  final MedicineModel? buyNowItem;

  final DeliveryAddress address;
  final String? selectedPayment;

  const MedicinesState({
    this.activeTab = MedicineTab.buy,
    this.selectedCategory = 'All',
    this.searchQuery = '',
    this.cart = const {},
    this.scanning = false,
    this.scannedMedicine,
    this.symptoms = '',
    this.analyzingSymptoms = false,
    this.aiSuggestions = const [],
    this.selectedPlatform,
    this.checkoutVisible = false,
    this.checkoutStep = CheckoutStep.address,
    this.buyNowItem,
    this.address = const DeliveryAddress(),
    this.selectedPayment,
  });

  MedicinesState copyWith({
    MedicineTab? activeTab,
    String? selectedCategory,
    String? searchQuery,
    Map<int, int>? cart,
    bool? scanning,
    MedicineModel? scannedMedicine,
    bool clearScannedMedicine = false,
    String? symptoms,
    bool? analyzingSymptoms,
    List<MedicineModel>? aiSuggestions,
    String? selectedPlatform,
    bool? checkoutVisible,
    CheckoutStep? checkoutStep,
    MedicineModel? buyNowItem,
    bool clearBuyNowItem = false,
    DeliveryAddress? address,
    String? selectedPayment,
    bool clearSelectedPayment = false,
  }) {
    return MedicinesState(
      activeTab: activeTab ?? this.activeTab,
      selectedCategory:
      selectedCategory ?? this.selectedCategory,
      searchQuery:
      searchQuery ?? this.searchQuery,
      cart: cart ?? this.cart,
      scanning: scanning ?? this.scanning,
      scannedMedicine: clearScannedMedicine
          ? null
          : scannedMedicine ?? this.scannedMedicine,
      symptoms: symptoms ?? this.symptoms,
      analyzingSymptoms:
      analyzingSymptoms ?? this.analyzingSymptoms,
      aiSuggestions:
      aiSuggestions ?? this.aiSuggestions,
      selectedPlatform:
      selectedPlatform ?? this.selectedPlatform,
      checkoutVisible:
      checkoutVisible ?? this.checkoutVisible,
      checkoutStep:
      checkoutStep ?? this.checkoutStep,
      buyNowItem: clearBuyNowItem
          ? null
          : buyNowItem ?? this.buyNowItem,
      address: address ?? this.address,
      selectedPayment: clearSelectedPayment
          ? null
          : selectedPayment ?? this.selectedPayment,
    );
  }

  List<MedicineModel> get filteredMedicines {
    final query = searchQuery.trim().toLowerCase();

    return medicines.where((medicine) {
      final categoryMatch =
          selectedCategory == 'All' ||
              medicine.category == selectedCategory;

      final searchMatch =
          query.isEmpty ||
              medicine.name.toLowerCase().contains(query) ||
              medicine.description.toLowerCase().contains(query);

      return categoryMatch && searchMatch;
    }).toList();
  }

  List<MapEntry<MedicineModel, int>> get cartItems {
    final result = <MapEntry<MedicineModel, int>>[];

    for (final entry in cart.entries) {
      final medicine =
      medicines.firstWhere(
            (item) => item.id == entry.key,
      );

      result.add(
        MapEntry(medicine, entry.value),
      );
    }

    return result;
  }

  double get cartTotal {
    double total = 0;

    for (final item in cartItems) {
      total += item.key.price * item.value;
    }

    return total;
  }
}

final medicinesControllerProvider =
StateNotifierProvider<MedicinesController, MedicinesState>(
      (ref) => MedicinesController(),
);

class MedicinesController
    extends StateNotifier<MedicinesState> {
  MedicinesController()
      : super(const MedicinesState());

  Timer? _scanTimer;
  Timer? _symptomTimer;
  Timer? _partnerTimer;

  void changeTab(MedicineTab tab) {
    state = state.copyWith(
      activeTab: tab,
    );
  }

  void changeCategory(String category) {
    state = state.copyWith(
      selectedCategory: category,
    );
  }

  void search(String value) {
    state = state.copyWith(
      searchQuery: value,
    );
  }

  void addToCart(int medicineId) {
    final updated =
    Map<int, int>.from(state.cart);

    updated[medicineId] =
        (updated[medicineId] ?? 0) + 1;

    state = state.copyWith(
      cart: updated,
    );
  }

  void removeFromCart(int medicineId) {
    final updated =
    Map<int, int>.from(state.cart);

    final current =
        updated[medicineId] ?? 0;

    if (current <= 1) {
      updated.remove(medicineId);
    } else {
      updated[medicineId] = current - 1;
    }

    state = state.copyWith(
      cart: updated,
    );
  }

  void startScan() {
    _scanTimer?.cancel();

    state = state.copyWith(
      scanning: true,
      clearScannedMedicine: true,
    );

    _scanTimer = Timer(
      const Duration(seconds: 2),
          () {
        state = state.copyWith(
          scanning: false,
          scannedMedicine: medicines.first,
        );
      },
    );
  }

  void clearScanResult() {
    state = state.copyWith(
      clearScannedMedicine: true,
    );
  }

  void updateSymptoms(String value) {
    state = state.copyWith(
      symptoms: value,
    );
  }

  void analyzeSymptoms() {
    if (state.symptoms.trim().isEmpty) {
      return;
    }

    _symptomTimer?.cancel();

    state = state.copyWith(
      analyzingSymptoms: true,
      aiSuggestions: const [],
    );

    _symptomTimer = Timer(
      const Duration(milliseconds: 1500),
          () {
        state = state.copyWith(
          analyzingSymptoms: false,

          // Demo only.
          aiSuggestions: [
            medicines[0],
            medicines[2],
            medicines[3],
          ],
        );
      },
    );
  }

  void buyNow(MedicineModel medicine) {
    state = state.copyWith(
      checkoutVisible: true,
      checkoutStep: CheckoutStep.address,
      buyNowItem: medicine,
      address: const DeliveryAddress(),
      clearSelectedPayment: true,
    );
  }

  void closeCheckout() {
    state = state.copyWith(
      checkoutVisible: false,
      checkoutStep: CheckoutStep.address,
      clearBuyNowItem: true,
      address: const DeliveryAddress(),
      clearSelectedPayment: true,
    );
  }

  void updateStreet(String value) {
    state = state.copyWith(
      address: state.address.copyWith(
        street: value,
      ),
    );
  }

  void updateArea(String value) {
    state = state.copyWith(
      address: state.address.copyWith(
        area: value,
      ),
    );
  }

  void updateCity(String value) {
    state = state.copyWith(
      address: state.address.copyWith(
        city: value,
      ),
    );
  }

  void updatePincode(String value) {
    state = state.copyWith(
      address: state.address.copyWith(
        pincode: value,
      ),
    );
  }

  void updatePhone(String value) {
    state = state.copyWith(
      address: state.address.copyWith(
        phone: value,
      ),
    );
  }

  bool continueToPayment() {
    if (!state.address.isComplete) {
      return false;
    }

    state = state.copyWith(
      checkoutStep: CheckoutStep.payment,
    );

    return true;
  }

  void backToAddress() {
    state = state.copyWith(
      checkoutStep: CheckoutStep.address,
    );
  }

  void selectPayment(String payment) {
    state = state.copyWith(
      selectedPayment: payment,
    );
  }

  bool placeOrder() {
    if (state.selectedPayment == null ||
        state.buyNowItem == null) {
      return false;
    }

    return true;
  }

  void closePlacedOrder() {
    closeCheckout();
  }

  void buyThroughPartner(String platform) {
    _partnerTimer?.cancel();

    state = state.copyWith(
      selectedPlatform: platform,
    );

    _partnerTimer = Timer(
      const Duration(seconds: 1),
          () {
        state = state.copyWith(
          selectedPlatform: null,
        );
      },
    );
  }

  @override
  void dispose() {
    _scanTimer?.cancel();
    _symptomTimer?.cancel();
    _partnerTimer?.cancel();
    super.dispose();
  }
}