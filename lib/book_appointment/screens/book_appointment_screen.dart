import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../schedule/controller/schedule_controller.dart';
import '../../schedule/models/appointment_model.dart';

class BookAppointmentScreen extends ConsumerStatefulWidget {
  const BookAppointmentScreen({super.key});

  @override
  ConsumerState<BookAppointmentScreen> createState() =>
      _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends ConsumerState<BookAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController doctorController = TextEditingController();
  final TextEditingController specialtyController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  String appointmentType = "Video Consultation";

  @override
  void dispose() {
    doctorController.dispose();
    specialtyController.dispose();
    super.dispose();
  }

  //----------------------------------------------------------
  // PICK DATE
  //----------------------------------------------------------

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  //----------------------------------------------------------
  // PICK TIME
  //----------------------------------------------------------

  Future<void> pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (time != null) {
      setState(() {
        selectedTime = time;
      });
    }
  }

  //----------------------------------------------------------
  // BOOK APPOINTMENT
  //----------------------------------------------------------

  void bookAppointment() {
    if (!_formKey.currentState!.validate()) return;

    final controller = ref.read(scheduleControllerProvider.notifier);

    final appointmentDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    final appointment = AppointmentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      doctor: doctorController.text.trim(),
      specialty: specialtyController.text.trim(),
      avatar: doctorController.text.trim().isEmpty
          ? "D"
          : doctorController.text.trim()[0].toUpperCase(),
      dateTime: appointmentDateTime,
      type: appointmentType,
      completed: false,
    );

    controller.addAppointment(appointment);

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Appointment booked successfully"),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  //----------------------------------------------------------
  // UI
  //----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text(
          "Book Appointment",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              //--------------------------------------------------
              // DOCTOR NAME
              //--------------------------------------------------
              _buildField(
                controller: doctorController,
                label: "Doctor Name",
                icon: LucideIcons.userRound,
              ),

              const SizedBox(height: 18),

              //--------------------------------------------------
              // SPECIALTY
              //--------------------------------------------------
              _buildField(
                controller: specialtyController,
                label: "Specialty",
                icon: LucideIcons.stethoscope,
              ),

              const SizedBox(height: 22),

              //--------------------------------------------------
              // DATE
              //--------------------------------------------------
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: AppColors.border),
                ),
                tileColor: Colors.white,
                leading: const Icon(
                  LucideIcons.calendar,
                  color: AppColors.primary,
                ),
                title: const Text("Appointment Date"),
                subtitle: Text(
                  "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: pickDate,
              ),

              const SizedBox(height: 16),

              //--------------------------------------------------
              // TIME
              //--------------------------------------------------
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: AppColors.border),
                ),
                tileColor: Colors.white,
                leading: const Icon(
                  LucideIcons.clock3,
                  color: AppColors.primary,
                ),
                title: const Text("Appointment Time"),
                subtitle: Text(selectedTime.format(context)),
                trailing: const Icon(Icons.chevron_right),
                onTap: pickTime,
              ),

              const SizedBox(height: 28),

              //--------------------------------------------------
              // CONSULTATION TYPE
              //--------------------------------------------------
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Consultation Type",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkText,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              RadioListTile<String>(
                value: "Video Consultation",
                groupValue: appointmentType,
                activeColor: AppColors.primary,
                title: const Text("Video Consultation"),
                secondary: const Icon(
                  LucideIcons.video,
                  color: AppColors.primary,
                ),
                onChanged: (value) {
                  setState(() {
                    appointmentType = value!;
                  });
                },
              ),

              RadioListTile<String>(
                value: "Hospital Visit",
                groupValue: appointmentType,
                activeColor: AppColors.primary,
                title: const Text("Hospital Visit"),
                secondary: const Icon(
                  LucideIcons.mapPinned,
                  color: AppColors.primary,
                ),
                onChanged: (value) {
                  setState(() {
                    appointmentType = value!;
                  });
                },
              ),

              const SizedBox(height: 36),

              //--------------------------------------------------
              // CONFIRM BUTTON
              //--------------------------------------------------
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: bookAppointment,
                  icon: const Icon(Icons.check),
                  label: const Text(
                    "Confirm Appointment",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  //----------------------------------------------------------
  // TEXT FIELD
  //----------------------------------------------------------

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Please enter $label";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }
}
