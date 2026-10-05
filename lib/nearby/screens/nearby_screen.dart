// lib/nearby/screens/nearby_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../controller/nearby_controller.dart';
import '../screens/directions_screen.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/nearby_header.dart';
import '../widgets/nearby_hospital_card.dart';

class NearbyScreen extends ConsumerStatefulWidget {
  const NearbyScreen({
    super.key,
  });

  @override
  ConsumerState<NearbyScreen> createState() =>
      _NearbyScreenState();
}

class _NearbyScreenState
    extends ConsumerState<NearbyScreen> {
  @override
  void initState() {
    super.initState();

    //==========================================================
    // LOAD NEARBY HOSPITALS
    //
    // NearbyController now handles:
    // - GPS / permissions
    // - last known location
    // - fresh location fallback
    // - hospital API
    // - caching
    //==========================================================

    WidgetsBinding.instance
        .addPostFrameCallback((_) async {
      if (!mounted) {
        return;
      }

      await ref
          .read(
        nearbyControllerProvider.notifier,
      )
          .loadNearbyHospitals();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(
      nearbyControllerProvider,
    );

    final controller = ref.read(
      nearbyControllerProvider.notifier,
    );

    final hospitals =
        controller.filteredHospitals;

    return Scaffold(
      backgroundColor: AppColors.background,

      //========================================================
      // PULL TO REFRESH
      //========================================================

      body: RefreshIndicator(
        onRefresh: controller.refreshHospitals,

        child: SingleChildScrollView(
          physics:
          const AlwaysScrollableScrollPhysics(),

          child: Column(
            children: [
              //================================================
              // HEADER
              //================================================

              NearbyHeader(
                filterSection: Column(
                  children: [
                    CustomDropdown(
                      title: 'Specialty',
                      icon:
                      LucideIcons.stethoscope,
                      value:
                      state.selectedSpecialty,
                      items:
                      NearbyController
                          .specialties
                          .map(
                            (specialty) =>
                            DropdownMenuItem<
                                String>(
                              value: specialty,
                              child: Text(
                                specialty,
                              ),
                            ),
                      ).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          controller
                              .selectSpecialty(
                            value,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),

              //================================================
              // REFRESH INDICATOR
              //
              // Keep the hospital list visible while refreshing.
              //================================================

              if (state.isLoading &&
                  hospitals.isNotEmpty)
                const LinearProgressIndicator(
                  minHeight: 2,
                ),

              const SizedBox(height: 24),

              //================================================
              // RESULT HEADER
              //================================================

              Padding(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration:
                      BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(
                          16,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color:
                            AppColors
                                .softShadow,
                            blurRadius: 12,
                            offset:
                            Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        LucideIcons.building2,
                        color:
                        AppColors.primary,
                        size: 24,
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                        children: [
                          const Text(
                            'Nearby Hospitals',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight:
                              FontWeight.w700,
                              color:
                              AppColors
                                  .darkText,
                            ),
                          ),

                          const SizedBox(
                            height: 4,
                          ),

                          Text(
                            _getResultSubtitle(
                              state: state,
                              hospitals:
                              hospitals,
                            ),
                            style:
                            const TextStyle(
                              color:
                              AppColors
                                  .greyText,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              //================================================
              // INITIAL LOADING
              //
              // Full-screen style loading is shown only when
              // there are no hospitals available yet.
              //================================================

              if (state.isLoading &&
                  hospitals.isEmpty)
                const Padding(
                  padding:
                  EdgeInsets.symmetric(
                    vertical: 80,
                  ),
                  child: Center(
                    child:
                    CircularProgressIndicator(),
                  ),
                )

              //================================================
              // LOCATION UNAVAILABLE
              //================================================

              else if (!state.locationAvailable &&
                  hospitals.isEmpty)
                _buildLocationUnavailable()

              //================================================
              // NO HOSPITALS
              //================================================

              else if (hospitals.isEmpty)
                  _buildNoHospitals()

                //================================================
                // HOSPITAL LIST
                //================================================

                else
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Column(
                      children:
                      hospitals.map(
                            (hospital) {
                          return NearbyHospitalCard(
                            hospital: hospital,
                            onDirections: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      DirectionsScreen(
                                        hospital:
                                        hospital,
                                      ),
                                ),
                              );
                            },
                          );
                        },
                      ).toList(),
                    ),
                  ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  //============================================================
  // RESULT SUBTITLE
  //============================================================

  String _getResultSubtitle({
    required NearbyState state,
    required List hospitals,
  }) {
    if (state.isLoading &&
        hospitals.isEmpty) {
      return 'Finding hospitals near you...';
    }

    if (!state.locationAvailable &&
        hospitals.isNotEmpty) {
      return '${hospitals.length} previous results';
    }

    if (hospitals.isEmpty) {
      return 'No hospitals found near you';
    }

    return '${hospitals.length} hospitals found near you';
  }

  //============================================================
  // LOCATION UNAVAILABLE UI
  //============================================================

  Widget _buildLocationUnavailable() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Container(
        width: double.infinity,
        padding:
        const EdgeInsets.symmetric(
          vertical: 40,
          horizontal: 24,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
          BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: AppColors.softShadow,
              blurRadius: 18,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: const Column(
          children: [
            Icon(
              LucideIcons.mapPinOff,
              size: 64,
              color: Colors.grey,
            ),

            SizedBox(height: 18),

            Text(
              'Location Unavailable',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight:
                FontWeight.bold,
                color:
                AppColors.darkText,
              ),
            ),

            SizedBox(height: 10),

            Text(
              'Please enable Location permission and GPS to find nearby hospitals.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color:
                AppColors.greyText,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //============================================================
  // NO HOSPITALS UI
  //============================================================

  Widget _buildNoHospitals() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Container(
        width: double.infinity,
        padding:
        const EdgeInsets.symmetric(
          vertical: 40,
          horizontal: 24,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
          BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: AppColors.softShadow,
              blurRadius: 18,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: const Column(
          children: [
            Icon(
              LucideIcons.circleOff,
              size: 70,
              color: Colors.grey,
            ),

            SizedBox(height: 18),

            Text(
              'No Hospitals Found',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight:
                FontWeight.bold,
                color:
                AppColors.darkText,
              ),
            ),

            SizedBox(height: 10),

            Text(
              'Try another specialty or refresh your location.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color:
                AppColors.greyText,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}