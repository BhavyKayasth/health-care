import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'health_tracker_components.dart';

class HealthTrackerHeartRate
    extends StatelessWidget {
  final int heartRate;

  const HealthTrackerHeartRate({
    super.key,
    required this.heartRate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.all(20),

      decoration:
      BoxDecoration(
        gradient:
        const LinearGradient(
          colors: [
            Color(0xFFEF4444),
            Color(0xFFF43F5E),
            Color(0xFFDB2777),
          ],
        ),

        borderRadius:
        BorderRadius.circular(28),

        boxShadow: const [
          BoxShadow(
            color:
            Color(0x22000000),
            blurRadius: 10,
            offset:
            Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        children: [

          Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    const Row(
                      children: [

                        Icon(
                          LucideIcons.heart,
                          color:
                          Color(0xFFFECACA),
                          size: 15,
                        ),

                        SizedBox(width: 7),

                        Text(
                          'Heart Rate',

                          style: TextStyle(
                            color:
                            Color(0xFFFECACA),
                            fontSize: 13,
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 3),

                    Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.end,

                      children: [

                        Text(
                          '$heartRate',

                          style:
                          const TextStyle(
                            color:
                            Colors.white,
                            fontSize: 44,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),

                        const SizedBox(width: 5),

                        const Padding(
                          padding:
                          EdgeInsets.only(
                            bottom: 6,
                          ),

                          child: Text(
                            'BPM',

                            style: TextStyle(
                              color:
                              Color(0xFFFBCFE8),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),

                    Text(
                      heartRate < 60
                          ? '⚠ Below normal'
                          : heartRate < 100
                          ? '✓ Normal range'
                          : '⚠ Elevated',

                      style:
                      const TextStyle(
                        color:
                        Color(0xFFFBCFE8),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: 64,
                height: 64,

                decoration:
                BoxDecoration(
                  color:
                  Colors.white
                      .withOpacity(
                    0.10,
                  ),
                  shape:
                  BoxShape.circle,
                ),

                child: const Icon(
                  LucideIcons.heart,
                  color: Colors.white,
                  size: 31,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Container(
            height: 56,
            width: double.infinity,

            padding:
            const EdgeInsets.all(8),

            decoration:
            BoxDecoration(
              color:
              Colors.white.withOpacity(
                0.10,
              ),

              borderRadius:
              BorderRadius.circular(
                12,
              ),
            ),

            child: CustomPaint(
              painter:
              EcgPainter(),
            ),
          ),

          const SizedBox(height: 10),

          const Row(
            children: [

              Expanded(
                child: HeartStat(
                  value: '58',
                  label: 'Min',
                ),
              ),

              SizedBox(width: 5),

              Expanded(
                child: HeartStat(
                  value: '72',
                  label: 'Avg',
                ),
              ),

              SizedBox(width: 5),

              Expanded(
                child: HeartStat(
                  value: '98',
                  label: 'Max',
                ),
              ),

              SizedBox(width: 5),

              Expanded(
                child: HeartStat(
                  value: '62',
                  label: 'Resting',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}