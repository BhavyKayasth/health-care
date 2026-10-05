import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../models/nearby_hospital_model.dart';

class NearbyHospitalCard extends StatelessWidget {
  final NearbyHospitalModel hospital;
  final VoidCallback? onDirections;

  const NearbyHospitalCard({
    super.key,
    required this.hospital,
    this.onDirections,
  });

  //----------------------------------------------------------
  // CALL HOSPITAL
  //----------------------------------------------------------

  Future<void> _callHospital() async {
    if (hospital.phone.trim().isEmpty) {
      return;
    }

    final Uri uri = Uri(
      scheme: 'tel',
      path: hospital.phone,
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  //----------------------------------------------------------
  // FORMAT DISTANCE
  //----------------------------------------------------------

  String _getDistanceText() {
    final double? distance = hospital.distanceKm;

    if (distance == null) {
      return 'Distance unavailable';
    }

    if (distance < 1) {
      final int meters = (distance * 1000).round();

      return '$meters m';
    }

    return '${distance.toStringAsFixed(1)} km';
  }

  //----------------------------------------------------------
  // FORMAT RATING
  //----------------------------------------------------------

  String _getRatingText() {
    final double? rating = hospital.rating;

    if (rating == null) {
      return 'No rating';
    }

    return rating.toStringAsFixed(1);
  }

  //----------------------------------------------------------
  // BUILD
  //----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final bool hasEmergency =
        hospital.emergency == true;

    final bool hasDoctors =
        hospital.availableDoctors != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xffEEF3FA),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 16,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [

            //------------------------------------------------
            // HOSPITAL NAME
            //------------------------------------------------

            Row(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    hospital.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkBlue,
                    ),
                  ),
                ),

                if (hasEmergency)
                  Container(
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.lightRed,
                      borderRadius:
                      BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '24/7',
                      style: TextStyle(
                        color: AppColors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 10),

            //------------------------------------------------
            // RATING + DISTANCE
            //------------------------------------------------

            Row(
              children: [
                const Icon(
                  LucideIcons.star,
                  color: Colors.amber,
                  size: 15,
                ),

                const SizedBox(width: 4),

                Text(
                  _getRatingText(),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight:
                    FontWeight.bold,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(width: 8),

                const Text(
                  '•',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(width: 8),

                const Icon(
                  LucideIcons.mapPin,
                  color: AppColors.primary,
                  size: 14,
                ),

                const SizedBox(width: 4),

                Flexible(
                  child: Text(
                    _getDistanceText(),
                    style: const TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 12,
                      fontWeight:
                      FontWeight.w500,
                    ),
                    overflow:
                    TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            //------------------------------------------------
            // ADDRESS
            //------------------------------------------------

            if (hospital.address.trim().isNotEmpty)
              Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const Icon(
                    LucideIcons.mapPin,
                    color: AppColors.primary,
                    size: 18,
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      hospital.address,
                      style: const TextStyle(
                        color:
                        AppColors.textGrey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

            if (hospital.address.trim().isNotEmpty)
              const SizedBox(height: 14),

            //------------------------------------------------
            // DOCTORS CARD
            //------------------------------------------------

            if (hasDoctors)
              Container(
                padding:
                const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color:
                  const Color(0xffF2F7FF),
                  borderRadius:
                  BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(
                      LucideIcons.users,
                      color:
                      AppColors.primary,
                      size: 20,
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${hospital.availableDoctors} Doctors Available',
                            style:
                            const TextStyle(
                              fontWeight:
                              FontWeight.w600,
                              color:
                              AppColors.darkBlue,
                              fontSize: 13,
                            ),
                          ),

                          const SizedBox(height: 2),

                          const Text(
                            'Ready to consult now',
                            style:
                            TextStyle(
                              fontSize: 11,
                              color:
                              AppColors.textGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            if (hasDoctors)
              const SizedBox(height: 16),

            //------------------------------------------------
            // SPECIALTIES
            //------------------------------------------------

            if (hospital.specialties.isNotEmpty) ...[
              const Text(
                'Specialties:',
                style: TextStyle(
                  color:
                  AppColors.textGrey,
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 8),

              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: hospital
                    .specialties
                    .map(
                      (item) {
                    return Container(
                      padding:
                      const EdgeInsets
                          .symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration:
                      BoxDecoration(
                        color:
                        const Color(
                          0xffEDF4FF,
                        ),
                        borderRadius:
                        BorderRadius
                            .circular(
                          20,
                        ),
                      ),
                      child: Text(
                        item,
                        style:
                        const TextStyle(
                          fontSize: 11,
                          color:
                          AppColors
                              .primary,
                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),
                    );
                  },
                )
                    .toList(),
              ),

              const SizedBox(height: 16),
            ],

            //------------------------------------------------
            // BUTTONS
            //------------------------------------------------

            Row(
              children: [

                //------------------------------------------------
                // DIRECTIONS
                //------------------------------------------------

                Expanded(
                  child: SizedBox(
                    height: 42,
                    child:
                    ElevatedButton.icon(
                      onPressed: onDirections,
                      icon: const Icon(
                        LucideIcons.navigation,
                        size: 16,
                      ),
                      label: const Text(
                        'Directions',
                      ),
                      style:
                      ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor:
                        AppColors.secondary,
                        foregroundColor:
                        Colors.white,
                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius
                              .circular(
                            30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                //------------------------------------------------
                // CALL NOW
                //------------------------------------------------

                Expanded(
                  child: SizedBox(
                    height: 42,
                    child:
                    OutlinedButton.icon(
                      onPressed:
                      hospital.phone
                          .trim()
                          .isEmpty
                          ? null
                          : _callHospital,
                      icon: const Icon(
                        LucideIcons.phone,
                        size: 16,
                      ),
                      label: const Text(
                        'Call Now',
                      ),
                      style:
                      OutlinedButton.styleFrom(
                        foregroundColor:
                        AppColors.primary,
                        disabledForegroundColor:
                        Colors.grey,
                        side: BorderSide(
                          color:
                          Colors.grey.shade300,
                        ),
                        backgroundColor:
                        Colors.white,
                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius
                              .circular(
                            30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}