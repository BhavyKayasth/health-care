// lib/medicines/models/symptoms_analysis_model.dart

enum AnalyzerStep {
  select,
  symptoms,
  details,
  analyzing,
  results,
}

enum Severity {
  low,
  moderate,
  high,
  critical,
}

class SymptomsAnalysisModel {
  final Severity severity;
  final List<String> conditions;
  final String recommendation;
  final String urgency;
  final List<String> doList;
  final List<String> dontList;

  const SymptomsAnalysisModel({
    required this.severity,
    required this.conditions,
    required this.recommendation,
    required this.urgency,
    required this.doList,
    required this.dontList,
  });

  factory SymptomsAnalysisModel.fromJson(Map<String, dynamic> json) {
    return SymptomsAnalysisModel(
      severity: _severityFromString(
        json['severity']?.toString(),
      ),
      conditions: _stringList(json['conditions']),
      recommendation: json['recommendation']?.toString() ?? '',
      urgency: json['urgency']?.toString() ?? '',
      doList: _stringList(json['doList']),
      dontList: _stringList(json['dontList']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'severity': severity.name,
      'conditions': conditions,
      'recommendation': recommendation,
      'urgency': urgency,
      'doList': doList,
      'dontList': dontList,
    };
  }

  static Severity _severityFromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'low':
        return Severity.low;

      case 'moderate':
        return Severity.moderate;

      case 'high':
        return Severity.high;

      case 'critical':
        return Severity.critical;

      default:
        return Severity.moderate;
    }
  }

  static List<String> _stringList(dynamic value) {
    if (value is List) {
      return value
          .map((item) => item.toString())
          .where((item) => item.trim().isNotEmpty)
          .toList();
    }

    return [];
  }
}