// lib/nearby/services/hospital_service.dart

import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/nearby_hospital_model.dart';

class HospitalService {
  HospitalService({
    http.Client? client,
  }) : _client = client ?? http.Client();

  final http.Client _client;

  //==========================================================
  // OVERPASS SERVERS
  //==========================================================

  static const List<String> _overpassUrls = [
    'https://overpass.private.coffee/api/interpreter',
    'https://overpass-api.de/api/interpreter',
  ];

  //==========================================================
  // SEARCH RADIUS
  //==========================================================

  static const int _searchRadiusMeters =
  10000;

  //==========================================================
  // MAXIMUM RESULTS
  //
  // We only need nearby hospitals.
  //==========================================================

  static const int _maxResults = 50;

  //==========================================================
  // REQUEST TIMEOUT
  //==========================================================

  static const Duration _requestTimeout =
  Duration(seconds: 5);

  //==========================================================
  // CACHE
  //==========================================================

  static const Duration _cacheDuration =
  Duration(minutes: 10);

  final Map<String, _HospitalCacheEntry>
  _cache = {};

  //==========================================================
  // GET NEARBY HOSPITALS
  //==========================================================

  Future<List<NearbyHospitalModel>>
  getNearbyHospitals({
    required double latitude,
    required double longitude,
    bool forceRefresh = false,
  }) async {
    final cacheKey =
    _cacheKey(
      latitude,
      longitude,
    );

    //========================================================
    // CHECK CACHE
    //========================================================

    if (!forceRefresh) {
      final cached =
      _cache[cacheKey];

      if (cached != null &&
          DateTime.now().isBefore(
            cached.expiresAt,
          )) {
        debugPrint(
          'HospitalService: '
              'using cached hospitals',
        );

        return List<NearbyHospitalModel>.from(
          cached.hospitals,
        );
      }
    }

    //========================================================
    // OVERPASS QUERY
    //
    // Support both:
    // amenity=hospital
    // healthcare=hospital
    //========================================================

    final String query = '''
[out:json][timeout:5];

(
  nwr["amenity"="hospital"](
    around:$_searchRadiusMeters,
    $latitude,
    $longitude
  );

  nwr["healthcare"="hospital"](
    around:$_searchRadiusMeters,
    $latitude,
    $longitude
  );
);

out center tags qt;
''';

    Object? lastError;

    //========================================================
    // TRY SERVERS
    //========================================================

    for (final url in _overpassUrls) {
      try {
        final hospitals =
        await _requestHospitals(
          url: url,
          query: query,
          latitude: latitude,
          longitude: longitude,
        );

        if (hospitals.isNotEmpty) {
          _saveToCache(
            cacheKey,
            hospitals,
          );

          return hospitals;
        }

        lastError = Exception(
          'No hospitals returned from $url',
        );
      } on _OverpassException catch (e) {
        lastError = e;

        debugPrint(
          'HospitalService: '
              '${e.statusCode} from $url',
        );
      } catch (e) {
        lastError = e;

        debugPrint(
          'HospitalService: '
              'request failed from $url: $e',
        );
      }
    }

    //========================================================
    // FALLBACK TO EXPIRED CACHE
    //
    // This is useful when Overpass is temporarily unavailable.
    //========================================================

    final oldCache =
    _cache[cacheKey];

    if (oldCache != null &&
        oldCache.hospitals.isNotEmpty) {
      debugPrint(
        'HospitalService: '
            'all servers failed, using expired cache',
      );

      return List<NearbyHospitalModel>.from(
        oldCache.hospitals,
      );
    }

    //========================================================
    // NOTHING AVAILABLE
    //========================================================

    debugPrint(
      'HospitalService: all Overpass servers failed: '
          '$lastError',
    );

    return [];
  }

  //==========================================================
  // REQUEST ONE OVERPASS SERVER
  //==========================================================

  Future<List<NearbyHospitalModel>>
  _requestHospitals({
    required String url,
    required String query,
    required double latitude,
    required double longitude,
  }) async {
    debugPrint(
      'HospitalService: requesting $url',
    );

    final response = await _client
        .post(
      Uri.parse(url),
      headers: {
        'Content-Type':
        'application/x-www-form-urlencoded',
        'Accept':
        'application/json',
        'User-Agent':
        'HealthCareAI/1.0 (Flutter college project)',
      },
      body: {
        'data': query,
      },
    )
        .timeout(
      _requestTimeout,
    );

    debugPrint(
      'HospitalService: '
          '${response.statusCode} from $url',
    );

    if (response.statusCode != 200) {
      throw _OverpassException(
        response.statusCode,
        'Hospital API returned status '
            '${response.statusCode}',
      );
    }

    //========================================================
    // DECODE JSON
    //========================================================

    final dynamic decoded;

    try {
      decoded =
          jsonDecode(response.body);
    } catch (_) {
      throw Exception(
        'Invalid hospital API JSON response.',
      );
    }

    if (decoded is! Map<String, dynamic>) {
      throw Exception(
        'Invalid hospital API response.',
      );
    }

    //========================================================
    // READ ELEMENTS
    //========================================================

    final dynamic elements =
    decoded['elements'];

    if (elements is! List) {
      throw Exception(
        'Hospital API returned no elements.',
      );
    }

    //========================================================
    // PARSE HOSPITALS
    //========================================================

    final List<NearbyHospitalModel>
    hospitals = [];

    for (final dynamic element
    in elements) {
      if (element is! Map) {
        continue;
      }

      final hospital =
      _parseHospital(element);

      if (hospital != null) {
        hospitals.add(hospital);
      }
    }

    //========================================================
    // REMOVE DUPLICATES
    //========================================================

    final Map<String, NearbyHospitalModel>
    uniqueHospitals = {};

    for (final hospital in hospitals) {
      uniqueHospitals[hospital.id] =
          hospital;
    }

    final result =
    uniqueHospitals.values.toList();

    //========================================================
    // SORT BY APPROXIMATE DISTANCE
    //========================================================

    result.sort(
          (a, b) {
        final distanceA =
        _approximateDistanceSquared(
          latitude,
          longitude,
          a.latitude,
          a.longitude,
        );

        final distanceB =
        _approximateDistanceSquared(
          latitude,
          longitude,
          b.latitude,
          b.longitude,
        );

        final distanceComparison =
        distanceA.compareTo(
          distanceB,
        );

        if (distanceComparison != 0) {
          return distanceComparison;
        }

        return a.name
            .toLowerCase()
            .compareTo(
          b.name.toLowerCase(),
        );
      },
    );

    //========================================================
    // LIMIT RESULT COUNT
    //========================================================

    final limited =
    result.length > _maxResults
        ? result.sublist(
      0,
      _maxResults,
    )
        : result;

    debugPrint(
      'HospitalService: '
          '${limited.length} hospitals found',
    );

    return limited;
  }

  //==========================================================
  // CACHE KEY
  //==========================================================

  String _cacheKey(
      double latitude,
      double longitude,
      ) {
    return '${latitude.toStringAsFixed(2)}_'
        '${longitude.toStringAsFixed(2)}';
  }

  //==========================================================
  // SAVE CACHE
  //==========================================================

  void _saveToCache(
      String key,
      List<NearbyHospitalModel> hospitals,
      ) {
    _cache[key] =
        _HospitalCacheEntry(
          hospitals:
          List<NearbyHospitalModel>.from(
            hospitals,
          ),
          expiresAt:
          DateTime.now().add(
            _cacheDuration,
          ),
        );

    // Prevent unlimited memory growth.
    if (_cache.length > 20) {
      _cache.remove(
        _cache.keys.first,
      );
    }
  }

  //==========================================================
  // APPROXIMATE DISTANCE
  //==========================================================

  double _approximateDistanceSquared(
      double startLatitude,
      double startLongitude,
      double endLatitude,
      double endLongitude,
      ) {
    const double latScale = 111.0;

    final double lonScale =
        111.0 *
            math.cos(
              startLatitude *
                  math.pi /
                  180,
            );

    final double latDifference =
        (endLatitude - startLatitude) *
            latScale;

    final double lonDifference =
        (endLongitude - startLongitude) *
            lonScale;

    return latDifference *
        latDifference +
        lonDifference *
            lonDifference;
  }

  //==========================================================
  // PARSE HOSPITAL
  //==========================================================

  NearbyHospitalModel? _parseHospital(
      Map element,
      ) {
    final String type =
        element['type']?.toString() ??
            'unknown';

    final String osmId =
        element['id']?.toString() ??
            '';

    if (osmId.isEmpty) {
      return null;
    }

    final String id =
        'osm_${type}_$osmId';

    //========================================================
    // TAGS
    //========================================================

    final dynamic rawTags =
    element['tags'];

    final Map<String, dynamic> tags =
    rawTags is Map
        ? Map<String, dynamic>.from(
      rawTags,
    )
        : <String, dynamic>{};

    //========================================================
    // NAME
    //========================================================

    final String name =
        _firstNonEmpty([
          tags['name'],
          tags['official_name'],
          tags['short_name'],
        ]) ??
            'Unnamed Hospital';

    //========================================================
    // COORDINATES
    //========================================================

    double? hospitalLatitude;
    double? hospitalLongitude;

    if (element['lat'] is num &&
        element['lon'] is num) {
      hospitalLatitude =
          (element['lat'] as num)
              .toDouble();

      hospitalLongitude =
          (element['lon'] as num)
              .toDouble();
    }

    if ((hospitalLatitude == null ||
        hospitalLongitude == null) &&
        element['center'] is Map) {
      final Map<String, dynamic>
      center =
      Map<String, dynamic>.from(
        element['center'] as Map,
      );

      if (center['lat'] is num &&
          center['lon'] is num) {
        hospitalLatitude =
            (center['lat'] as num)
                .toDouble();

        hospitalLongitude =
            (center['lon'] as num)
                .toDouble();
      }
    }

    if (hospitalLatitude == null ||
        hospitalLongitude == null) {
      return null;
    }

    //========================================================
    // ADDRESS
    //========================================================

    final List<String>
    addressParts = [];

    _addAddressPart(
      addressParts,
      tags['addr:housenumber'],
    );

    _addAddressPart(
      addressParts,
      tags['addr:street'],
    );

    _addAddressPart(
      addressParts,
      tags['addr:suburb'],
    );

    _addAddressPart(
      addressParts,
      tags['addr:city'],
    );

    _addAddressPart(
      addressParts,
      tags['addr:postcode'],
    );

    String address =
    addressParts.join(', ');

    if (address.isEmpty) {
      address =
          _firstNonEmpty([
            tags['description'],
            tags['operator'],
          ]) ??
              'Address unavailable';
    }

    //========================================================
    // PHONE
    //========================================================

    final String phone =
        _firstNonEmpty([
          tags['phone'],
          tags['contact:phone'],
          tags['mobile'],
          tags['contact:mobile'],
        ]) ??
            '';

    //========================================================
    // EMERGENCY
    //========================================================

    final bool? emergency =
    _parseBoolean(
      tags['emergency'],
    );

    //========================================================
    // SPECIALTIES
    //========================================================

    final List<String>
    specialties =
    _parseSpecialties(tags);

    return NearbyHospitalModel(
      id: id,
      name: name,
      address: address,
      phone: phone,
      latitude: hospitalLatitude,
      longitude: hospitalLongitude,
      rating: null,
      distanceKm: null,
      emergency: emergency,
      availableDoctors: null,
      specialties: specialties,
      image: '',
    );
  }

  //==========================================================
  // PARSE SPECIALTIES
  //==========================================================

  List<String> _parseSpecialties(
      Map<String, dynamic> tags,
      ) {
    final List<String>
    rawSpecialties = [];

    final List<dynamic>
    possibleValues = [
      tags['healthcare:speciality'],
      tags['healthcare:specialty'],
      tags['speciality'],
      tags['specialty'],
      tags['healthcare:specialities'],
      tags['healthcare:specialties'],
    ];

    for (final value
    in possibleValues) {
      if (value == null) {
        continue;
      }

      final String text =
      value.toString().trim();

      if (text.isEmpty) {
        continue;
      }

      rawSpecialties.add(text);
    }

    if (rawSpecialties.isEmpty) {
      return ['General Medicine'];
    }

    final Set<String>
    specialties = {};

    for (final rawValue
    in rawSpecialties) {
      final List<String> parts =
      rawValue.split(
        RegExp(r'[;,/]'),
      );

      for (final part in parts) {
        final String? normalized =
        _normalizeSpecialty(part);

        if (normalized != null) {
          specialties.add(
            normalized,
          );
        }
      }
    }

    if (specialties.isEmpty) {
      specialties.add(
        'General Medicine',
      );
    }

    return specialties.toList();
  }

  //==========================================================
  // NORMALIZE SPECIALTY
  //==========================================================

  String? _normalizeSpecialty(
      String value,
      ) {
    final String specialty =
    value
        .toLowerCase()
        .trim()
        .replaceAll('_', ' ')
        .replaceAll('-', ' ');

    if (specialty.isEmpty) {
      return null;
    }

    if (specialty.contains('cardio') ||
        specialty.contains('heart')) {
      return 'Cardiology';
    }

    if (specialty.contains('neuro') ||
        specialty.contains('brain')) {
      return 'Neurology';
    }

    if (specialty.contains('orthop') ||
        specialty.contains('bone') ||
        specialty.contains('trauma')) {
      return 'Orthopedics';
    }

    if (specialty.contains('dermat') ||
        specialty.contains('skin')) {
      return 'Dermatology';
    }

    if (specialty.contains('pediatr') ||
        specialty.contains('paediatr') ||
        specialty.contains('child')) {
      return 'Pediatrics';
    }

    if (specialty.contains('gyne') ||
        specialty.contains('gyna') ||
        specialty.contains('obstet')) {
      return 'Gynecology';
    }

    if (specialty.contains('general') ||
        specialty.contains(
          'internal medicine',
        ) ||
        specialty == 'medicine' ||
        specialty.contains(
          'primary care',
        )) {
      return 'General Medicine';
    }

    if (specialty.contains('surg') ||
        specialty.contains('surgical')) {
      return 'Surgery';
    }

    if (specialty.contains('oncolog') ||
        specialty.contains('cancer')) {
      return 'Oncology';
    }

    if (specialty == 'ent' ||
        specialty.contains(
          'ear nose',
        ) ||
        specialty.contains(
          'otorhinolaryng',
        )) {
      return 'ENT';
    }

    if (specialty.contains('gastro') ||
        specialty.contains(
          'digestive',
        )) {
      return 'Gastroenterology';
    }

    if (specialty.contains('pulmon') ||
        specialty.contains('respir') ||
        specialty.contains('chest')) {
      return 'Pulmonology';
    }

    if (specialty.contains('nephro') ||
        specialty.contains('kidney')) {
      return 'Nephrology';
    }

    if (specialty.contains('urolog') ||
        specialty.contains('urinary')) {
      return 'Urology';
    }

    if (specialty.contains('ophthalm') ||
        specialty.contains('eye') ||
        specialty.contains('ocular')) {
      return 'Ophthalmology';
    }

    return null;
  }

  //==========================================================
  // PARSE BOOLEAN
  //==========================================================

  bool? _parseBoolean(
      dynamic value,
      ) {
    if (value == null) {
      return null;
    }

    final String normalized =
    value
        .toString()
        .toLowerCase()
        .trim();

    if (normalized == 'yes' ||
        normalized == 'true' ||
        normalized == '1') {
      return true;
    }

    if (normalized == 'no' ||
        normalized == 'false' ||
        normalized == '0') {
      return false;
    }

    return null;
  }

  //==========================================================
  // FIRST NON-EMPTY VALUE
  //==========================================================

  String? _firstNonEmpty(
      List<dynamic> values,
      ) {
    for (final value in values) {
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

  //==========================================================
  // ADD ADDRESS PART
  //==========================================================

  void _addAddressPart(
      List<String> parts,
      dynamic value,
      ) {
    if (value == null) {
      return;
    }

    final String text =
    value.toString().trim();

    if (text.isNotEmpty) {
      parts.add(text);
    }
  }

  //==========================================================
  // DISPOSE
  //==========================================================

  void dispose() {
    _client.close();
    _cache.clear();
  }
}

//============================================================
// CACHE ENTRY
//============================================================

class _HospitalCacheEntry {
  final List<NearbyHospitalModel>
  hospitals;

  final DateTime expiresAt;

  const _HospitalCacheEntry({
    required this.hospitals,
    required this.expiresAt,
  });
}

//============================================================
// OVERPASS ERROR
//============================================================

class _OverpassException
    implements Exception {
  final int statusCode;
  final String message;

  const _OverpassException(
      this.statusCode,
      this.message,
      );

  @override
  String toString() => message;
}