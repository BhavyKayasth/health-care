// lib/home/service/pharmacy_service.dart

import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/pharmacy_model.dart';

class PharmacyService {
  PharmacyService({
    http.Client? client,
  }) : _client = client ?? http.Client();

  final http.Client _client;

  // ==========================================================
  // NOMINATIM
  // ==========================================================

  static const String _nominatimUrl =
      'https://nominatim.openstreetmap.org/search';

  // ==========================================================
  // SEARCH RADIUS
  // ==========================================================
  //
  // Approximately 6 km around the user's location.
  // This keeps the request small and fast.
  //
  static const double _latitudeRadius = 0.06;
  static const double _longitudeRadius = 0.06;

  // ==========================================================
  // MAXIMUM RESULTS
  // ==========================================================

  static const int _maxResults = 10;

  // ==========================================================
  // REQUEST TIMEOUT
  // ==========================================================

  static const Duration _timeout =
  Duration(seconds: 8);

  // ==========================================================
  // CACHE
  // ==========================================================

  static const Duration _cacheDuration =
  Duration(minutes: 5);

  final Map<String, _PharmacyCacheEntry> _cache = {};

  // ==========================================================
  // GET NEARBY PHARMACIES
  // ==========================================================

  Future<List<PharmacyModel>> getNearbyPharmacies({
    required double latitude,
    required double longitude,
    bool forceRefresh = false,
  }) async {
    final String cacheKey = _createCacheKey(
      latitude,
      longitude,
    );

    // ========================================================
    // CACHE
    // ========================================================

    if (!forceRefresh) {
      final cached = _cache[cacheKey];

      if (cached != null &&
          DateTime.now().isBefore(cached.expiresAt)) {
        debugPrint(
          'PharmacyService: '
              'using cached results '
              '(${cached.pharmacies.length})',
        );

        return List<PharmacyModel>.from(
          cached.pharmacies,
        );
      }
    }

    // ========================================================
    // SEARCH NOMINATIM
    // ========================================================

    try {
      final pharmacies = await _requestNominatim(
        latitude: latitude,
        longitude: longitude,
      );

      if (pharmacies.isNotEmpty) {
        _saveCache(
          cacheKey,
          pharmacies,
        );

        return pharmacies;
      }

      debugPrint(
        'PharmacyService: '
            'Nominatim returned 0 pharmacies',
      );
    } catch (e) {
      debugPrint(
        'PharmacyService: '
            'Nominatim failed: $e',
      );
    }

    // ========================================================
    // EXPIRED CACHE
    // ========================================================

    final oldCache = _cache[cacheKey];

    if (oldCache != null &&
        oldCache.pharmacies.isNotEmpty) {
      debugPrint(
        'PharmacyService: '
            'using expired cache',
      );

      return List<PharmacyModel>.from(
        oldCache.pharmacies,
      );
    }

    // ========================================================
    // FINAL FAILURE
    // ========================================================

    throw Exception(
      'Unable to load nearby pharmacies. '
          'Please try refreshing.',
    );
  }

  // ==========================================================
  // NOMINATIM REQUEST
  // ==========================================================

  Future<List<PharmacyModel>> _requestNominatim({
    required double latitude,
    required double longitude,
  }) async {
    // ========================================================
    // BUILD VIEWBOX
    // ========================================================
    //
    // Nominatim expects:
    //
    // west, north, east, south
    //
    final double west =
        longitude - _longitudeRadius;

    final double east =
        longitude + _longitudeRadius;

    final double north =
        latitude + _latitudeRadius;

    final double south =
        latitude - _latitudeRadius;

    final Uri uri = Uri.parse(
      _nominatimUrl,
    ).replace(
      queryParameters: {
        // Search for pharmacies.
        'q': 'pharmacy',

        // Restrict results to the nearby area.
        'viewbox':
        '$west,$north,$east,$south',

        'bounded': '1',

        'format': 'jsonv2',

        'limit': _maxResults.toString(),

        // Extra OSM information such as phone numbers
        // when available.
        'extratags': '1',

        'addressdetails': '0',
      },
    );

    debugPrint(
      'PharmacyService: '
          'requesting Nominatim',
    );

    final response = await _client
        .get(
      uri,
      headers: const {
        'Accept': 'application/json',

        // Required to identify the application.
        'User-Agent':
        'HealthCareAI/1.0 '
            '(Flutter college project)',
      },
    )
        .timeout(_timeout);

    debugPrint(
      'PharmacyService: '
          'Nominatim HTTP '
          '${response.statusCode}',
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Nominatim returned HTTP '
            '${response.statusCode}',
      );
    }

    // ========================================================
    // JSON
    // ========================================================

    final dynamic decoded;

    try {
      decoded = jsonDecode(
        response.body,
      );
    } catch (_) {
      throw Exception(
        'Invalid pharmacy API JSON.',
      );
    }

    if (decoded is! List) {
      throw Exception(
        'Invalid pharmacy API response.',
      );
    }

    debugPrint(
      'PharmacyService: '
          'Nominatim returned '
          '${decoded.length} results',
    );

    // ========================================================
    // PARSE
    // ========================================================

    final Map<String, PharmacyModel> unique = {};

    for (final dynamic element in decoded) {
      if (element is! Map) {
        continue;
      }

      final pharmacy = _parsePharmacy(
        element,
        latitude,
        longitude,
      );

      if (pharmacy != null) {
        unique[pharmacy.id] = pharmacy;
      }
    }

    final List<PharmacyModel> pharmacies =
    unique.values.toList();

    // ========================================================
    // SORT NEAREST FIRST
    // ========================================================

    pharmacies.sort(
          (a, b) {
        final double distanceA =
        _parseDistance(a.distance);

        final double distanceB =
        _parseDistance(b.distance);

        final comparison =
        distanceA.compareTo(distanceB);

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

    // ========================================================
    // ONLY 10
    // ========================================================

    final result = pharmacies.length > _maxResults
        ? pharmacies.sublist(
      0,
      _maxResults,
    )
        : pharmacies;

    debugPrint(
      'PharmacyService: '
          'parsed ${result.length} pharmacies',
    );

    return result;
  }

  // ==========================================================
  // PARSE PHARMACY
  // ==========================================================

  PharmacyModel? _parsePharmacy(
      Map element,
      double currentLatitude,
      double currentLongitude,
      ) {
    // ========================================================
    // OSM ID
    // ========================================================

    final String osmType =
        element['osm_type']?.toString() ??
            '';

    final String osmId =
        element['osm_id']?.toString() ??
            '';

    if (osmId.isEmpty) {
      return null;
    }

    // ========================================================
    // NAME
    // ========================================================

    final String name =
        element['display_name']?.toString().trim() ??
            '';

    if (name.isEmpty) {
      return null;
    }

    // ========================================================
    // FILTER OBVIOUS NON-PHARMACY RESULTS
    // ========================================================

    if (_looksLikeNonPharmacy(name)) {
      return null;
    }

    // ========================================================
    // COORDINATES
    // ========================================================

    final double? latitude =
    double.tryParse(
      element['lat']?.toString() ?? '',
    );

    final double? longitude =
    double.tryParse(
      element['lon']?.toString() ?? '',
    );

    if (latitude == null ||
        longitude == null) {
      return null;
    }

    // ========================================================
    // DISTANCE
    // ========================================================

    final double distanceKm =
    _distanceKm(
      currentLatitude,
      currentLongitude,
      latitude,
      longitude,
    );

    // ========================================================
    // EXTRA TAGS
    // ========================================================

    final dynamic rawExtraTags =
    element['extratags'];

    final Map<String, dynamic> extraTags =
    rawExtraTags is Map
        ? Map<String, dynamic>.from(
      rawExtraTags,
    )
        : <String, dynamic>{};

    // ========================================================
    // PHONE
    // ========================================================

    final String phone =
        _firstNonEmpty([
          extraTags['phone'],
          extraTags['contact:phone'],
          extraTags['mobile'],
          extraTags['contact:mobile'],
        ]) ??
            '';

    // ========================================================
    // ID
    // ========================================================

    final String id =
        'pharmacy_${osmType}_$osmId';

    return PharmacyModel(
      id: id,
      name: name,
      distance:
      '${distanceKm.toStringAsFixed(1)} km',
      rating: '—',
      phone: phone,
      latitude: latitude,
      longitude: longitude,
    );
  }

  // ==========================================================
  // FILTER NON-PHARMACY RESULTS
  // ==========================================================

  bool _looksLikeNonPharmacy(
      String name,
      ) {
    final String value =
    name.toLowerCase().trim();

    const excludedWords = [
      'hospital',
      'clinic',
      'diagnostic',
      'diagnostics',
      'laboratory',
      'lab ',
      'doctor',
      'dental',
      'dentist',
      'nursing home',
      'pathology',
    ];

    for (final String word in excludedWords) {
      if (value.contains(word)) {
        return true;
      }
    }

    return false;
  }

  // ==========================================================
  // DISTANCE
  // ==========================================================

  double _distanceKm(
      double lat1,
      double lon1,
      double lat2,
      double lon2,
      ) {
    const double earthRadius = 6371.0;

    final double dLat =
    _toRadians(
      lat2 - lat1,
    );

    final double dLon =
    _toRadians(
      lon2 - lon1,
    );

    final double a =
        math.sin(dLat / 2) *
            math.sin(dLat / 2) +
            math.cos(
              _toRadians(lat1),
            ) *
                math.cos(
                  _toRadians(lat2),
                ) *
                math.sin(dLon / 2) *
                math.sin(dLon / 2);

    final double c =
        2 *
            math.atan2(
              math.sqrt(a),
              math.sqrt(1 - a),
            );

    return earthRadius * c;
  }

  double _toRadians(
      double value,
      ) {
    return value * math.pi / 180;
  }

  // ==========================================================
  // PARSE DISTANCE
  // ==========================================================

  double _parseDistance(
      String value,
      ) {
    return double.tryParse(
      value
          .replaceAll(
        'km',
        '',
      )
          .trim(),
    ) ??
        double.infinity;
  }

  // ==========================================================
  // FIRST NON-EMPTY
  // ==========================================================

  String? _firstNonEmpty(
      List<dynamic> values,
      ) {
    for (final dynamic value in values) {
      if (value == null) {
        continue;
      }

      final String text =
      value.toString().trim();

      if (text.isNotEmpty) {
        return text;
      }
    }

    return null;
  }

  // ==========================================================
  // CACHE KEY
  // ==========================================================

  String _createCacheKey(
      double latitude,
      double longitude,
      ) {
    return '${latitude.toStringAsFixed(3)}_'
        '${longitude.toStringAsFixed(3)}';
  }

  // ==========================================================
  // SAVE CACHE
  // ==========================================================

  void _saveCache(
      String key,
      List<PharmacyModel> pharmacies,
      ) {
    _cache[key] = _PharmacyCacheEntry(
      pharmacies:
      List<PharmacyModel>.from(
        pharmacies,
      ),
      expiresAt:
      DateTime.now().add(
        _cacheDuration,
      ),
    );

    if (_cache.length > 20) {
      _cache.remove(
        _cache.keys.first,
      );
    }
  }

  // ==========================================================
  // DISPOSE
  // ==========================================================

  void dispose() {
    _client.close();
    _cache.clear();
  }
}

// ============================================================
// CACHE ENTRY
// ============================================================

class _PharmacyCacheEntry {
  final List<PharmacyModel> pharmacies;
  final DateTime expiresAt;

  const _PharmacyCacheEntry({
    required this.pharmacies,
    required this.expiresAt,
  });
}