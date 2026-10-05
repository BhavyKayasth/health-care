import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../models/appointment_model.dart';
import 'appointment_card.dart';

class UpcomingAppointments extends StatelessWidget {
  const UpcomingAppointments({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 30, 22, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  "Upcoming Appointments",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                    color: AppColors.darkBlue,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Row(
                  children: [
                    Text("See All"),
                    Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          ...appointments.map(
                (appointment) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AppointmentCard(
                doctor: appointment.doctor,
                speciality: appointment.specialty,
                time: appointment.time,
                type: appointment.type,
              ),
            ),
          ),
        ],
      ),
    );
  }
}