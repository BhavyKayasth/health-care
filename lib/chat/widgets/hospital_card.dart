import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_colors.dart';
import '../models/doctor_model.dart';
import '../models/hospital_model.dart';

class HospitalCard extends StatelessWidget {
  final HospitalModel hospital;

  const HospitalCard({
    super.key,
    required this.hospital,
  });

  Future<void> _callHospital() async {
    final uri = Uri.parse("tel:${hospital.phone}");

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _openMap() async {
    final uri = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=${hospital.latitude},${hospital.longitude}",
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.lightBlue,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Hospital Name + Rating
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      hospital.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkBlue,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      hospital.specialty,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  borderRadius:
                  BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    const Icon(
                      LucideIcons.star,
                      color: Colors.amber,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      hospital.rating.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),

          const SizedBox(height: 18),

          /// Address
          Row(
            children: [
              const Icon(
                LucideIcons.mapPin,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  hospital.address,
                  style: const TextStyle(
                    color: AppColors.textGrey,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// Distance
          Row(
            children: [
              const Icon(
                LucideIcons.navigation,
                size: 18,
                color: AppColors.secondary,
              ),
              const SizedBox(width: 8),
              Text(
                hospital.distance,
                style: const TextStyle(
                  color: AppColors.darkBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          /// Doctors
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.gradientStart,
              borderRadius:
              BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      LucideIcons.stethoscope,
                      size: 18,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Available Doctors",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkBlue,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                ...hospital.doctors.map(
                      (doctor) =>
                      _DoctorTile(doctor: doctor),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          /// Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _callHospital,
                  icon: const Icon(
                    LucideIcons.phone,
                    size: 18,
                  ),
                  label: const Text("Call"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    minimumSize:
                    const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _openMap,
                  icon: const Icon(
                    LucideIcons.navigation,
                    size: 18,
                  ),
                  label: const Text("Directions"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize:
                    const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Center(
            child: Text(
              hospital.phone,
              style: const TextStyle(
                color: AppColors.textGrey,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DoctorTile extends StatelessWidget {
  final DoctorModel doctor;

  const _DoctorTile({
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundColor:
            AppColors.lightBlue,
            child: Icon(
              LucideIcons.userRound,
              color: AppColors.primary,
              size: 18,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.name,
                  style: const TextStyle(
                    fontWeight:
                    FontWeight.w600,
                    color:
                    AppColors.darkBlue,
                  ),
                ),
                Text(
                  doctor.specialty,
                  style: const TextStyle(
                    color:
                    AppColors.textGrey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          Row(
            children: [
              Icon(
                doctor.available
                    ? LucideIcons.circleCheck
                    : LucideIcons.circleX,
                size: 18,
                color: doctor.available
                    ? Colors.green
                    : Colors.red,
              ),
              const SizedBox(width: 6),
              Text(
                doctor.available
                    ? "Available"
                    : "Busy",
                style: TextStyle(
                  color: doctor.available
                      ? Colors.green
                      : Colors.red,
                  fontWeight:
                  FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}