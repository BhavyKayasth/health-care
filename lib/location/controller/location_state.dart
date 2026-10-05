import 'package:geolocator/geolocator.dart';

class LocationState {
  final bool isLoading;
  final bool permissionGranted;
  final bool permissionDenied;
  final bool permissionDeniedForever;
  final bool serviceEnabled;
  final Position? position;

  const LocationState({
    required this.isLoading,
    required this.permissionGranted,
    required this.permissionDenied,
    required this.permissionDeniedForever,
    required this.serviceEnabled,
    this.position,
  });

  factory LocationState.initial() {
    return const LocationState(
      isLoading: false,
      permissionGranted: false,
      permissionDenied: false,
      permissionDeniedForever: false,
      serviceEnabled: false,
      position: null,
    );
  }

  LocationState copyWith({
    bool? isLoading,
    bool? permissionGranted,
    bool? permissionDenied,
    bool? permissionDeniedForever,
    bool? serviceEnabled,
    Position? position,
    bool clearPosition = false,
  }) {
    return LocationState(
      isLoading:
      isLoading ?? this.isLoading,

      permissionGranted:
      permissionGranted ??
          this.permissionGranted,

      permissionDenied:
      permissionDenied ??
          this.permissionDenied,

      permissionDeniedForever:
      permissionDeniedForever ??
          this.permissionDeniedForever,

      serviceEnabled:
      serviceEnabled ??
          this.serviceEnabled,

      position: clearPosition
          ? null
          : position ?? this.position,
    );
  }
}