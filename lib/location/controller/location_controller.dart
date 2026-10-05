import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../services/location_service.dart';
import 'location_state.dart';

// ============================================================
// PROVIDER
// ============================================================

final locationControllerProvider =
StateNotifierProvider<LocationController, LocationState>(
      (ref) => LocationController(),
);

// ============================================================
// CONTROLLER
// ============================================================

class LocationController extends StateNotifier<LocationState> {
  LocationController()
      : _service = const LocationService(),
        super(LocationState.initial());

  final LocationService _service;

  Future<void>? _checkFuture;

  StreamSubscription<ServiceStatus>? _serviceSubscription;

  // ==========================================================
  // INITIALIZE
  // ==========================================================

  Future<void> initialize() async {
    await checkLocation(
      requestPermission: false,
    );

    _startLocationServiceListener();
  }

  // ==========================================================
  // CHECK LOCATION
  // ==========================================================

  Future<void> checkLocation({
    bool requestPermission = false,
  }) async {
    // If another location check is already running,
    // wait for it instead of returning immediately.
    final existingFuture = _checkFuture;

    if (existingFuture != null) {
      await existingFuture;

      // If the previous check successfully obtained
      // permission/location, nothing else is needed.
      if (!requestPermission ||
          state.permissionGranted ||
          state.permissionDeniedForever ||
          state.position != null) {
        return;
      }
    }

    final Future<void> future = _performCheckLocation(
      requestPermission: requestPermission,
    );

    _checkFuture = future;

    try {
      await future;
    } finally {
      if (identical(_checkFuture, future)) {
        _checkFuture = null;
      }
    }
  }

  // ==========================================================
  // ACTUAL LOCATION CHECK
  // ==========================================================

  Future<void> _performCheckLocation({
    required bool requestPermission,
  }) async {
    if (!mounted) {
      return;
    }

    state = state.copyWith(
      isLoading: true,
    );

    try {
      // ------------------------------------------------------
      // GPS
      // ------------------------------------------------------

      final bool serviceEnabled =
      await _service.isLocationEnabled();

      debugPrint(
        'LocationController: '
            'GPS enabled=$serviceEnabled',
      );

      // ------------------------------------------------------
      // PERMISSION
      // ------------------------------------------------------

      LocationPermission permission =
      await _service.checkPermission();

      debugPrint(
        'LocationController: '
            'permission=$permission',
      );

      // ------------------------------------------------------
      // REQUEST PERMISSION
      // ------------------------------------------------------

      if (permission == LocationPermission.denied &&
          requestPermission) {
        debugPrint(
          'LocationController: '
              'requesting location permission...',
        );

        permission = await _service.requestPermission();

        debugPrint(
          'LocationController: '
              'permission after request=$permission',
        );
      }

      final bool permissionGranted =
          permission == LocationPermission.always ||
              permission == LocationPermission.whileInUse;

      final bool permissionDenied =
          permission == LocationPermission.denied;

      final bool permissionDeniedForever =
          permission == LocationPermission.deniedForever;

      if (!mounted) {
        return;
      }

      state = state.copyWith(
        isLoading: false,
        permissionGranted: permissionGranted,
        permissionDenied: permissionDenied,
        permissionDeniedForever: permissionDeniedForever,
        serviceEnabled: serviceEnabled,
      );

      // ------------------------------------------------------
      // GPS OFF
      // ------------------------------------------------------

      if (!serviceEnabled) {
        debugPrint(
          'LocationController: GPS is disabled',
        );
        return;
      }

      // ------------------------------------------------------
      // PERMISSION NOT GRANTED
      // ------------------------------------------------------

      if (!permissionGranted) {
        debugPrint(
          'LocationController: '
              'location permission not granted',
        );
        return;
      }

      // ------------------------------------------------------
      // GET LOCATION
      // ------------------------------------------------------

      await loadBestLocation();
    } catch (e, stackTrace) {
      debugPrint(
        'LocationController: '
            'check failed: $e',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!mounted) {
        return;
      }

      state = state.copyWith(
        isLoading: false,
      );
    }
  }

  // ==========================================================
  // REQUEST PERMISSION
  // ==========================================================

  Future<void> requestPermission() async {
    await checkLocation(
      requestPermission: true,
    );
  }

  // ==========================================================
  // LOAD BEST LOCATION
  // ==========================================================

  Future<Position?> loadBestLocation({
    bool forceRefresh = false,
  }) async {
    try {
      final permission =
      await _service.checkPermission();

      final bool serviceEnabled =
      await _service.isLocationEnabled();

      final bool permissionGranted =
          permission == LocationPermission.always ||
              permission == LocationPermission.whileInUse;

      if (!mounted) {
        return null;
      }

      state = state.copyWith(
        permissionGranted: permissionGranted,
        permissionDenied:
        permission == LocationPermission.denied,
        permissionDeniedForever:
        permission == LocationPermission.deniedForever,
        serviceEnabled: serviceEnabled,
      );

      if (!permissionGranted || !serviceEnabled) {
        debugPrint(
          'LocationController: '
              'cannot load location '
              '(permission=$permission, '
              'gps=$serviceEnabled)',
        );

        return null;
      }

      debugPrint(
        'LocationController: '
            'loading best available location...',
      );

      final Position? position =
      await _service.getBestAvailableLocation(
        forceRefresh: forceRefresh,
      );

      if (!mounted) {
        return null;
      }

      if (position != null) {
        state = state.copyWith(
          position: position,
          isLoading: false,
        );

        debugPrint(
          'LocationController: '
              'position=${position.latitude},'
              '${position.longitude} '
              'accuracy=${position.accuracy}m',
        );
      } else {
        debugPrint(
          'LocationController: '
              'LocationService returned null',
        );
      }

      return position;
    } catch (e, stackTrace) {
      debugPrint(
        'LocationController: '
            'load location failed: $e',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      return null;
    }
  }

  // ==========================================================
  // GET CURRENT LOCATION
  // ==========================================================

  Future<Position?> getCurrentLocation({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && state.position != null) {
      debugPrint(
        'LocationController: '
            'using existing position',
      );

      return state.position;
    }

    return loadBestLocation(
      forceRefresh: forceRefresh,
    );
  }

  // ==========================================================
  // OPEN LOCATION SETTINGS
  // ==========================================================

  Future<bool> openLocationSettings() async {
    return _service.openLocationSettings();
  }

  // ==========================================================
  // LOCATION SERVICE LISTENER
  // ==========================================================

  void _startLocationServiceListener() {
    if (_serviceSubscription != null) {
      return;
    }

    _serviceSubscription =
        Geolocator.getServiceStatusStream().listen(
              (ServiceStatus status) async {
            if (!mounted) {
              return;
            }

            if (status == ServiceStatus.disabled) {
              state = state.copyWith(
                serviceEnabled: false,
                isLoading: false,
              );

              debugPrint(
                'LocationController: GPS disabled',
              );

              return;
            }

            if (status == ServiceStatus.enabled) {
              state = state.copyWith(
                serviceEnabled: true,
                isLoading: false,
              );

              debugPrint(
                'LocationController: GPS enabled',
              );

              await checkLocation(
                requestPermission: false,
              );
            }
          },
        );
  }

  // ==========================================================
  // DISPOSE
  // ==========================================================

  @override
  void dispose() {
    _serviceSubscription?.cancel();
    _serviceSubscription = null;

    super.dispose();
  }
}