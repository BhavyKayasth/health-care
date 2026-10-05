import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../controller/schedule_controller.dart';
import '../models/appointment_model.dart';
import '../../book_appointment/screens/book_appointment_screen.dart';
import '../widgets/past_appointment_card.dart';
import '../widgets/schedule_header.dart';
import '../widgets/upcoming_card.dart';

class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(scheduleControllerProvider);
    final controller = ref.read(scheduleControllerProvider.notifier);

    final List<AppointmentModel> upcomingAppointments =
        controller.upcomingAppointments;

    final List<AppointmentModel> pastAppointments =
        controller.pastAppointments;

    return Scaffold(
      backgroundColor: AppColors.background,

      body: RefreshIndicator(
        onRefresh: controller.refreshAppointments,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //--------------------------------------------------
              // HEADER
              //--------------------------------------------------

              ScheduleHeader(
                selectedDate: state.selectedDate,
                onDateSelected: controller.selectDate,
                onAddAppointment: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const BookAppointmentScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              //--------------------------------------------------
              // UPCOMING TITLE
              //--------------------------------------------------

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Upcoming",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkText,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              //--------------------------------------------------
              // LOADING
              //--------------------------------------------------

              if (state.isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 80),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )

              //--------------------------------------------------
              // EMPTY
              //--------------------------------------------------

              else if (upcomingAppointments.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 28,
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 36,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.softShadow,
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.calendar_month_rounded,
                          size: 64,
                          color: AppColors.lightGrey,
                        ),

                        SizedBox(height: 18),

                        Text(
                          "No Upcoming Appointments",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkText,
                          ),
                        ),

                        SizedBox(height: 10),

                        Text(
                          "Book your first appointment to get started.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.greyText,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                )

              //--------------------------------------------------
              // UPCOMING LIST
              //--------------------------------------------------

              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: upcomingAppointments
                        .map(
                          (appointment) => UpcomingCard(
                        appointment: appointment,
                        onTap: () {},
                        onAction: () {},
                      ),
                    )
                        .toList(),
                  ),
                ),

              const SizedBox(height: 24),

              //--------------------------------------------------
              // PAST TITLE
              //--------------------------------------------------

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Past Appointments",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkText,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              //--------------------------------------------------
              // PAST LIST
              //--------------------------------------------------

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: pastAppointments.isEmpty
                      ? [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 26,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.border,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          "No past appointments",
                          style: TextStyle(
                            color: AppColors.greyText,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ]
                      : pastAppointments
                      .map(
                        (appointment) => PastAppointmentCard(
                      appointment: appointment,
                      onTap: () {},
                    ),
                  )
                      .toList(),
                ),
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}