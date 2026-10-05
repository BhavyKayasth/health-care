// lib/medicines/screens/symptoms_analyzer/symptoms_analyzer_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../controller/symptoms_analyzer_controller.dart';
import '../model/symptoms_analysis_model.dart';
import 'symptom_analyzing_screen.dart';
import 'symptom_body_part_screen.dart';
import 'symptom_details_screen.dart';
import 'symptom_results_screen.dart';
import 'symptom_selection_screen.dart';

class SymptomsAnalyzerScreen extends ConsumerWidget {
  final VoidCallback onBack;
  final VoidCallback? onBookAppointment;
  final VoidCallback? onCallDoctor;

  const SymptomsAnalyzerScreen({
    super.key,
    required this.onBack,
    this.onBookAppointment,
    this.onCallDoctor,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final state = ref.watch(
      symptomsAnalyzerControllerProvider,
    );

    return Scaffold(
      backgroundColor: const Color(0xfff0f7ff),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(
              ref,
              state,
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  24,
                  16,
                  32,
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(
                    milliseconds: 350,
                  ),
                  switchInCurve:
                  Curves.easeOutCubic,
                  switchOutCurve:
                  Curves.easeInCubic,
                  transitionBuilder: (
                      child,
                      animation,
                      ) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position:
                        Tween<Offset>(
                          begin:
                          const Offset(
                            0.08,
                            0,
                          ),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: _buildCurrentStep(
                    ref,
                    state,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader(
      WidgetRef ref,
      SymptomsAnalyzerState state,
      ) {
    final controller = ref.read(
      symptomsAnalyzerControllerProvider
          .notifier,
    );

    final stepIndex = controller.stepIndex;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        24,
        22,
        24,
        20,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xff3b82f6),
            Color(0xff06b6d4),
          ],
        ),
        borderRadius:
        BorderRadius.vertical(
          bottom: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 15,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  _handleBack(
                    ref,
                    state.step,
                  );
                },
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white
                        .withOpacity(0.20),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    LucideIcons.arrowLeft,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),

              const SizedBox(width: 14),

              const Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Symptoms Analyzer',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'AI-powered health assessment',
                      style: TextStyle(
                        color:
                        Color(0xffdbeafe),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ==================================================
          // PROGRESS
          // ==================================================

          Row(
            children: List.generate(
              4,
                  (index) {
                final active =
                    stepIndex >= index;

                return Expanded(
                  child:
                  AnimatedContainer(
                    duration:
                    const Duration(
                      milliseconds: 500,
                    ),
                    margin: EdgeInsets.only(
                      right: index == 3
                          ? 0
                          : 8,
                    ),
                    height: 6,
                    decoration:
                    BoxDecoration(
                      color: active
                          ? Colors.white
                          : Colors.white
                          .withOpacity(
                        0.30,
                      ),
                      borderRadius:
                      BorderRadius
                          .circular(
                        20,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BACK NAVIGATION
  // ============================================================

  void _handleBack(
      WidgetRef ref,
      AnalyzerStep step,
      ) {
    final controller = ref.read(
      symptomsAnalyzerControllerProvider
          .notifier,
    );

    switch (step) {
      case AnalyzerStep.select:
      // Leave the Symptoms Analyzer.
        onBack();
        break;

      case AnalyzerStep.symptoms:
      // Go back to body-part selection.
        controller.goToSelect();
        break;

      case AnalyzerStep.details:
      // Go back to symptom selection.
        controller.goToSymptoms();
        break;

      case AnalyzerStep.analyzing:
      // Do not allow accidental cancellation
      // while the AI request is running.
        break;

      case AnalyzerStep.results:
      // Go back to details.
        controller.goToDetails();
        break;
    }
  }

  // ============================================================
  // CURRENT STEP
  // ============================================================

  Widget _buildCurrentStep(
      WidgetRef ref,
      SymptomsAnalyzerState state,
      ) {
    switch (state.step) {
      case AnalyzerStep.select:
        return const SymptomBodyPartScreen(
          key: ValueKey('select'),
        );

      case AnalyzerStep.symptoms:
        return const SymptomSelectionScreen(
          key: ValueKey('symptoms'),
        );

      case AnalyzerStep.details:
        return SymptomDetailsScreen(
          key: const ValueKey('details'),
          onAnalyze: () {
            ref
                .read(
              symptomsAnalyzerControllerProvider
                  .notifier,
            )
                .startAnalyzing();
          },
        );

      case AnalyzerStep.analyzing:
        return const SymptomAnalyzingScreen(
          key: ValueKey('analyzing'),
        );

      case AnalyzerStep.results:
        return SymptomResultsScreen(
          key: const ValueKey('results'),
          onBookAppointment:
          onBookAppointment,
          onCallDoctor:
          onCallDoctor,
        );
    }
  }
}