import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';

class NearbyHeader extends StatelessWidget {
  final VoidCallback? onLiveLocation;
  final Widget filterSection;

  const NearbyHeader({
    super.key,
    this.onLiveLocation,
    required this.filterSection,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.gradientTop,
            AppColors.gradientBottom,
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(26),
          bottomRight: Radius.circular(26),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.blueShadow,
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //------------------------------------------------
            // TOP BAR
            //------------------------------------------------

            SizedBox(
              height: 52,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Center(
                    child: Text(
                      "Nearby Hospitals",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   child: InkWell(
                  //     onTap: onLiveLocation,
                  //     borderRadius: BorderRadius.circular(100),
                  //     child: Container(
                  //       width: 42,
                  //       height: 42,
                  //       decoration: BoxDecoration(
                  //         color: Colors.white.withOpacity(.18),
                  //         shape: BoxShape.circle,
                  //         border: Border.all(
                  //           color: Colors.white24,
                  //         ),
                  //       ),
                  //       child: const Icon(
                  //         LucideIcons.locateFixed,
                  //         color: Colors.white,
                  //         size: 20,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            //------------------------------------------------
            // FILTER CARD
            //------------------------------------------------

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.08),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Colors.white24,
                ),
              ),
              child: filterSection,
            ),
          ],
        ),
      ),
    );
  }
}