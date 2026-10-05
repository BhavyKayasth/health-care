// lib/medicines/controller/symptoms_analyzer_controller.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../model/symptoms_analysis_model.dart';
import '../service/symptoms_analyzer_service.dart';

class SymptomsAnalyzerState {
  final AnalyzerStep step;
  final String? selectedBodyPart;
  final List<String> selectedSymptoms;
  final String duration;
  final int intensity;
  final SymptomsAnalysisModel? analysisResult;
  final bool showDosDetails;
  final bool isLoading;
  final String? errorMessage;

  const SymptomsAnalyzerState({
    this.step = AnalyzerStep.select,
    this.selectedBodyPart,
    this.selectedSymptoms = const [],
    this.duration = '1-3 days',
    this.intensity = 5,
    this.analysisResult,
    this.showDosDetails = false,
    this.isLoading = false,
    this.errorMessage,
  });

  SymptomsAnalyzerState copyWith({
    AnalyzerStep? step,
    String? selectedBodyPart,
    List<String>? selectedSymptoms,
    String? duration,
    int? intensity,
    SymptomsAnalysisModel? analysisResult,
    bool clearAnalysisResult = false,
    bool? showDosDetails,
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return SymptomsAnalyzerState(
      step: step ?? this.step,
      selectedBodyPart:
      selectedBodyPart ?? this.selectedBodyPart,
      selectedSymptoms:
      selectedSymptoms ?? this.selectedSymptoms,
      duration: duration ?? this.duration,
      intensity: intensity ?? this.intensity,
      analysisResult: clearAnalysisResult
          ? null
          : (analysisResult ?? this.analysisResult),
      showDosDetails:
      showDosDetails ?? this.showDosDetails,
      isLoading:
      isLoading ?? this.isLoading,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }
}

// ============================================================
// BODY PART ITEM
// ============================================================

class BodyPartItem {
  final String id;
  final String label;
  final IconData icon;
  final List<int> colors;

  const BodyPartItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.colors,
  });
}

// ============================================================
// CONTROLLER
// ============================================================

class SymptomsAnalyzerController
    extends StateNotifier<SymptomsAnalyzerState> {
  SymptomsAnalyzerController()
      : super(const SymptomsAnalyzerState());

  // ============================================================
  // SERVICE
  // ============================================================

  final SymptomsAnalyzerService _service =
  SymptomsAnalyzerService();

  // ============================================================
  // BODY PARTS
  // ============================================================

  static const List<BodyPartItem> bodyParts = [
    BodyPartItem(
      id: 'head',
      label: 'Head',
      icon: LucideIcons.brain,
      colors: [
        0xffa78bfa,
        0xff7c3aed,
      ],
    ),
    BodyPartItem(
      id: 'chest',
      label: 'Chest',
      icon: LucideIcons.heart,
      colors: [
        0xfff87171,
        0xffdc2626,
      ],
    ),
    BodyPartItem(
      id: 'abdomen',
      label: 'Stomach',
      icon: LucideIcons.activity,
      colors: [
        0xfffb923c,
        0xffea580c,
      ],
    ),
    BodyPartItem(
      id: 'respiratory',
      label: 'Breathing',
      icon: LucideIcons.wind,
      colors: [
        0xff60a5fa,
        0xff2563eb,
      ],
    ),
    BodyPartItem(
      id: 'musculo',
      label: 'Muscles',
      icon: LucideIcons.bone,
      colors: [
        0xff4ade80,
        0xff16a34a,
      ],
    ),
    BodyPartItem(
      id: 'fever',
      label: 'Fever',
      icon: LucideIcons.thermometer,
      colors: [
        0xfffacc15,
        0xfff97316,
      ],
    ),
    BodyPartItem(
      id: 'eyes',
      label: 'Eyes',
      icon: LucideIcons.eye,
      colors: [
        0xff22d3ee,
        0xff0891b2,
      ],
    ),
    BodyPartItem(
      id: 'general',
      label: 'General',
      icon: LucideIcons.stethoscope,
      colors: [
        0xff818cf8,
        0xff4f46e5,
      ],
    ),
  ];

  // ============================================================
  // COMMON SYMPTOMS
  // ============================================================

  static const Map<String, List<String>> commonSymptoms = {
    'head': [
      'Headache',
      'Migraine',
      'Dizziness',
      'Nausea',
      'Fainting',
      'Memory issues',
      'Confusion',
      'Head pressure',
    ],
    'chest': [
      'Chest pain',
      'Palpitations',
      'Rapid heartbeat',
      'Chest tightness',
      'Irregular heartbeat',
      'Chest pressure',
    ],
    'abdomen': [
      'Stomach pain',
      'Bloating',
      'Nausea',
      'Vomiting',
      'Diarrhea',
      'Constipation',
      'Acid reflux',
      'Loss of appetite',
    ],
    'respiratory': [
      'Shortness of breath',
      'Cough',
      'Wheezing',
      'Chest tightness',
      'Runny nose',
      'Sore throat',
      'Congestion',
    ],
    'musculo': [
      'Joint pain',
      'Muscle aches',
      'Back pain',
      'Stiffness',
      'Swelling',
      'Weakness',
      'Cramps',
      'Numbness',
    ],
    'fever': [
      'High fever',
      'Chills',
      'Sweating',
      'Body ache',
      'Fatigue',
      'Shivering',
      'Night sweats',
    ],
    'eyes': [
      'Blurred vision',
      'Eye pain',
      'Redness',
      'Itching',
      'Discharge',
      'Sensitivity to light',
      'Double vision',
    ],
    'general': [
      'Fatigue',
      'Weakness',
      'Weight loss',
      'Insomnia',
      'Anxiety',
      'Depression',
      'Loss of taste',
      'Loss of smell',
    ],
  };

  // ============================================================
  // GETTERS
  // ============================================================

  List<String> get availableSymptoms {
    if (state.selectedBodyPart == null) {
      return [];
    }

    return commonSymptoms[state.selectedBodyPart] ?? [];
  }

  int get stepIndex {
    switch (state.step) {
      case AnalyzerStep.select:
        return 0;

      case AnalyzerStep.symptoms:
        return 1;

      case AnalyzerStep.details:
        return 2;

      case AnalyzerStep.analyzing:
        return 2;

      case AnalyzerStep.results:
        return 3;
    }
  }

  // ============================================================
  // BODY PART
  // ============================================================

  void selectBodyPart(String bodyPart) {
    state = state.copyWith(
      step: AnalyzerStep.symptoms,
      selectedBodyPart: bodyPart,
      selectedSymptoms: const [],
      clearAnalysisResult: true,
      clearErrorMessage: true,
    );
  }

  // ============================================================
  // SYMPTOMS
  // ============================================================

  void toggleSymptom(String symptom) {
    final symptoms = [
      ...state.selectedSymptoms,
    ];

    if (symptoms.contains(symptom)) {
      symptoms.remove(symptom);
    } else {
      symptoms.add(symptom);
    }

    state = state.copyWith(
      selectedSymptoms: symptoms,
      clearErrorMessage: true,
    );
  }

  void addCustomSymptom(String symptom) {
    final trimmed = symptom.trim();

    if (trimmed.isEmpty) {
      return;
    }

    if (state.selectedSymptoms.contains(trimmed)) {
      return;
    }

    state = state.copyWith(
      selectedSymptoms: [
        ...state.selectedSymptoms,
        trimmed,
      ],
      clearErrorMessage: true,
    );
  }

  // ============================================================
  // NAVIGATION
  // ============================================================

  void goToSelect() {
    state = state.copyWith(
      step: AnalyzerStep.select,
      clearErrorMessage: true,
    );
  }

  void goToSymptoms() {
    state = state.copyWith(
      step: AnalyzerStep.symptoms,
      clearErrorMessage: true,
    );
  }

  void goToDetails() {
    state = state.copyWith(
      step: AnalyzerStep.details,
      clearErrorMessage: true,
    );
  }

  // ============================================================
  // START ANALYSIS
  // ============================================================

  Future<void> startAnalyzing() async {
    // Prevent duplicate requests.
    if (state.isLoading) {
      return;
    }

    // Validate input.
    if (state.selectedBodyPart == null) {
      setError(
        'Please select a body part.',
      );
      return;
    }

    if (state.selectedSymptoms.isEmpty) {
      setError(
        'Please select at least one symptom.',
      );
      return;
    }

    // Show analyzing screen immediately.
    state = state.copyWith(
      step: AnalyzerStep.analyzing,
      isLoading: true,
      clearAnalysisResult: true,
      clearErrorMessage: true,
    );

    try {
      final result = await _service.analyze(
        bodyPart: state.selectedBodyPart!,
        symptoms: state.selectedSymptoms,
        duration: state.duration,
        intensity: state.intensity,
      );

      if (!mounted) {
        return;
      }

      showResults(result);
    } catch (e) {
      if (!mounted) {
        return;
      }

      final message = e
          .toString()
          .replaceFirst(
        'Exception: ',
        '',
      );

      setError(message);
    }
  }

  // ============================================================
  // SHOW RESULTS
  // ============================================================

  void showResults(
      SymptomsAnalysisModel result,
      ) {
    state = state.copyWith(
      step: AnalyzerStep.results,
      analysisResult: result,
      isLoading: false,
      clearErrorMessage: true,
    );
  }

  // ============================================================
  // DETAILS
  // ============================================================

  void setDuration(String duration) {
    state = state.copyWith(
      duration: duration,
      clearErrorMessage: true,
    );
  }

  void setIntensity(double intensity) {
    state = state.copyWith(
      intensity: intensity.round(),
      clearErrorMessage: true,
    );
  }

  // ============================================================
  // DO / DON'T DETAILS
  // ============================================================

  void toggleDosDetails() {
    state = state.copyWith(
      showDosDetails:
      !state.showDosDetails,
    );
  }

  // ============================================================
  // ERROR
  // ============================================================

  void setError(String message) {
    state = state.copyWith(
      step: AnalyzerStep.details,
      isLoading: false,
      errorMessage: message,
    );
  }

  void clearError() {
    state = state.copyWith(
      clearErrorMessage: true,
    );
  }

  // ============================================================
  // RESET
  // ============================================================

  void reset() {
    state = const SymptomsAnalyzerState();
  }
}

// ============================================================
// PROVIDER
// ============================================================

final symptomsAnalyzerControllerProvider =
StateNotifierProvider<
    SymptomsAnalyzerController,
    SymptomsAnalyzerState>(
      (ref) {
    return SymptomsAnalyzerController();
  },
);