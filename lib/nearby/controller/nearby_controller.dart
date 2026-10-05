import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../location/controller/location_controller.dart';
import '../models/nearby_hospital_model.dart';
import '../repositiry/nearby_repository.dart';

class NearbyState {
  final List<NearbyHospitalModel> hospitals;
  final String selectedSpecialty;
  final bool isLoading;
  final bool locationAvailable;

  const NearbyState({
    required this.hospitals,
    required this.selectedSpecialty,
    this.isLoading = false,
    this.locationAvailable = false,
  });

  NearbyState copyWith({
    List<NearbyHospitalModel>? hospitals,
    String? selectedSpecialty,
    bool? isLoading,
    bool? locationAvailable,
  }) {
    return NearbyState(
      hospitals: hospitals ?? this.hospitals,
      selectedSpecialty:
      selectedSpecialty ?? this.selectedSpecialty,
      isLoading: isLoading ?? this.isLoading,
      locationAvailable:
      locationAvailable ?? this.locationAvailable,
    );
  }
}

class NearbyController
    extends StateNotifier<NearbyState> {
  NearbyController(this._ref)
      : super(
    const NearbyState(
      hospitals: [],
      selectedSpecialty: 'All',
    ),
  );

  final Ref _ref;

  final NearbyRepository _repository =
  NearbyRepository();

  bool _isLoadingHospitals = false;

  DateTime? _lastSuccessfulLoad;

  static const Duration
  _automaticRefreshInterval =
  Duration(minutes: 5);

  static const List<String> specialties = [
    'All',
    'Cardiology',
    'Neurology',
    'Orthopedics',
    'Dermatology',
    'Pediatrics',
    'Gynecology',
    'General Medicine',
    'Surgery',
    'Oncology',
    'ENT',
    'Gastroenterology',
    'Pulmonology',
    'Nephrology',
    'Urology',
    'Ophthalmology',
  ];

  // ==========================================================
  // SPECIALTY
  // ==========================================================

  void selectSpecialty(String specialty) {
    if (specialty.trim().isEmpty) {
      return;
    }

    state = state.copyWith(
      selectedSpecialty: specialty,
    );
  }

  // ==========================================================
  // FILTERED HOSPITALS
  // ==========================================================

  List<NearbyHospitalModel>
  get filteredHospitals {
    final selected =
    state.selectedSpecialty
        .trim()
        .toLowerCase();

    final hospitals =
    state.hospitals.where(
          (hospital) {
        if (selected == 'all') {
          return true;
        }

        return hospital.specialties.any(
              (specialty) {
            final value =
            specialty.trim().toLowerCase();

            return value == selected ||
                value.contains(selected) ||
                selected.contains(value);
          },
        );
      },
    ).toList();

    hospitals.sort(
          (a, b) {
        final distanceA =
            a.distanceKm ??
                double.infinity;

        final distanceB =
            b.distanceKm ??
                double.infinity;

        final difference =
            distanceA - distanceB;

        if (difference.abs() > 0.05) {
          return difference.compareTo(0);
        }

        return a.name
            .toLowerCase()
            .compareTo(
          b.name.toLowerCase(),
        );
      },
    );

    return hospitals;
  }

  // ==========================================================
  // LOAD NEARBY HOSPITALS
  // ==========================================================

  Future<void> loadNearbyHospitals({
    bool forceRefresh = false,
  }) async {
    if (!mounted ||
        _isLoadingHospitals) {
      return;
    }

    // --------------------------------------------------------
    // USE EXISTING RESULTS
    // --------------------------------------------------------

    if (!forceRefresh &&
        state.hospitals.isNotEmpty &&
        _lastSuccessfulLoad != null) {
      final elapsed =
      DateTime.now().difference(
        _lastSuccessfulLoad!,
      );

      if (elapsed <
          _automaticRefreshInterval) {
        debugPrint(
          'NearbyController: '
              'using existing results',
        );

        return;
      }
    }

    _isLoadingHospitals = true;

    state = state.copyWith(
      isLoading: true,
    );

    try {
      // ======================================================
      // SHARED LOCATION
      // ======================================================

      final locationController =
      _ref.read(
        locationControllerProvider.notifier,
      );

      // IMPORTANT:
      // Request permission if required.
      await locationController.checkLocation(
        requestPermission: true,
      );

      // ======================================================
      // GET EXISTING POSITION FIRST
      // ======================================================

      var position =
          _ref
              .read(locationControllerProvider)
              .position;

      // ======================================================
      // GET LOCATION IF NEEDED
      // ======================================================

      if (position == null) {
        position =
        await locationController
            .getCurrentLocation(
          forceRefresh: forceRefresh,
        );
      }

      // ======================================================
      // READ SHARED STATE AGAIN
      // ======================================================

      position ??=
          _ref
              .read(locationControllerProvider)
              .position;

      if (!mounted) {
        return;
      }

      // ======================================================
      // LOCATION UNAVAILABLE
      // ======================================================

      if (position == null) {
        debugPrint(
          'NearbyController: '
              'location unavailable',
        );

        state = state.copyWith(
          isLoading: false,
          locationAvailable: false,
        );

        return;
      }

      // ======================================================
      // LOCATION AVAILABLE
      // ======================================================

      debugPrint(
        'NearbyController: '
            'location=${position.latitude},'
            '${position.longitude} '
            'accuracy=${position.accuracy}m',
      );

      // IMPORTANT:
      // Mark location available BEFORE calling HospitalService.
      state = state.copyWith(
        locationAvailable: true,
      );

      // ======================================================
      // HOSPITALS
      // ======================================================

      final hospitals =
      await _repository
          .getHospitalsNearLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        forceRefresh: forceRefresh,
      );

      if (!mounted) {
        return;
      }

      // ======================================================
      // EMPTY
      // ======================================================

      if (hospitals.isEmpty) {
        debugPrint(
          'NearbyController: '
              'no hospitals returned',
        );

        state = state.copyWith(
          isLoading: false,
          locationAvailable: true,
        );

        return;
      }

      // ======================================================
      // SUCCESS
      // ======================================================

      state = state.copyWith(
        hospitals: hospitals,
        isLoading: false,
        locationAvailable: true,
      );

      _lastSuccessfulLoad =
          DateTime.now();

      debugPrint(
        'NearbyController: '
            '${hospitals.length} hospitals loaded',
      );
    } catch (e, stackTrace) {
      debugPrint(
        'NearbyController: '
            'hospital loading error: $e',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!mounted) {
        return;
      }

      // Location was successfully obtained before
      // HospitalService was called, so keep it available.
      state = state.copyWith(
        isLoading: false,
        locationAvailable: true,
      );
    } finally {
      _isLoadingHospitals = false;
    }
  }

  // ==========================================================
  // LOAD AT SPECIFIC LOCATION
  // ==========================================================

  Future<void> loadHospitalsAtLocation({
    required double latitude,
    required double longitude,
    bool forceRefresh = false,
  }) async {
    if (!mounted ||
        _isLoadingHospitals) {
      return;
    }

    _isLoadingHospitals = true;

    state = state.copyWith(
      isLoading: true,
      locationAvailable: true,
    );

    try {
      final hospitals =
      await _repository
          .getHospitalsNearLocation(
        latitude: latitude,
        longitude: longitude,
        forceRefresh: forceRefresh,
      );

      if (!mounted) {
        return;
      }

      if (hospitals.isEmpty) {
        state = state.copyWith(
          isLoading: false,
        );

        return;
      }

      state = state.copyWith(
        hospitals: hospitals,
        isLoading: false,
        locationAvailable: true,
      );

      _lastSuccessfulLoad =
          DateTime.now();
    } catch (e, stackTrace) {
      debugPrint(
        'NearbyController: '
            'specific location error: $e',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!mounted) {
        return;
      }

      state = state.copyWith(
        isLoading: false,
        locationAvailable: true,
      );
    } finally {
      _isLoadingHospitals = false;
    }
  }

  // ==========================================================
  // REFRESH
  // ==========================================================

  Future<void> refreshHospitals() async {
    await loadNearbyHospitals(
      forceRefresh: true,
    );
  }

  // ==========================================================
  // CLEAR
  // ==========================================================

  void clearHospitals() {
    state = state.copyWith(
      hospitals: [],
    );

    _lastSuccessfulLoad = null;
  }

  // ==========================================================
  // DISPOSE
  // ==========================================================

  @override
  void dispose() {
    _repository.dispose();
    super.dispose();
  }
}

// ============================================================
// PROVIDER
// ============================================================

final nearbyControllerProvider =
StateNotifierProvider<
    NearbyController,
    NearbyState>(
      (ref) => NearbyController(ref),
);