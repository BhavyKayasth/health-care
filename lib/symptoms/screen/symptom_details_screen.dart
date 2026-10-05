// lib/medicines/screens/symptoms_analyzer/symptom_details_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/symptoms_analyzer_controller.dart';


class SymptomDetailsScreen extends ConsumerWidget {
  final VoidCallback onAnalyze;

  const SymptomDetailsScreen({
    super.key,
    required this.onAnalyze,
  });

  static const List<String> durations = [
    'Just started',
    '1-3 days',
    '4-7 days',
    '1-2 weeks',
    '2-4 weeks',
    'Over a month',
  ];

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final state = ref.watch(
      symptomsAnalyzerControllerProvider,
    );

    final controller = ref.read(
      symptomsAnalyzerControllerProvider.notifier,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _StepTitle(
          title: 'Tell us more',
          subtitle:
          'This helps our AI give a more accurate assessment',
        ),

        // ======================================================
        // DURATION
        // ======================================================

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xfff3f4f6),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0c000000),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              const Text(
                'How long have you had these symptoms?',
                style: TextStyle(
                  color: Color(0xff374151),
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 14),

              GridView.builder(
                shrinkWrap: true,
                physics:
                const NeverScrollableScrollPhysics(),
                itemCount: durations.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 2.5,
                ),
                itemBuilder: (
                    context,
                    index,
                    ) {
                  final value = durations[index];

                  final selected =
                      state.duration == value;

                  return GestureDetector(
                    onTap: () {
                      if (state.isLoading) {
                        return;
                      }

                      controller.setDuration(
                        value,
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(
                        milliseconds: 180,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xff3b82f6)
                            : const Color(0xfff9fafb),
                        borderRadius:
                        BorderRadius.circular(
                          12,
                        ),
                        border: Border.all(
                          color: selected
                              ? const Color(
                            0xff3b82f6,
                          )
                              : const Color(
                            0xffe5e7eb,
                          ),
                        ),
                      ),
                      child: Text(
                        value,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: selected
                              ? Colors.white
                              : const Color(
                            0xff4b5563,
                          ),
                          fontSize: 12,
                          fontWeight:
                          FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // ======================================================
        // INTENSITY
        // ======================================================

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
            BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xfff3f4f6),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0c000000),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,
                children: [
                  const Text(
                    'Pain / Discomfort Level',
                    style: TextStyle(
                      color: Color(0xff374151),
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${state.intensity}/10',
                    style: TextStyle(
                      color: state.intensity <= 3
                          ? Colors.green
                          : state.intensity <= 6
                          ? Colors.amber
                          : Colors.red,
                      fontSize: 18,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ],
              ),

              Slider(
                min: 1,
                max: 10,
                divisions: 9,
                value:
                state.intensity.toDouble(),
                activeColor: Colors.blue,
                onChanged: state.isLoading
                    ? null
                    : (value) {
                  controller
                      .setIntensity(
                    value,
                  );
                },
              ),

              const Row(
                mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,
                children: [
                  Text(
                    'Mild',
                    style: TextStyle(
                      fontSize: 11,
                      color:
                      Color(0xff9ca3af),
                    ),
                  ),
                  Text(
                    'Moderate',
                    style: TextStyle(
                      fontSize: 11,
                      color:
                      Color(0xff9ca3af),
                    ),
                  ),
                  Text(
                    'Severe',
                    style: TextStyle(
                      fontSize: 11,
                      color:
                      Color(0xff9ca3af),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Row(
                children: List.generate(
                  10,
                      (index) {
                    final active =
                        index <
                            state.intensity;

                    final color = index < 3
                        ? Colors.green
                        : index < 6
                        ? Colors.amber
                        : Colors.red;

                    return Expanded(
                      child:
                      AnimatedContainer(
                        duration:
                        const Duration(
                          milliseconds: 150,
                        ),
                        height: 8,
                        margin:
                        EdgeInsets.only(
                          right: index == 9
                              ? 0
                              : 3,
                        ),
                        decoration:
                        BoxDecoration(
                          color: active
                              ? color
                              : const Color(
                            0xfff3f4f6,
                          ),
                          borderRadius:
                          BorderRadius
                              .circular(
                            8,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        // ======================================================
        // ERROR MESSAGE
        // ======================================================

        if (state.errorMessage != null) ...[
          const SizedBox(height: 14),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xfffff1f2),
              borderRadius:
              BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xfffecdd3),
              ),
            ),
            child: Row(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Color(0xffe11d48),
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    state.errorMessage!,
                    style: const TextStyle(
                      color: Color(0xffbe123c),
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 22),

        // ======================================================
        // BUTTONS
        // ======================================================

        Row(
          children: [
            Expanded(
              child: _outlineButton(
                text: 'Back',
                onTap: state.isLoading
                    ? null
                    : controller.goToSymptoms,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _gradientButton(
                text: state.isLoading
                    ? 'Analyzing...'
                    : 'Analyze',
                onTap: state.isLoading
                    ? null
                    : onAnalyze,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ============================================================
// STEP TITLE
// ============================================================

class _StepTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _StepTitle({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xff1f2937),
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xff6b7280),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// GRADIENT BUTTON
// ============================================================

Widget _gradientButton({
  required String text,
  required VoidCallback? onTap,
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
        boxShadow: enabled
            ? const [
          BoxShadow(
            color: Color(0x223b82f6),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ]
            : null,
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: enabled
                ? Colors.white
                : const Color(0xff9ca3af),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
  );
}

// ============================================================
// OUTLINE BUTTON
// ============================================================

Widget _outlineButton({
  required String text,
  required VoidCallback? onTap,
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
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xff2563eb),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
  );
}