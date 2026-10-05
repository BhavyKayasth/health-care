import 'package:geolocator/geolocator.dart';

import '../../location/services/location_service.dart';
import '../models/nearby_hospital_model.dart';
import '../services/hospital_service.dart';
import '../services/maps_service.dart';

class NearbyRepository {
  NearbyRepository({
    LocationService? locationService,
    MapsService? mapsService,
    HospitalService? hospitalService,
  })  : _locationService =
      locationService ??
          const LocationService(),
        _mapsService =
            mapsService ??
                const MapsService(),
        _hospitalService =
            hospitalService ??
                HospitalService();

  // ==========================================================
  // SERVICES
  // ==========================================================

  final LocationService
  _locationService;

  final MapsService _mapsService;

  final HospitalService
  _hospitalService;

  // ==========================================================
  // CURRENT LOCATION
  // ==========================================================

  Future<Position?>
  getCurrentLocation({
    bool forceRefresh = false,
  }) {
    return _locationService
        .getBestAvailableLocation(
      forceRefresh:
      forceRefresh,
    );
  }

  // ==========================================================
  // GET HOSPITALS NEAR CURRENT LOCATION
  // ==========================================================

  Future<List<NearbyHospitalModel>>
  getHospitalsNearCurrentLocation({
    bool forceRefresh = false,
  }) async {
    final position =
    await getCurrentLocation(
      forceRefresh:
      forceRefresh,
    );

    if (position == null) {
      return [];
    }

    return getHospitalsNearLocation(
      latitude:
      position.latitude,
      longitude:
      position.longitude,
      forceRefresh:
      forceRefresh,
    );
  }

  // ==========================================================
  // GET HOSPITALS NEAR PROVIDED LOCATION
  // ==========================================================

  Future<List<NearbyHospitalModel>>
  getHospitalsNearLocation({
    required double latitude,
    required double longitude,
    bool forceRefresh = false,
  }) async {
    final hospitals =
    await _hospitalService
        .getNearbyHospitals(
      latitude:
      latitude,
      longitude:
      longitude,
      forceRefresh:
      forceRefresh,
    );

    // ========================================================
    // EXACT DISTANCE
    // ========================================================

    final hospitalsWithDistance =
    hospitals.map(
          (hospital) {
        final distance =
        _locationService
            .calculateDistance(
          startLatitude:
          latitude,
          startLongitude:
          longitude,
          endLatitude:
          hospital.latitude,
          endLongitude:
          hospital.longitude,
        );

        return hospital.copyWith(
          distanceKm:
          distance,
        );
      },
    ).toList();

    // ========================================================
    // SORT NEAREST FIRST
    // ========================================================

    hospitalsWithDistance.sort(
          (a, b) {
        final double distanceA =
            a.distanceKm ??
                double.infinity;

        final double distanceB =
            b.distanceKm ??
                double.infinity;

        final comparison =
        distanceA.compareTo(
          distanceB,
        );

        if (comparison != 0) {
          return comparison;
        }

        return a.name
            .toLowerCase()
            .compareTo(
          b.name.toLowerCase(),
        );
      },
    );

    return hospitalsWithDistance;
  }

  // ==========================================================
  // DISTANCE
  // ==========================================================

  double calculateDistance({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    return _locationService
        .calculateDistance(
      startLatitude:
      startLatitude,
      startLongitude:
      startLongitude,
      endLatitude:
      endLatitude,
      endLongitude:
      endLongitude,
    );
  }

  // ==========================================================
  // OPEN DIRECTIONS
  // ==========================================================

  Future<void> openDirections(
      NearbyHospitalModel hospital,
      ) {
    return _mapsService
        .openDirections(
      latitude:
      hospital.latitude,
      longitude:
      hospital.longitude,
    );
  }

  // ==========================================================
  // OPEN HOSPITAL LOCATION
  // ==========================================================

  Future<void> openLocation(
      NearbyHospitalModel hospital,
      ) {
    return _mapsService
        .openLocation(
      latitude:
      hospital.latitude,
      longitude:
      hospital.longitude,
    );
  }

  // ==========================================================
  // DISPOSE
  // ==========================================================

  void dispose() {
    _hospitalService.dispose();
  }
}