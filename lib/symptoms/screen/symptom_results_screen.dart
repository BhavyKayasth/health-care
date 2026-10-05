// lib/medicines/screens/symptoms_analyzer/symptom_results_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../controller/symptoms_analyzer_controller.dart';
import '../model/symptoms_analysis_model.dart';

class SymptomResultsScreen
    extends ConsumerWidget {
  final VoidCallback? onBookAppointment;
  final VoidCallback? onCallDoctor;

  const SymptomResultsScreen({
    super.key,
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

    final result = state.analysisResult;

    if (result == null) {
      return const SizedBox.shrink();
    }

    final config =
    _severityConfig(result.severity);

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        _buildSeverityCard(
          state,
          result,
          config,
        ),

        const SizedBox(height: 14),

        _buildConditions(result),

        const SizedBox(height: 14),

        _buildRecommendation(result),

        const SizedBox(height: 14),

        _buildDosAndDonts(
          ref,
          state,
          result,
        ),

        const SizedBox(height: 14),

        SizedBox(
          width: double.infinity,
          child: _gradientButton(
            text: 'Book Appointment',
            icon: LucideIcons.calendar,
            onTap: onBookAppointment,
          ),
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _outlineButton(
                text: 'Call Doctor',
                icon: LucideIcons.phone,
                onTap: onCallDoctor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _outlineButton(
                text: 'Reanalyze',
                icon: LucideIcons.activity,
                onTap: () {
                  ref
                      .read(
                    symptomsAnalyzerControllerProvider
                        .notifier,
                  )
                      .reset();
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xfff8fafc),
            borderRadius:
            BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xffe5e7eb),
            ),
          ),
          child: const Text(
            'Disclaimer: This AI assessment is for informational purposes only. Always consult a licensed medical professional for diagnosis and treatment.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xff6b7280),
              fontSize: 11,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSeverityCard(
      SymptomsAnalyzerState state,
      SymptomsAnalysisModel result,
      Map<String, dynamic> config,
      ) {
    final color = config['color'] as Color;
    final bg = config['bg'] as Color;
    final border = config['border'] as Color;
    final badgeBg = config['badgeBg'] as Color;
    final badgeText =
    config['badgeText'] as Color;
    final label = config['label'] as String;
    final icon = config['icon'] as IconData;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: bg,
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color: border,
        ),
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: bg,
              shape: BoxShape.circle,
              border: Border.all(
                color: border,
                width: 2,
              ),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight:
                    FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  result.urgency,
                  style: const TextStyle(
                    color: Color(0xff1f2937),
                    fontSize: 16,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: state.selectedSymptoms
                      .map(
                        (symptom) {
                      return Container(
                        padding:
                        const EdgeInsets
                            .symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration:
                        BoxDecoration(
                          color: badgeBg,
                          borderRadius:
                          BorderRadius
                              .circular(
                            999,
                          ),
                        ),
                        child: Text(
                          symptom,
                          style: TextStyle(
                            color: badgeText,
                            fontSize: 10,
                            fontWeight:
                            FontWeight.w500,
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConditions(
      SymptomsAnalysisModel result,
      ) {
    return _resultCard(
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          _sectionHeading(
            icon: LucideIcons.stethoscope,
            title: 'Possible Conditions',
          ),

          ...result.conditions
              .asMap()
              .entries
              .map(
                (entry) {
              return Container(
                padding:
                const EdgeInsets.symmetric(
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: entry.key ==
                          result.conditions.length - 1
                          ? Colors.transparent
                          : const Color(
                        0xfff3f4f6,
                      ),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 26,
                      height: 26,
                      decoration:
                      const BoxDecoration(
                        color: Color(0xffeff6ff),
                        shape: BoxShape.circle,
                      ),
                      alignment:
                      Alignment.center,
                      child: Text(
                        '${entry.key + 1}',
                        style:
                        const TextStyle(
                          color:
                          Color(0xff3b82f6),
                          fontSize: 11,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        entry.value,
                        style:
                        const TextStyle(
                          color:
                          Color(0xff374151),
                          fontSize: 13,
                          fontWeight:
                          FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 10),

          Container(
            width: double.infinity,
            padding:
            const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color:
              const Color(0xfffffbeb),
              borderRadius:
              BorderRadius.circular(12),
              border: Border.all(
                color:
                const Color(0xfffde68a),
              ),
            ),
            child: const Text(
              'These are possible conditions only. A doctor must confirm the actual diagnosis.',
              style: TextStyle(
                color:
                Color(0xffb45309),
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendation(
      SymptomsAnalysisModel result,
      ) {
    return _resultCard(
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          _sectionHeading(
            icon: LucideIcons.info,
            title: 'Recommendation',
          ),
          Text(
            result.recommendation,
            style: const TextStyle(
              color: Color(0xff6b7280),
              fontSize: 13,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDosAndDonts(
      WidgetRef ref,
      SymptomsAnalyzerState state,
      SymptomsAnalysisModel result,
      ) {
    final controller = ref.read(
      symptomsAnalyzerControllerProvider.notifier,
    );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0c000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: controller.toggleDosDetails,
            child: Padding(
              padding:
              const EdgeInsets.all(18),
              child: Row(
                children: [
                  const Icon(
                    LucideIcons.circleCheck,
                    color: Colors.green,
                    size: 18,
                  ),

                  const SizedBox(width: 8),

                  const Expanded(
                    child: Text(
                      "Do's & Don'ts",
                      style: TextStyle(
                        color:
                        Color(0xff1f2937),
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),

                  Icon(
                    state.showDosDetails
                        ? LucideIcons.chevronUp
                        : LucideIcons.chevronDown,
                    color:
                    const Color(0xff9ca3af),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          AnimatedCrossFade(
            firstChild:
            const SizedBox.shrink(),

            secondChild: Padding(
              padding:
              const EdgeInsets.fromLTRB(
                18,
                0,
                18,
                18,
              ),
              child: Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildDosColumn(
                      title: 'Do',
                      color: Colors.green,
                      items: result.doList,
                      icon:
                      LucideIcons.circleCheck,
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: _buildDosColumn(
                      title: "Don't",
                      color: Colors.red,
                      items: result.dontList,
                      icon: LucideIcons.x,
                    ),
                  ),
                ],
              ),
            ),

            crossFadeState:
            state.showDosDetails
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,

            duration: const Duration(
              milliseconds: 250,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDosColumn({
    required String title,
    required Color color,
    required List<String> items,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w700,
            fontSize: 11,
            letterSpacing: 1,
          ),
        ),

        const SizedBox(height: 8),

        ...items.map(
              (item) {
            return Padding(
              padding:
              const EdgeInsets.only(
                bottom: 8,
              ),
              child: Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Icon(
                    icon,
                    color:
                    color.withOpacity(0.75),
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      item,
                      style:
                      const TextStyle(
                        color:
                        Color(0xff6b7280),
                        fontSize: 11,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _resultCard({
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0c000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionHeading({
    required IconData icon,
    required String title,
  }) {
    return Padding(
      padding:
      const EdgeInsets.only(
        bottom: 12,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xff3b82f6),
            size: 17,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xff1f2937),
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _severityConfig(
      Severity severity,
      ) {
    switch (severity) {
      case Severity.low:
        return {
          'color': Colors.green.shade600,
          'bg': Colors.green.shade50,
          'border': Colors.green.shade200,
          'badgeBg': Colors.green.shade100,
          'badgeText': Colors.green.shade700,
          'label': 'Low Risk',
          'icon': LucideIcons.circleCheck,
        };

      case Severity.moderate:
        return {
          'color': Colors.amber.shade700,
          'bg': Colors.amber.shade50,
          'border': Colors.amber.shade200,
          'badgeBg': Colors.amber.shade100,
          'badgeText': Colors.amber.shade700,
          'label': 'Moderate Risk',
          'icon': LucideIcons.clock3,
        };

      case Severity.high:
        return {
          'color': Colors.orange.shade700,
          'bg': Colors.orange.shade50,
          'border': Colors.orange.shade200,
          'badgeBg': Colors.orange.shade100,
          'badgeText': Colors.orange.shade700,
          'label': 'High Risk',
          'icon': LucideIcons.triangleAlert,
        };

      case Severity.critical:
        return {
          'color': Colors.red.shade600,
          'bg': Colors.red.shade50,
          'border': Colors.red.shade200,
          'badgeBg': Colors.red.shade100,
          'badgeText': Colors.red.shade700,
          'label': 'Critical',
          'icon': LucideIcons.triangleAlert,
        };
    }
  }

  Widget _gradientButton({
    required String text,
    required VoidCallback? onTap,
    IconData? icon,
  }) {
    final enabled = onTap != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          gradient: enabled
              ? const LinearGradient(
            colors: [
              Color(0xff3b82f6),
              Color(0xff06b6d4),
            ],
          )
              : null,
          color: enabled
              ? null
              : const Color(0xfff3f4f6),
          borderRadius:
          BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: enabled
                    ? Colors.white
                    : const Color(
                  0xff9ca3af,
                ),
                size: 18,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: TextStyle(
                color: enabled
                    ? Colors.white
                    : const Color(
                  0xff9ca3af,
                ),
                fontSize: 14,
                fontWeight:
                FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _outlineButton({
    required String text,
    required VoidCallback? onTap,
    IconData? icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
          BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xffdbeafe),
            width: 1.4,
          ),
        ),
        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color:
                const Color(0xff2563eb),
                size: 17,
              ),
              const SizedBox(width: 7),
            ],
            Text(
              text,
              style: const TextStyle(
                color: Color(0xff2563eb),
                fontSize: 13,
                fontWeight:
                FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}