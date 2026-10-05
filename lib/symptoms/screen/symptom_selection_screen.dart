// lib/medicines/screens/symptoms_analyzer/symptom_selection_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../controller/symptoms_analyzer_controller.dart';

class SymptomSelectionScreen
    extends ConsumerStatefulWidget {
  const SymptomSelectionScreen({
    super.key,
  });

  @override
  ConsumerState<SymptomSelectionScreen>
  createState() =>
      _SymptomSelectionScreenState();
}

class _SymptomSelectionScreenState
    extends ConsumerState<SymptomSelectionScreen> {
  late final TextEditingController
  _customSymptomController;

  @override
  void initState() {
    super.initState();

    _customSymptomController =
        TextEditingController();
  }

  @override
  void dispose() {
    _customSymptomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(
      symptomsAnalyzerControllerProvider,
    );

    final controller = ref.read(
      symptomsAnalyzerControllerProvider
          .notifier,
    );

    final symptoms =
        controller.availableSymptoms;

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        const _StepTitle(
          title: 'Select your symptoms',
          subtitle:
          'Tap all that apply — be specific for better results',
        ),

        // ======================================================
        // COMMON SYMPTOMS
        // ======================================================

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
          symptoms.map((symptom) {
            final selected =
            state.selectedSymptoms
                .contains(symptom);

            return GestureDetector(
              onTap: () {
                controller.toggleSymptom(
                  symptom,
                );
              },
              child: AnimatedContainer(
                duration:
                const Duration(
                  milliseconds: 180,
                ),
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(
                    0xff3b82f6,
                  )
                      : Colors.white,
                  borderRadius:
                  BorderRadius.circular(
                    999,
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
                  boxShadow: selected
                      ? const [
                    BoxShadow(
                      color:
                      Color(
                        0x223b82f6,
                      ),
                      blurRadius: 8,
                      offset:
                      Offset(
                        0,
                        3,
                      ),
                    ),
                  ]
                      : null,
                ),
                child: Text(
                  symptom,
                  style: TextStyle(
                    color: selected
                        ? Colors.white
                        : const Color(
                      0xff4b5563,
                    ),
                    fontWeight:
                    FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 20),

        // ======================================================
        // CUSTOM SYMPTOM INPUT
        // ======================================================

        Row(
          children: [
            Expanded(
              child: Container(
                height: 48,
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(
                    999,
                  ),
                  border: Border.all(
                    color:
                    const Color(
                      0xffe5e7eb,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      LucideIcons.search,
                      size: 17,
                      color:
                      Color(0xff9ca3af),
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: TextField(
                        controller:
                        _customSymptomController,
                        onSubmitted: (_) {
                          _addCustomSymptom();
                        },
                        decoration:
                        const InputDecoration(
                          hintText:
                          'Add other symptom...',
                          border:
                          InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 8),

            GestureDetector(
              onTap:
              _addCustomSymptom,
              child: Container(
                width: 48,
                height: 48,
                decoration:
                const BoxDecoration(
                  color:
                  Color(0xff3b82f6),
                  shape:
                  BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.plus,
                  color:
                  Colors.white,
                ),
              ),
            ),
          ],
        ),

        // ======================================================
        // SELECTED SYMPTOMS
        // ======================================================

        if (state.selectedSymptoms.isNotEmpty) ...[
          const SizedBox(height: 18),

          Container(
            width: double.infinity,
            padding:
            const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.circular(
                18,
              ),
              border: Border.all(
                color:
                const Color(
                  0xffdbeafe,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Selected (${state.selectedSymptoms.length})',
                  style:
                  const TextStyle(
                    color:
                    Color(0xff6b7280),
                    fontWeight:
                    FontWeight.w600,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                  state.selectedSymptoms
                      .map(
                        (symptom) {
                      return Container(
                        padding:
                        const EdgeInsets
                            .symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration:
                        BoxDecoration(
                          color:
                          const Color(
                            0xffeff6ff,
                          ),
                          borderRadius:
                          BorderRadius
                              .circular(
                            999,
                          ),
                          border:
                          Border.all(
                            color:
                            const Color(
                              0xffbfdbfe,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisSize:
                          MainAxisSize.min,
                          children: [
                            Text(
                              symptom,
                              style:
                              const TextStyle(
                                color:
                                Color(
                                  0xff1d4ed8,
                                ),
                                fontSize:
                                13,
                                fontWeight:
                                FontWeight
                                    .w500,
                              ),
                            ),

                            const SizedBox(
                              width: 4,
                            ),

                            GestureDetector(
                              onTap: () {
                                controller
                                    .toggleSymptom(
                                  symptom,
                                );
                              },
                              child:
                              const Icon(
                                LucideIcons.x,
                                size: 14,
                                color:
                                Color(
                                  0xff60a5fa,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ).toList(),
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
                onTap:
                controller.goToSelect,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _gradientButton(
                text: 'Continue',
                onTap: state
                    .selectedSymptoms
                    .isEmpty
                    ? null
                    : controller
                    .goToDetails,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // ADD CUSTOM SYMPTOM
  // ============================================================

  void _addCustomSymptom() {
    final text =
    _customSymptomController.text.trim();

    if (text.isEmpty) {
      return;
    }

    ref
        .read(
      symptomsAnalyzerControllerProvider
          .notifier,
    )
        .addCustomSymptom(text);

    _customSymptomController.clear();
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
      const EdgeInsets.only(
        bottom: 20,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style:
            const TextStyle(
              color:
              Color(0xff1f2937),
              fontSize: 19,
              fontWeight:
              FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style:
            const TextStyle(
              color:
              Color(0xff6b7280),
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
            : const Color(
          0xfff3f4f6,
        ),
        borderRadius:
        BorderRadius.circular(
          16,
        ),
        boxShadow: enabled
            ? const [
          BoxShadow(
            color:
            Color(
              0x223b82f6,
            ),
            blurRadius: 8,
            offset:
            Offset(0, 4),
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
                : const Color(
              0xff9ca3af,
            ),
            fontSize: 14,
            fontWeight:
            FontWeight.w600,
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
        BorderRadius.circular(
          16,
        ),
        border: Border.all(
          color:
          const Color(
            0xffdbeafe,
          ),
          width: 1.4,
        ),
      ),
      child: Center(
        child: Text(
          text,
          style:
          const TextStyle(
            color:
            Color(0xff2563eb),
            fontSize: 13,
            fontWeight:
            FontWeight.w600,
          ),
        ),
      ),
    ),
  );
}