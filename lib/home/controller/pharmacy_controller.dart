import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../location/controller/location_controller.dart';
import '../models/pharmacy_model.dart';
import '../service/pharmacy_service.dart';

final pharmacyControllerProvider =
StateNotifierProvider<PharmacyController, PharmacyState>(
      (ref) => PharmacyController(ref),
);

class PharmacyState {
  final bool isLoading;
  final String? error;
  final List<PharmacyModel> pharmacies;
  final Position? position;

  const PharmacyState({
    required this.isLoading,
    required this.error,
    required this.pharmacies,
    required this.position,
  });

  factory PharmacyState.initial() {
    return const PharmacyState(
      isLoading: false,
      error: null,
      pharmacies: [],
      position: null,
    );
  }

  PharmacyState copyWith({
    bool? isLoading,
    String? error,
    bool clearError = false,
    List<PharmacyModel>? pharmacies,
    Position? position,
  }) {
    return PharmacyState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
      pharmacies: pharmacies ?? this.pharmacies,
      position: position ?? this.position,
    );
  }
}

class PharmacyController extends StateNotifier<PharmacyState> {
  PharmacyController(this._ref)
      : _service = PharmacyService(),
        super(PharmacyState.initial());

  final Ref _ref;
  final PharmacyService _service;

  // ==========================================================
  // LOAD PHARMACIES
  // ==========================================================

  Future<void> loadPharmacies({
    bool forceRefresh = false,
  }) async {
    if (state.isLoading) {
      return;
    }

    state = state.copyWith(
      isLoading: true,
      clearError: true,
    );

    try {
      final locationController =
      _ref.read(
        locationControllerProvider.notifier,
      );

      // IMPORTANT:
      // Ask for permission if it has not already been granted.
      await locationController.checkLocation(
        requestPermission: true,
      );

      Position? position =
          _ref
              .read(locationControllerProvider)
              .position;

      if (position == null) {
        position =
        await locationController.getCurrentLocation(
          forceRefresh: forceRefresh,
        );
      }

      position ??=
          _ref
              .read(locationControllerProvider)
              .position;

      // ======================================================
      // LOCATION FAILED
      // ======================================================

      if (position == null) {
        state = state.copyWith(
          isLoading: false,
          error:
          'Unable to get your current location.',
        );

        debugPrint(
          'PharmacyController: '
              'location is null',
        );

        return;
      }

      // ======================================================
      // SAVE LOCATION BEFORE API CALL
      // ======================================================

      state = state.copyWith(
        position: position,
      );

      debugPrint(
        'PharmacyController: '
            'lat=${position.latitude}, '
            'lon=${position.longitude}, '
            'accuracy=${position.accuracy}m',
      );

      // ======================================================
      // GET PHARMACIES
      // ======================================================

      final pharmacies =
      await _service.getNearbyPharmacies(
        latitude: position.latitude,
        longitude: position.longitude,
        forceRefresh: forceRefresh,
      );

      state = state.copyWith(
        isLoading: false,
        pharmacies: pharmacies,
        position: position,
        clearError: true,
      );
    } catch (e) {
      debugPrint(
        'PharmacyController error: $e',
      );

      // Keep location even if API fails.
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // ==========================================================
  // REFRESH
  // ==========================================================

  Future<void> refreshPharmacies() async {
    await loadPharmacies(
      forceRefresh: true,
    );
  }

  // ==========================================================
  // CLEAR
  // ==========================================================

  void clearPharmacies() {
    state = state.copyWith(
      pharmacies: [],
      clearError: true,
    );
  }

  // ==========================================================
  // DISPOSE
  // ==========================================================

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }
}