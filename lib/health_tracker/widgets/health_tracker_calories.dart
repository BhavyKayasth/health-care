import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'health_tracker_components.dart';

class HealthTrackerCalories
    extends StatelessWidget {
  const HealthTrackerCalories({
    super.key,
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
            Color(0xFFF97316),
            Color(0xFFFBBF24),
          ],
        ),

        borderRadius:
        BorderRadius.circular(
          28,
        ),
      ),

      child: Column(
        children: [

          Row(
            children: [

              const Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    Row(
                      children: [

                        Icon(
                          LucideIcons.flame,
                          color:
                          Color(0xFFFFEDD5),
                          size: 15,
                        ),

                        SizedBox(width: 7),

                        Text(
                          'Calories Burned',

                          style:
                          TextStyle(
                            color:
                            Color(0xFFFFEDD5),
                            fontSize: 13,
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 3),

                    Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.end,

                      children: [

                        Text(
                          '420',

                          style:
                          TextStyle(
                            color:
                            Colors.white,
                            fontSize: 40,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),

                        SizedBox(width: 5),

                        Padding(
                          padding:
                          EdgeInsets.only(
                            bottom: 5,
                          ),

                          child: Text(
                            'kcal',

                            style:
                            TextStyle(
                              color:
                              Color(0xFFFFE4C7),
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),

                    Text(
                      'Goal: 600 kcal · 70% reached',

                      style:
                      TextStyle(
                        color:
                        Color(0xFFFFE4C7),
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                width: 76,
                height: 76,

                child: CustomPaint(
                  painter:
                  CircularProgressPainter(
                    progress: .70,
                  ),

                  child: const Center(
                    child: Text(
                      '70%',

                      style: TextStyle(
                        color:
                        Colors.white,
                        fontSize: 13,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          const Row(
            children: [

              Expanded(
                child: MacroStat(
                  value: '180g',
                  label: 'Carbs',
                ),
              ),

              SizedBox(width: 5),

              Expanded(
                child: MacroStat(
                  value: '45g',
                  label: 'Protein',
                ),
              ),

              SizedBox(width: 5),

              Expanded(
                child: MacroStat(
                  value: '28g',
                  label: 'Fat',
                ),
              ),

              SizedBox(width: 5),

              Expanded(
                child: MacroStat(
                  value: '12g',
                  label: 'Fiber',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}