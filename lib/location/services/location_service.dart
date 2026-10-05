import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  const LocationService();

  // ==========================================================
  // CHECK PERMISSION
  // ==========================================================

  Future<LocationPermission> checkPermission() async {
    return Geolocator.checkPermission();
  }

  // ==========================================================
  // REQUEST PERMISSION
  // ==========================================================

  Future<LocationPermission> requestPermission() async {
    return Geolocator.requestPermission();
  }

  // ==========================================================
  // CHECK GPS / LOCATION SERVICE
  // ==========================================================

  Future<bool> isLocationEnabled() async {
    return Geolocator.isLocationServiceEnabled();
  }

  // ==========================================================
  // OPEN LOCATION SETTINGS
  // ==========================================================

  Future<bool> openLocationSettings() async {
    return Geolocator.openLocationSettings();
  }

  // ==========================================================
  // GET LAST KNOWN LOCATION
  // ==========================================================

  Future<Position?> getLastKnownLocation() async {
    try {
      final position =
      await Geolocator.getLastKnownPosition();

      if (position != null) {
        debugPrint(
          'LocationService: last known '
              '${position.latitude}, '
              '${position.longitude} '
              'accuracy=${position.accuracy}m',
        );
      }

      return position;
    } catch (e) {
      debugPrint(
        'LocationService: '
            'last known failed: $e',
      );

      return null;
    }
  }

  // ==========================================================
  // GET FRESH LOCATION
  // ==========================================================

  Future<Position?> getCurrentLocation() async {
    try {
      final permission =
      await checkPermission();

      if (permission !=
          LocationPermission.always &&
          permission !=
              LocationPermission.whileInUse) {
        debugPrint(
          'LocationService: '
              'permission not granted',
        );

        return null;
      }

      final enabled =
      await isLocationEnabled();

      if (!enabled) {
        debugPrint(
          'LocationService: GPS disabled',
        );

        return null;
      }

      final position =
      await Geolocator
          .getCurrentPosition(
        locationSettings:
        const LocationSettings(
          accuracy:
          LocationAccuracy.medium,
          timeLimit:
          Duration(seconds: 5),
        ),
      );

      debugPrint(
        'LocationService: fresh '
            '${position.latitude}, '
            '${position.longitude} '
            'accuracy=${position.accuracy}m',
      );

      return position;
    } catch (e) {
      debugPrint(
        'LocationService: '
            'fresh location failed: $e',
      );

      return null;
    }
  }

  // ==========================================================
  // BEST AVAILABLE LOCATION
  // ==========================================================

  Future<Position?> getBestAvailableLocation({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      final lastKnown =
      await getLastKnownLocation();

      if (lastKnown != null) {
        return lastKnown;
      }
    }

    return getCurrentLocation();
  }

  // ==========================================================
  // LOCATION STREAM
  // ==========================================================

  Stream<Position> locationStream() {
    return Geolocator.getPositionStream(
      locationSettings:
      const LocationSettings(
        accuracy:
        LocationAccuracy.medium,
        distanceFilter: 10,
      ),
    );
  }

  // ==========================================================
  // CALCULATE DISTANCE
  // ==========================================================

  double calculateDistance({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    final distance =
    Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );

    return distance / 1000;
  }
}