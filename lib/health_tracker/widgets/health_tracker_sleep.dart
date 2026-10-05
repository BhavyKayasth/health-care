import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class HealthTrackerSleep extends StatelessWidget {
  const HealthTrackerSleep({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF7C3AED), Color(0xFF9333EA)],
        ),

        borderRadius: BorderRadius.circular(28),
      ),

      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Row(
                      children: [
                        Icon(
                          LucideIcons.moon,
                          color: Color(0xFFC7D2FE),
                          size: 15,
                        ),

                        SizedBox(width: 7),

                        Text(
                          'Sleep Tracker',

                          style: TextStyle(
                            color: Color(0xFFC7D2FE),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 3),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,

                      children: [
                        Text(
                          '7',

                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(width: 5),

                        Padding(
                          padding: EdgeInsets.only(bottom: 5),

                          child: Text(
                            'h 23m',

                            style: TextStyle(
                              color: Color(0xFFC7D2FE),
                              fontSize: 19,
                            ),
                          ),
                        ),
                      ],
                    ),

                    Text(
                      '11:15 PM – 6:38 AM',

                      style: TextStyle(color: Color(0xFFC7D2FE), fontSize: 9),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 10,
                ),

                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.10),

                  borderRadius: BorderRadius.circular(15),
                ),

                child: Column(
                  children: [
                    const Text(
                      'Good',

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Row(
                      children: List.generate(5, (index) {
                        return Container(
                          margin: const EdgeInsets.only(right: 2),

                          width: 5,
                          height: 15,

                          decoration: BoxDecoration(
                            color: index < 4
                                ? const Color(0xFFA5B4FC)
                                : Colors.white.withOpacity(0.20),

                            borderRadius: BorderRadius.circular(3),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      'Quality',

                      style: TextStyle(color: Color(0xFFA5B4FC), fontSize: 8),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Container(
            padding: const EdgeInsets.all(14),

            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.10),

              borderRadius: BorderRadius.circular(16),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const Text(
                  'Sleep Phases',

                  style: TextStyle(
                    color: Color(0xFFC7D2FE),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 9),

                ClipRRect(
                  borderRadius: BorderRadius.circular(10),

                  child: Row(
                    children: [
                      _phase(.08, const Color(0xFF94A3B8)),

                      _phase(.28, const Color(0xFF60A5FA)),

                      _phase(.38, const Color(0xFF818CF8)),

                      _phase(.26, const Color(0xFFC4B5FD)),
                    ],
                  ),
                ),

                const SizedBox(height: 5),

                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Text(
                      'Awake',
                      style: TextStyle(color: Color(0xFFA5B4FC), fontSize: 8),
                    ),

                    Text(
                      'Light',
                      style: TextStyle(color: Color(0xFFA5B4FC), fontSize: 8),
                    ),

                    Text(
                      'Deep',
                      style: TextStyle(color: Color(0xFFA5B4FC), fontSize: 8),
                    ),

                    Text(
                      'REM',
                      style: TextStyle(color: Color(0xFFA5B4FC), fontSize: 8),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _phase(double width, Color color) {
    return Expanded(
      flex: (width * 100).round(),

      child: Container(height: 40, color: color),
    );
  }
}
