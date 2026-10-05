import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../models/nearby_hospital_model.dart';
// import 'live_location_screen.dart';

class DirectionsScreen extends StatelessWidget {
  final NearbyHospitalModel hospital;

  const DirectionsScreen({
    super.key,
    required this.hospital,
  });

  //----------------------------------------------------------
  // OPEN GOOGLE MAPS
  //----------------------------------------------------------

  Future<void> _openGoogleMaps() async {
    final Uri googleMapsUri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
          '&destination=${hospital.latitude},${hospital.longitude}'
          '&travelmode=driving',
    );

    if (await canLaunchUrl(googleMapsUri)) {
      await launchUrl(
        googleMapsUri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  //----------------------------------------------------------
  // CALL HOSPITAL
  //----------------------------------------------------------

  Future<void> _callHospital() async {
    if (hospital.phone.trim().isEmpty) {
      return;
    }

    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: hospital.phone,
    );

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  //----------------------------------------------------------
  // OPEN LIVE LOCATION
  //----------------------------------------------------------

  // void _openLiveLocation(BuildContext context) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (_) => const LiveLocationScreen(),
  //     ),
  //   );
  // }

  //----------------------------------------------------------
  // RATING TEXT
  //----------------------------------------------------------

  String _ratingText() {
    if (hospital.rating == null) {
      return 'Rating unavailable';
    }

    return '${hospital.rating!.toStringAsFixed(1)} Rating';
  }

  //----------------------------------------------------------
  // DOCTORS TEXT
  //----------------------------------------------------------

  String _doctorsText() {
    if (hospital.availableDoctors == null) {
      return 'Doctor information unavailable';
    }

    return '${hospital.availableDoctors} Doctors Available';
  }

  //----------------------------------------------------------
  // EMERGENCY TEXT
  //----------------------------------------------------------

  String _emergencyText() {
    if (hospital.emergency == true) {
      return '24/7 Emergency Available';
    }

    if (hospital.emergency == false) {
      return 'Emergency Not Available';
    }

    return 'Emergency information unavailable';
  }

  //----------------------------------------------------------
  // EMERGENCY COLOR
  //----------------------------------------------------------

  Color _emergencyColor() {
    if (hospital.emergency == true) {
      return Colors.red;
    }

    if (hospital.emergency == false) {
      return Colors.grey;
    }

    return Colors.orange;
  }

  //----------------------------------------------------------
  // BUILD
  //----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      //------------------------------------------------------
      // APP BAR
      //------------------------------------------------------

      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text(
          'Hospital Directions',
        ),
      ),

      //------------------------------------------------------
      // BODY
      //------------------------------------------------------

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            //------------------------------------------------
            // HOSPITAL DETAILS CARD
            //------------------------------------------------

            Container(
              width: double.infinity,

              padding:
              const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.circular(20),

                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  //------------------------------------------------
                  // HOSPITAL NAME
                  //------------------------------------------------

                  Text(
                    hospital.name,

                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight:
                      FontWeight.bold,
                      color:
                      AppColors.darkBlue,
                    ),
                  ),

                  const SizedBox(height: 20),

                  //------------------------------------------------
                  // ADDRESS
                  //------------------------------------------------

                  Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [
                      const Icon(
                        LucideIcons.mapPin,
                        color:
                        AppColors.primary,
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          hospital.address,
                          style:
                          const TextStyle(
                            color:
                            AppColors.textGrey,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  //------------------------------------------------
                  // RATING
                  //------------------------------------------------

                  Row(
                    children: [
                      const Icon(
                        LucideIcons.star,
                        color: Colors.orange,
                      ),

                      const SizedBox(width: 10),

                      Text(
                        _ratingText(),

                        style:
                        const TextStyle(
                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  //------------------------------------------------
                  // DOCTORS
                  //------------------------------------------------

                  Row(
                    children: [
                      const Icon(
                        LucideIcons.users,
                        color:
                        AppColors.primary,
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          _doctorsText(),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  //------------------------------------------------
                  // PHONE
                  //------------------------------------------------

                  if (hospital.phone
                      .trim()
                      .isNotEmpty)
                    Row(
                      children: [
                        const Icon(
                          LucideIcons.phone,
                          color:
                          AppColors.primary,
                        ),

                        const SizedBox(
                          width: 10,
                        ),

                        Expanded(
                          child: Text(
                            hospital.phone,
                          ),
                        ),
                      ],
                    ),

                  if (hospital.phone
                      .trim()
                      .isNotEmpty)
                    const SizedBox(height: 16),

                  //------------------------------------------------
                  // EMERGENCY
                  //------------------------------------------------

                  Row(
                    children: [
                      Icon(
                        LucideIcons.clock3,
                        color:
                        _emergencyColor(),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          _emergencyText(),

                          style: TextStyle(
                            color:
                            _emergencyColor(),
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            //------------------------------------------------
            // SPECIALTIES
            //------------------------------------------------

            if (hospital.specialties.isNotEmpty) ...[
              const Text(
                'Available Specialties',

                style: TextStyle(
                  fontSize: 18,
                  fontWeight:
                  FontWeight.bold,
                  color:
                  AppColors.darkBlue,
                ),
              ),

              const SizedBox(height: 15),

              Wrap(
                spacing: 8,
                runSpacing: 8,

                children:
                hospital.specialties
                    .map(
                      (specialty) {
                    return Chip(
                      label:
                      Text(specialty),
                      backgroundColor:
                      AppColors.lightBlue,
                    );
                  },
                ).toList(),
              ),

              const SizedBox(height: 35),
            ],

            //------------------------------------------------
            // LIVE LOCATION BUTTON
            //------------------------------------------------

            // SizedBox(
            //   width: double.infinity,
            //   height: 55,
            //
            //   child:
            //   ElevatedButton.icon(
            //     onPressed: () =>
            //         _openLiveLocation(
            //           context,
            //         ),
            //
            //     icon: const Icon(
            //       LucideIcons.locateFixed,
            //     ),
            //
            //     label: const Text(
            //       'Live Location',
            //     ),
            //
            //     style:
            //     ElevatedButton.styleFrom(
            //       backgroundColor:
            //       Colors.green,
            //       foregroundColor:
            //       Colors.white,
            //
            //       shape:
            //       RoundedRectangleBorder(
            //         borderRadius:
            //         BorderRadius.circular(
            //           14,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),

            const SizedBox(height: 15),

            //------------------------------------------------
            // GOOGLE MAPS BUTTON
            //------------------------------------------------

            SizedBox(
              width: double.infinity,
              height: 55,

              child:
              ElevatedButton.icon(
                onPressed:
                _openGoogleMaps,

                icon: const Icon(
                  LucideIcons.navigation,
                ),

                label: const Text(
                  'Open in Google Maps',
                ),

                style:
                ElevatedButton.styleFrom(
                  backgroundColor:
                  AppColors.primary,
                  foregroundColor:
                  Colors.white,

                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(
                      14,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            //------------------------------------------------
            // CALL BUTTON
            //------------------------------------------------

            SizedBox(
              width: double.infinity,
              height: 55,

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
                ),

                label: const Text(
                  'Call Hospital',
                ),

                style:
                OutlinedButton.styleFrom(
                  foregroundColor:
                  AppColors.primary,

                  disabledForegroundColor:
                  Colors.grey,

                  side: const BorderSide(
                    color:
                    AppColors.primary,
                  ),

                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(
                      14,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}