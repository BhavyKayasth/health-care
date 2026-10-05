import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../models/appointment_model.dart';

class UpcomingCard extends StatelessWidget {
  final AppointmentModel appointment;
  final VoidCallback? onTap;
  final VoidCallback? onAction;

  const UpcomingCard({
    super.key,
    required this.appointment,
    this.onTap,
    this.onAction,
  });

  bool get _isVideo => appointment.type.toLowerCase().contains("video");

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xffEDF2F7), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.045),
              blurRadius: 18,
              spreadRadius: 0,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            //------------------------------------------------
            // DOCTOR INFO
            //------------------------------------------------
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.primary, AppColors.secondary],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      appointment.avatar,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointment.doctor,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppColors.darkText,
                            height: 1.2,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          appointment.specialty,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.greyText,
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Icon(
                    LucideIcons.chevronRight,
                    size: 20,
                    color: AppColors.lightGrey,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            //------------------------------------------------
            // DATE & TIME CARD
            //------------------------------------------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              decoration: BoxDecoration(
                color: const Color(0xffF8FBFF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xffEAF2FB)),
              ),
              child: Row(
                children: [
                  const Icon(
                    LucideIcons.calendar,
                    size: 17,
                    color: AppColors.primary,
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      appointment.date,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkText,
                        letterSpacing: -.1,
                      ),
                    ),
                  ),

                  const Icon(
                    LucideIcons.clock3,
                    size: 17,
                    color: AppColors.primary,
                  ),

                  const SizedBox(width: 8),

                  Text(
                    appointment.time,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkText,
                      letterSpacing: -.1,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            //------------------------------------------------
            // BOTTOM ROW
            //------------------------------------------------
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        _isVideo ? LucideIcons.video : LucideIcons.mapPin,
                        size: 18,
                        color: _isVideo ? AppColors.purple : AppColors.orange,
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child: Text(
                          appointment.type,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.greyText,
                            letterSpacing: -.1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 14),

                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [AppColors.primary, AppColors.secondary],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(.25),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: onAction,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 42),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      _isVideo ? "Join Call" : "View Details",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -.1,
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
