import 'package:url_launcher/url_launcher.dart';

class MapsService {
  const MapsService();

  /// Open Google Maps with destination coordinates
  Future<void> openDirections({
    required double latitude,
    required double longitude,
  }) async {
    final Uri uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
          '&destination=$latitude,$longitude'
          '&travelmode=driving',
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  /// Open location directly in Google Maps
  Future<void> openLocation({
    required double latitude,
    required double longitude,
  }) async {
    final Uri uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1'
          '&query=$latitude,$longitude',
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }
}