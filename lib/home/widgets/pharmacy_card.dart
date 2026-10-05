// lib/home/widgets/pharmacy_card.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_colors.dart';

class PharmacyCard extends StatelessWidget {
  const PharmacyCard({
    super.key,
    required this.name,
    required this.distance,
    required this.rating,
    required this.onCall,
  });

  final String name;
  final String distance;
  final String rating;
  final VoidCallback? onCall;

  @override
  Widget build(
      BuildContext context,
      ) {
    return Container(
      width: 190,
      margin:
      const EdgeInsets.only(
        right: 14,
      ),
      padding:
      const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius:
        BorderRadius.circular(
          22,
        ),
        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withOpacity(
              .05,
            ),
            blurRadius: 15,
            offset:
            const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          // ==================================================
          // ICON
          // ==================================================

          Container(
            width: 52,
            height: 52,
            decoration:
            BoxDecoration(
              borderRadius:
              BorderRadius.circular(
                18,
              ),
              gradient:
              const LinearGradient(
                colors: [
                  Colors.green,
                  Colors.teal,
                ],
              ),
            ),
            child: const Icon(
              LucideIcons.pill,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 14),

          // ==================================================
          // NAME
          // ==================================================

          Text(
            name,
            maxLines: 2,
            overflow:
            TextOverflow.ellipsis,
            style:
            const TextStyle(
              fontWeight:
              FontWeight.bold,
              color:
              AppColors.darkBlue,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 12),

          // ==================================================
          // DISTANCE
          // ==================================================

          Row(
            children: [
              const Icon(
                LucideIcons.mapPin,
                size: 14,
                color: Colors.grey,
              ),

              const SizedBox(width: 4),

              Expanded(
                child: Text(
                  distance,
                  style:
                  const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ==================================================
          // RATING
          // ==================================================

          Row(
            children: [
              const Icon(
                Icons.star,
                color: Colors.amber,
                size: 15,
              ),

              const SizedBox(width: 4),

              Text(
                rating,
                style:
                const TextStyle(
                  fontWeight:
                  FontWeight.w600,
                  fontSize: 12,
                  color:
                  AppColors.darkBlue,
                ),
              ),
            ],
          ),

          const Spacer(),

          // ==================================================
          // CALL STORE
          // ==================================================

          SizedBox(
            width: double.infinity,
            child:
            ElevatedButton.icon(
              onPressed: onCall,
              style:
              ElevatedButton.styleFrom(
                backgroundColor:
                AppColors
                    .lightGreen,
                foregroundColor:
                Colors.green,
                elevation: 0,
                padding:
                const EdgeInsets
                    .symmetric(
                  vertical: 10,
                ),
                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius
                      .circular(
                    14,
                  ),
                ),
              ),
              icon: const Icon(
                LucideIcons.phone,
                size: 16,
              ),
              label: const Text(
                'Call Store',
                style: TextStyle(
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}