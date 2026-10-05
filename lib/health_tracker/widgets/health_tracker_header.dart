import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'health_tracker_components.dart';

class HealthTrackerHeader extends StatelessWidget {
  const HealthTrackerHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        20,
      ),

      decoration:
      const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF2563EB),
            Color(0xFF06B6D4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.topRight,
        ),

        borderRadius:
        BorderRadius.vertical(
          bottom: Radius.circular(32),
        ),

        boxShadow: [
          BoxShadow(
            color: Color(0x332563EB),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),

      child: Column(
        children: [

          Row(
            children: [

              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },

                child: Container(
                  width: 42,
                  height: 42,

                  decoration:
                  BoxDecoration(
                    color:
                    Colors.white.withOpacity(
                      0.18,
                    ),
                    shape: BoxShape.circle,
                  ),

                  child: const Icon(
                    LucideIcons.arrowLeft,
                    color: Colors.white,
                    size: 21,
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
                      'Health Tracker',

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),

                    SizedBox(height: 3),

                    Text(
                      'Live monitoring · May 21, 2026',

                      style: TextStyle(
                        color:
                        Color(0xFFDBEAFE),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              const LiveIndicator(),
            ],
          ),

          const SizedBox(height: 18),

          Container(
            padding:
            const EdgeInsets.all(16),

            decoration:
            BoxDecoration(
              color:
              Colors.white.withOpacity(
                0.10,
              ),

              borderRadius:
              BorderRadius.circular(
                18,
              ),

              border:
              Border.all(
                color:
                Colors.white.withOpacity(
                  0.20,
                ),
              ),
            ),

            child: Row(
              children: [

                const Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      Text(
                        "Today's Wellness Score",

                        style: TextStyle(
                          color:
                          Color(0xFFDBEAFE),
                          fontSize: 11,
                        ),
                      ),

                      SizedBox(height: 2),

                      Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.end,

                        children: [

                          Text(
                            '82',

                            style: TextStyle(
                              color:
                              Colors.white,
                              fontSize: 38,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),

                          SizedBox(width: 3),

                          Padding(
                            padding:
                            EdgeInsets.only(
                              bottom: 5,
                            ),

                            child: Text(
                              '/100',

                              style: TextStyle(
                                color:
                                Color(0xFFBFDBFE),
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ],
                      ),

                      Text(
                        'Great Day!',

                        style: TextStyle(
                          color:
                          Color(0xFF86EFAC),
                          fontSize: 12,
                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.end,

                  children: [

                    Row(
                      children:
                      List.generate(
                        5,
                            (index) {
                          return Container(
                            margin:
                            const EdgeInsets
                                .only(
                              left: 3,
                            ),

                            width: 20,
                            height: 6,

                            decoration:
                            BoxDecoration(
                              color: index < 4
                                  ? const Color(
                                0xFF34D399,
                              )
                                  : Colors.white
                                  .withOpacity(
                                0.25,
                              ),

                              borderRadius:
                              BorderRadius.circular(
                                20,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 7),

                    const Text(
                      '4/5 Goals Met',

                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 10,
                      ),
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
}