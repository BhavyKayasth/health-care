// lib/medicines/screens/symptoms_analyzer/symptom_analyzing_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SymptomAnalyzingScreen
    extends StatelessWidget {
  const SymptomAnalyzingScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment:
      MainAxisAlignment.center,
      children: [
        const SizedBox(height: 45),

        SizedBox(
          width: 120,
          height: 120,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 112,
                height: 112,
                decoration:
                const BoxDecoration(
                  color: Color(0xffdbeafe),
                  shape: BoxShape.circle,
                ),
              )
                  .animate(
                onPlay: (controller) =>
                    controller.repeat(),
              )
                  .scale(
                begin:
                const Offset(1, 1),
                end: const Offset(
                  1.15,
                  1.15,
                ),
                duration: 1500.ms,
              ),

              Container(
                width: 112,
                height: 112,
                decoration:
                const BoxDecoration(
                  color: Color(0xffbfdbfe),
                  shape: BoxShape.circle,
                ),
              )
                  .animate(
                onPlay: (controller) =>
                    controller.repeat(),
              )
                  .scale(
                begin:
                const Offset(1, 1),
                end: const Offset(
                  1.3,
                  1.3,
                ),
                duration: 1500.ms,
              )
                  .fadeOut(
                duration: 1500.ms,
              ),

              const Icon(
                Icons.sync,
                color: Color(0xff3b82f6),
                size: 50,
              )
                  .animate(
                onPlay: (controller) =>
                    controller.repeat(),
              )
                  .rotate(
                duration: 1000.ms,
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        const Text(
          'Analyzing Symptoms',
          style: TextStyle(
            color: Color(0xff1f2937),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        const Padding(
          padding:
          EdgeInsets.symmetric(
            horizontal: 30,
          ),
          child: Text(
            'Our AI is processing your symptoms and generating a health assessment...',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xff6b7280),
              fontSize: 14,
            ),
          ),
        ),

        const SizedBox(height: 32),

        ...[
          'Reviewing symptoms...',
          'Checking patterns...',
          'Generating report...',
        ].asMap().entries.map(
              (entry) {
            return Padding(
              padding:
              const EdgeInsets.only(
                bottom: 12,
              ),
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration:
                    const BoxDecoration(
                      color:
                      Color(0xff3b82f6),
                      shape: BoxShape.circle,
                    ),
                  )
                      .animate(
                    onPlay:
                        (controller) =>
                        controller.repeat(
                          reverse: true,
                        ),
                  )
                      .scale(
                    begin:
                    const Offset(
                      1,
                      1,
                    ),
                    end:
                    const Offset(
                      1.3,
                      1.3,
                    ),
                    delay:
                    (entry.key *
                        300)
                        .ms,
                    duration:
                    600.ms,
                  ),

                  const SizedBox(width: 12),

                  Text(
                    entry.value,
                    style:
                    const TextStyle(
                      color:
                      Color(0xff4b5563),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            );
          },
        ),

        const SizedBox(height: 45),
      ],
    );
  }
}