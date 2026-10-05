import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/appointment_model.dart';

class PastAppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;
  final VoidCallback? onTap;

  const PastAppointmentCard({
    super.key,
    required this.appointment,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.82),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xffEDF2F7),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.03),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            //------------------------------------------------
            // AVATAR
            //------------------------------------------------

            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: Color(0xffDBEAFE),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  appointment.avatar,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 14),

            //------------------------------------------------
            // DETAILS
            //------------------------------------------------

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appointment.doctor,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkText,
                      height: 1.2,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    appointment.specialty,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.greyText,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),

            //------------------------------------------------
            // DATE + STATUS
            //------------------------------------------------

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  appointment.date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.greyText,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffDCFCE7),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Text(
                    "Completed",
                    style: TextStyle(
                      color: Color(0xff16A34A),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: .2,
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