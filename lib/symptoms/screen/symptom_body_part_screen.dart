// lib/medicines/screens/symptoms_analyzer/symptom_body_part_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/symptoms_analyzer_controller.dart';


class SymptomBodyPartScreen extends ConsumerWidget {
  const SymptomBodyPartScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(
      symptomsAnalyzerControllerProvider.notifier,
    );

    final bodyParts =
        SymptomsAnalyzerController.bodyParts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _StepTitle(
          title: 'Where do you feel symptoms?',
          subtitle:
          'Select the affected body area to get started',
        ),

        GridView.builder(
          shrinkWrap: true,
          physics:
          const NeverScrollableScrollPhysics(),
          itemCount: bodyParts.length,
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.92,
          ),
          itemBuilder: (context, index) {
            final part = bodyParts[index];

            return GestureDetector(
              onTap: () {
                controller.selectBodyPart(
                  part.id,
                );
              },
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xffe5e7eb),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x10000000),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(part.colors[0]),
                            Color(part.colors[1]),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius:
                        BorderRadius.circular(18),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x22000000),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        part.icon,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      part.label,
                      style: const TextStyle(
                        color: Color(0xff374151),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            )
                .animate()
                .fadeIn(
              delay: (index * 60).ms,
              duration: 300.ms,
            )
                .slideY(
              begin: 0.12,
              end: 0,
            );
          },
        ),

        const SizedBox(height: 16),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xffeff6ff),
            borderRadius:
            BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xffbfdbfe),
            ),
          ),
          child: const Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline,
                color: Color(0xff3b82f6),
                size: 19,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'This tool provides general health guidance only. It is not a substitute for professional medical advice, diagnosis, or treatment.',
                  style: TextStyle(
                    color: Color(0xff1d4ed8),
                    fontSize: 11,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

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
      padding: const EdgeInsets.only(
        bottom: 20,
      ),
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