import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'health_tracker_components.dart';

class HealthTrackerHydration
    extends StatelessWidget {
  final int waterGlasses;
  final ValueChanged<int> onWaterChanged;

  const HealthTrackerHydration({
    super.key,
    required this.waterGlasses,
    required this.onWaterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TrackerWhiteCard(
      child: Column(
        children: [

          const Row(
            children: [

              Icon(
                LucideIcons.droplets,
                color:
                Color(0xFF06B6D4),
                size: 20,
              ),

              SizedBox(width: 9),

              Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  Text(
                    'Hydration',

                    style: TextStyle(
                      color:
                      Color(0xFF1E3A8A),
                      fontWeight:
                      FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  Text(
                    'Daily water intake',

                    style: TextStyle(
                      color:
                      Color(0xFF60A5FA),
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 15),

          Row(
            children: [

              SizedBox(
                width: 72,
                height: 112,

                child: CustomPaint(
                  painter:
                  BottlePainter(
                    fill:
                    waterGlasses / 8,
                  ),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    RichText(
                      text:
                      TextSpan(
                        children: [

                          TextSpan(
                            text:
                            '$waterGlasses',

                            style:
                            const TextStyle(
                              color:
                              Color(0xFF1E3A8A),
                              fontSize: 29,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),

                          const TextSpan(
                            text:
                            ' / 8 glasses',

                            style:
                            TextStyle(
                              color:
                              Color(0xFF60A5FA),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      '${waterGlasses * 250} ml consumed',

                      style:
                      const TextStyle(
                        color:
                        Color(0xFF06B6D4),
                        fontSize: 11,
                        fontWeight:
                        FontWeight.w500,
                      ),
                    ),

                    Text(
                      waterGlasses < 8
                          ? '${(8 - waterGlasses) * 250} ml remaining'
                          : 'Daily goal reached! 🎉',

                      style:
                      const TextStyle(
                        color:
                        Color(0xFF93C5FD),
                        fontSize: 9,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children:
                      List.generate(
                        8,
                            (index) {
                          return Expanded(
                            child:
                            GestureDetector(
                              onTap: () {
                                onWaterChanged(
                                  index + 1,
                                );
                              },

                              child: Container(
                                margin:
                                const EdgeInsets
                                    .only(
                                  right: 3,
                                ),

                                height: 16,

                                decoration:
                                BoxDecoration(
                                  color: index <
                                      waterGlasses
                                      ? const Color(
                                    0xFF22C5EE,
                                  )
                                      : const Color(
                                    0xFFCFFAFE,
                                  ),

                                  borderRadius:
                                  BorderRadius.circular(
                                    4,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [

                        Expanded(
                          child:
                          TrackerActionButton(
                            icon:
                            LucideIcons.minus,
                            label:
                            'Remove',
                            background:
                            const Color(
                              0xFFFFF1F2,
                            ),
                            foreground:
                            const Color(
                              0xFFEF4444,
                            ),
                            onTap: () {
                              onWaterChanged(
                                math.max(
                                  0,
                                  waterGlasses - 1,
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(width: 7),

                        Expanded(
                          child:
                          TrackerActionButton(
                            icon:
                            LucideIcons.plus,
                            label:
                            'Add Glass',
                            background:
                            const Color(
                              0xFF06B6D4,
                            ),
                            foreground:
                            Colors.white,
                            onTap: () {
                              onWaterChanged(
                                math.min(
                                  8,
                                  waterGlasses + 1,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}