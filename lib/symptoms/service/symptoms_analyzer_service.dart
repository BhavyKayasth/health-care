// lib/medicines/services/symptoms_analyzer_service.dart

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/symptoms_analysis_model.dart';

class SymptomsAnalyzerService {
  static const String _baseUrl =
      'https://healthcare-ai-api.healthcare-ai-bhavy.workers.dev';

  Future<SymptomsAnalysisModel> analyze({
    required String bodyPart,
    required List<String> symptoms,
    required String duration,
    required int intensity,
  }) async {
    final response = await http
        .post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'action': 'analyze_symptoms',
        'bodyPart': bodyPart,
        'symptoms': symptoms,
        'duration': duration,
        'intensity': intensity,
      }),
    )
        .timeout(
      const Duration(seconds: 30),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Symptom analysis failed '
            '(${response.statusCode}): '
            '${response.body}',
      );
    }

    dynamic decodedResponse;

    try {
      decodedResponse = jsonDecode(response.body);
    } catch (_) {
      throw Exception(
        'Invalid response received from AI service.',
      );
    }

    if (decodedResponse is! Map<String, dynamic>) {
      throw Exception(
        'Invalid analysis response.',
      );
    }

    final analysis = decodedResponse['analysis'];

    if (analysis is! Map<String, dynamic>) {
      throw Exception(
        'AI analysis was not returned.',
      );
    }

    return SymptomsAnalysisModel.fromJson(
      analysis,
    );
  }
}