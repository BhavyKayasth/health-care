import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_colors.dart';
import '../../location/controller/location_controller.dart';
import '../controller/pharmacy_controller.dart';
import 'pharmacy_card.dart';

class NearbyPharmacies extends ConsumerStatefulWidget {
  const NearbyPharmacies({
    super.key,
  });

  @override
  ConsumerState<NearbyPharmacies> createState() =>
      _NearbyPharmaciesState();
}

class _NearbyPharmaciesState
    extends ConsumerState<NearbyPharmacies> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      ref
          .read(pharmacyControllerProvider.notifier)
          .loadPharmacies();
    });
  }

  @override
  Widget build(BuildContext context) {
    // ========================================================
    // PHARMACY STATE
    // ========================================================

    final pharmacyState = ref.watch(
      pharmacyControllerProvider,
    );

    // ========================================================
    // SHARED LOCATION STATE
    // ========================================================

    final locationState = ref.watch(
      locationControllerProvider,
    );

    final controller = ref.read(
      pharmacyControllerProvider.notifier,
    );

    // ========================================================
    // MAXIMUM 10 PHARMACIES
    // ========================================================

    final pharmacies =
    pharmacyState.pharmacies.take(10).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 22,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),

          // ==================================================
          // HEADER
          // ==================================================

          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.lightGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  LucideIcons.mapPin,
                  color: Colors.green,
                  size: 20,
                ),
              ),

              const SizedBox(width: 10),

              const Expanded(
                child: Text(
                  'Nearby Pharmacies',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.darkBlue,
                  ),
                ),
              ),

              // ==================================================
              // REFRESH
              // ==================================================

              IconButton(
                tooltip: 'Refresh pharmacies',
                onPressed: pharmacyState.isLoading
                    ? null
                    : () {
                  controller.refreshPharmacies();
                },
                icon: pharmacyState.isLoading
                    ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.green,
                  ),
                )
                    : const Icon(
                  LucideIcons.refreshCw,
                  size: 19,
                  color: Colors.green,
                ),
              ),

              // ==================================================
              // VIEW MAP
              // ==================================================

              TextButton(
                onPressed: _openGoogleMaps,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View Map',
                    ),
                    SizedBox(width: 3),
                    Icon(
                      Icons.navigation,
                      size: 17,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ==================================================
          // LOCATION STATUS
          //
          // IMPORTANT:
          // This uses LocationController directly.
          // Pharmacy API success/failure does not determine
          // whether location is available.
          // ==================================================

          if (pharmacyState.isLoading ||
              locationState.isLoading)
            const Row(
              children: [
                SizedBox(
                  width: 10,
                  height: 10,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.green,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'Finding nearby pharmacies...',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            )
          else if (locationState.position != null)
            const Text(
              'Location detected • Showing nearest pharmacies',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            )
          else
            const Text(
              'Location unavailable',
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),

          const SizedBox(height: 18),

          // ==================================================
          // INITIAL LOADING
          // ==================================================

          if (pharmacyState.isLoading &&
              pharmacies.isEmpty)
            const SizedBox(
              height: 245,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              ),
            )

          // ==================================================
          // EMPTY
          // ==================================================

          else if (pharmacies.isEmpty)
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      const Icon(
                        LucideIcons.store,
                        size: 42,
                        color: Colors.grey,
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        'No Nearby Pharmacies Found',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: AppColors.darkBlue,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        pharmacyState.error ??
                            'Try refreshing your location.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.greyText,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )

          // ==================================================
          // PHARMACY LIST
          // ==================================================

          else
            Stack(
              children: [
                SizedBox(
                  height: 230,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: pharmacies.length,
                    itemBuilder: (
                        context,
                        index,
                        ) {
                      final pharmacy =
                      pharmacies[index];

                      return PharmacyCard(
                        name: pharmacy.name,
                        distance: pharmacy.distance,
                        rating: pharmacy.rating,
                        onCall:
                        pharmacy.phone.isEmpty
                            ? null
                            : () {
                          _callPharmacy(
                            pharmacy.phone,
                          );
                        },
                      );
                    },
                  ),
                ),

                // ==================================================
                // SMALL REFRESH INDICATOR
                // ==================================================

                if (pharmacyState.isLoading)
                  const Positioned(
                    top: 0,
                    right: 4,
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child:
                      CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.green,
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  // ==========================================================
  // GOOGLE MAPS
  // ==========================================================

  Future<void> _openGoogleMaps() async {
    final Uri uri = Uri.parse(
      'https://www.google.com/maps/search/'
          '?api=1&query=pharmacies',
    );

    try {
      final bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Could not open Google Maps.',
            ),
          ),
        );
      }
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not open Google Maps.',
          ),
        ),
      );
    }
  }

  // ==========================================================
  // CALL PHARMACY
  // ==========================================================

  Future<void> _callPharmacy(
      String phone,
      ) async {
    final String cleanPhone =
    phone.trim();

    if (cleanPhone.isEmpty) {
      return;
    }

    final Uri uri = Uri(
      scheme: 'tel',
      path: cleanPhone,
    );

    try {
      await launchUrl(uri);
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not open phone dialer.',
          ),
        ),
      );
    }
  }
}