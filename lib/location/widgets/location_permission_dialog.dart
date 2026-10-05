import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class LocationPermissionDialog extends StatelessWidget {
  final VoidCallback onAllow;
  final VoidCallback onExit;

  const LocationPermissionDialog({
    super.key,
    required this.onAllow,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),

      //--------------------------------------------------
      // TITLE
      //--------------------------------------------------

      title: const Row(
        children: [
          Icon(
            Icons.location_on_rounded,
            color: AppColors.primary,
            size: 30,
          ),

          SizedBox(width: 10),

          Expanded(
            child: Text(
              "Location Access",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),

      //--------------------------------------------------
      // MESSAGE
      //--------------------------------------------------

      content: const Text(
        "We need your location permission to provide:\n\n"
            "• Nearby hospitals\n"
            "• Nearby pharmacies\n"
            "• Emergency services\n"
            "• Better health recommendations\n\n"
            "Your location is only used to improve your experience.",
        style: TextStyle(
          fontSize: 15,
          height: 1.5,
        ),
      ),

      //--------------------------------------------------
      // BUTTONS
      //--------------------------------------------------

      actionsPadding: const EdgeInsets.fromLTRB(
        16,
        0,
        16,
        16,
      ),

      actions: [

        //--------------------------------------------------
        // EXIT BUTTON
        //--------------------------------------------------

        TextButton(
          onPressed: onExit,
          child: const Text(
            "Not Now",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),


        //--------------------------------------------------
        // ALLOW BUTTON
        //--------------------------------------------------

        ElevatedButton(
          onPressed: onAllow,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),

          child: const Text(
            "Allow Location",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}