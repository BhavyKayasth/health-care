import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_colors.dart';

class Doctor {
  final String id;
  final String name;
  final String specialty;
  final String experience;
  final double rating;
  final bool available;
  final String? nextAvailable;
  final String phone;
  final String avatar;
  final String consultationFee;
  final List<String> languages;
  final int patients;

  const Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.experience,
    required this.rating,
    required this.available,
    this.nextAvailable,
    required this.phone,
    required this.avatar,
    required this.consultationFee,
    required this.languages,
    required this.patients,
  });
}

class DoctorCallListScreen extends StatefulWidget {
  const DoctorCallListScreen({
    super.key,
    this.onBack,
  });

  final VoidCallback? onBack;

  @override
  State<DoctorCallListScreen> createState() =>
      _DoctorCallListScreenState();
}

class _DoctorCallListScreenState
    extends State<DoctorCallListScreen> {
  String _filter = 'all';

  // ==========================================================
  // HARDCODED DOCTORS
  // ==========================================================

  static const List<Doctor> doctors = [
    Doctor(
      id: 'doc-1',
      name: 'bhavy',
      specialty: 'General Physician',
      experience: '15 years',
      rating: 4.9,
      available: true,
      phone: '+91 7069001512',
      avatar: 'SM',
      consultationFee: '\$50',
      languages: [
        'English',
        'Spanish',
      ],
      patients: 2500,
    ),
    Doctor(
      id: 'doc-2',
      name: 'himanshu',
      specialty: 'Cardiologist',
      experience: '20 years',
      rating: 4.8,
      available: true,
      phone: '+91 9408202803',
      avatar: 'JC',
      consultationFee: '\$80',
      languages: [
        'English',
      ],
      patients: 3200,
    ),
    Doctor(
      id: 'doc-3',
      name: 'sidhraj',
      specialty: 'Dermatologist',
      experience: '12 years',
      rating: 4.7,
      available: false,
      nextAvailable: 'Available at 3:00 PM',
      phone: '+91 9328929903',
      avatar: 'ER',
      consultationFee: '\$60',
      languages: [
        'English',
        'Spanish',
        'French',
      ],
      patients: 1800,
    ),
    Doctor(
      id: 'doc-4',
      name: 'daman',
      specialty: 'Neurologist',
      experience: '18 years',
      rating: 4.9,
      available: true,
      phone: '+91 9306900217',
      avatar: 'MZ',
      consultationFee: '\$90',
      languages: [
        'English',
        'Mandarin',
      ],
      patients: 2100,
    ),
  ];

  // ==========================================================
  // FILTERED DOCTORS
  // ==========================================================

  List<Doctor> get filteredDoctors {
    if (_filter == 'available') {
      return doctors
          .where((doctor) => doctor.available)
          .toList();
    }

    return doctors;
  }

  int get availableDoctors {
    return doctors
        .where((doctor) => doctor.available)
        .length;
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6FF),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFEFF6FF),
                Colors.white,
                Color(0xFFECFEFF),
              ],
            ),
          ),
          child: Column(
            children: [
              _buildHeader(),
              _buildFilterTabs(),
              Expanded(
                child: _buildDoctorsList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // HEADER
  // ==========================================================

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        24,
        18,
        24,
        22,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF3B82F6),
            Color(0xFF06B6D4),
          ],
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x303B82F6),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (widget.onBack != null) {
                    widget.onBack!();
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(
                      alpha: 0.20,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    LucideIcons.arrowLeft,
                    color: Colors.white,
                    size: 21,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Doctor Call List',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 42),
            ],
          ),

          const SizedBox(height: 20),

          // ==================================================
          // STATS
          // ==================================================

          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  value: '${doctors.length}',
                  label: 'Total Doctors',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatCard(
                  value: '$availableDoctors',
                  label: 'Available Now',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatCard(
                  value: '24/7',
                  label: 'Support',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.12,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(
            alpha: 0.20,
          ),
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFDDEAFE),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // FILTER TABS
  // ==========================================================

  Widget _buildFilterTabs() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        24,
        20,
        24,
        12,
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildFilterButton(
              title: 'All Doctors (${doctors.length})',
              selected: _filter == 'all',
              onTap: () {
                setState(() {
                  _filter = 'all';
                });
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildFilterButton(
              title: 'Available ($availableDoctors)',
              selected: _filter == 'available',
              onTap: () {
                setState(() {
                  _filter = 'available';
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 200,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 13,
        ),
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(
            colors: [
              Color(0xFF3B82F6),
              Color(0xFF06B6D4),
            ],
          )
              : null,
          color: selected
              ? null
              : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? Colors.transparent
                : const Color(0xFFBFDBFE),
            width: 2,
          ),
          boxShadow: selected
              ? const [
            BoxShadow(
              color: Color(0x303B82F6),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ]
              : null,
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: selected
                ? Colors.white
                : const Color(0xFF2563EB),
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // DOCTORS LIST
  // ==========================================================

  Widget _buildDoctorsList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        24,
        4,
        24,
        30,
      ),
      itemCount: filteredDoctors.length,
      itemBuilder: (context, index) {
        final doctor = filteredDoctors[index];

        return _buildDoctorCard(doctor);
      },
    );
  }

  // ==========================================================
  // DOCTOR CARD
  // ==========================================================

  Widget _buildDoctorCard(Doctor doctor) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 16,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFDBEAFE),
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          // ==================================================
          // DOCTOR HEADER
          // ==================================================

          Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              _buildAvatar(doctor),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.name,
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF1E3A8A),
                        fontSize: 17,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Row(
                      children: [
                        _specialtyIcon(
                          doctor.specialty,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            doctor.specialty,
                            maxLines: 1,
                            overflow:
                            TextOverflow.ellipsis,
                            style: const TextStyle(
                              color:
                              Color(0xFF2563EB),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        const Icon(
                          Icons.timer_outlined,
                          size: 13,
                          color:
                          Color(0xFF60A5FA),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          doctor.experience,
                          style: const TextStyle(
                            color:
                            Color(0xFF60A5FA),
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.people_outline,
                          size: 13,
                          color:
                          Color(0xFF60A5FA),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${doctor.patients}+ patients',
                            style:
                            const TextStyle(
                              color:
                              Color(0xFF60A5FA),
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Column(
                crossAxisAlignment:
                CrossAxisAlignment.end,
                children: [
                  Container(
                    padding:
                    const EdgeInsets
                        .symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration:
                    BoxDecoration(
                      color:
                      const Color(
                        0xFFFEF3C7,
                      ),
                      borderRadius:
                      BorderRadius.circular(
                        20,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 13,
                          color:
                          Color(0xFFEAB308),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          doctor.rating
                              .toString(),
                          style:
                          const TextStyle(
                            color:
                            Color(0xFFA16207),
                            fontSize: 11,
                            fontWeight:
                            FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    doctor.consultationFee,
                    style: const TextStyle(
                      color: Color(0xFF2563EB),
                      fontSize: 13,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ==================================================
          // AVAILABILITY
          // ==================================================

          Container(
            width: double.infinity,
            padding:
            const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color:
              const Color(0xFFEFF6FF),
              borderRadius:
              BorderRadius.circular(13),
            ),
            child: Row(
              children: [
                Icon(
                  doctor.available
                      ? Icons.check_circle
                      : Icons.cancel,
                  size: 21,
                  color: doctor.available
                      ? Colors.green
                      : Colors.redAccent,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.available
                            ? 'Available Now'
                            : 'Currently Busy',
                        style: TextStyle(
                          color: doctor.available
                              ? Colors.green
                              : Colors.red,
                          fontSize: 12,
                          fontWeight:
                          FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        doctor.available
                            ? 'Ready for consultation'
                            : doctor.nextAvailable ??
                            'Not available',
                        style: TextStyle(
                          color: doctor.available
                              ? Colors.green.shade600
                              : Colors.red.shade400,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.access_time,
                  size: 20,
                  color: Color(0xFF60A5FA),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // ==================================================
          // LANGUAGES
          // ==================================================

          const Text(
            'Languages:',
            style: TextStyle(
              color: Color(0xFF2563EB),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 7),

          Wrap(
            spacing: 6,
            runSpacing: 6,
            children:
            doctor.languages.map(
                  (language) {
                return Container(
                  padding:
                  const EdgeInsets
                      .symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration:
                  BoxDecoration(
                    color:
                    const Color(
                      0xFFDBEAFE,
                    ),
                    borderRadius:
                    BorderRadius.circular(
                      20,
                    ),
                  ),
                  child: Text(
                    language,
                    style:
                    const TextStyle(
                      color:
                      Color(0xFF2563EB),
                      fontSize: 10,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                );
              },
            ).toList(),
          ),

          const SizedBox(height: 14),

          // ==================================================
          // ACTION BUTTONS
          // ==================================================

          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  icon: LucideIcons.phone,
                  title: 'Voice Call',
                  enabled: doctor.available,
                  gradient:
                  const LinearGradient(
                    colors: [
                      Color(0xFF22C55E),
                      Color(0xFF16A34A),
                    ],
                  ),
                  onTap: () {
                    _handleCall(doctor);
                  },
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _buildActionButton(
                  icon: LucideIcons.video,
                  title: 'WhatsApp Video',
                  enabled: doctor.available,
                  gradient:
                  const LinearGradient(
                    colors: [
                      Color(0xFF3B82F6),
                      Color(0xFF06B6D4),
                    ],
                  ),
                  onTap: () {
                    _handleVideoCall(doctor);
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ==================================================
          // PHONE NUMBER
          // ==================================================

          Center(
            child: Row(
              mainAxisSize:
              MainAxisSize.min,
              children: [
                const Icon(
                  LucideIcons.phone,
                  size: 12,
                  color: Color(0xFF2563EB),
                ),
                const SizedBox(width: 5),
                Text(
                  doctor.phone,
                  style: const TextStyle(
                    color:
                    Color(0xFF2563EB),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // AVATAR
  // ==========================================================

  Widget _buildAvatar(Doctor doctor) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            gradient:
            const LinearGradient(
              colors: [
                Color(0xFF3B82F6),
                Color(0xFF06B6D4),
              ],
            ),
            borderRadius:
            BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Color(0x303B82F6),
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              doctor.avatar,
              style:
              const TextStyle(
                color: Colors.white,
                fontWeight:
                FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ),
        ),

        if (doctor.available)
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              width: 20,
              height: 20,
              decoration:
              BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child: Center(
                child: Container(
                  width: 7,
                  height: 7,
                  decoration:
                  const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  // ==========================================================
  // SPECIALTY ICON
  // ==========================================================

  Widget _specialtyIcon(
      String specialty,
      ) {
    IconData icon =
        LucideIcons.stethoscope;

    switch (specialty) {
      case 'Cardiologist':
        icon = LucideIcons.heart;
        break;

      case 'Dermatologist':
        icon = LucideIcons.user;
        break;

      case 'Neurologist':
        icon = LucideIcons.brain;
        break;

      case 'Pediatrician':
        icon = LucideIcons.heart;
        break;

      case 'Orthopedic Surgeon':
        icon = LucideIcons.bone;
        break;

      case 'Ophthalmologist':
        icon = LucideIcons.eye;
        break;

      case 'Psychiatrist':
        icon = LucideIcons.brain;
        break;
    }

    return Icon(
      icon,
      size: 15,
      color:
      const Color(0xFF3B82F6),
    );
  }

  // ==========================================================
  // ACTION BUTTON
  // ==========================================================

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required bool enabled,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding:
        const EdgeInsets.symmetric(
          vertical: 12,
        ),
        decoration: BoxDecoration(
          gradient:
          enabled ? gradient : null,
          color: enabled
              ? null
              : const Color(0xFFE5E7EB),
          borderRadius:
          BorderRadius.circular(13),
        ),
        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 17,
              color: enabled
                  ? Colors.white
                  : const Color(0xFF9CA3AF),
            ),
            const SizedBox(width: 7),
            Text(
              title,
              style: TextStyle(
                color: enabled
                    ? Colors.white
                    : const Color(
                  0xFF9CA3AF,
                ),
                fontSize: 12,
                fontWeight:
                FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // VOICE CALL
  // ==========================================================

  Future<void> _handleCall(
      Doctor doctor,
      ) async {
    final bool? confirm =
    await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Call Doctor',
          ),
          content: Text(
            'Call ${doctor.name}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                );
              },
              child: const Text(
                'Cancel',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                );
              },
              child: const Text(
                'Call',
              ),
            ),
          ],
        );
      },
    );

    if (confirm != true) {
      return;
    }

    final Uri uri = Uri(
      scheme: 'tel',
      path: doctor.phone,
    );

    try {
      final bool launched =
      await launchUrl(uri);

      if (!launched && mounted) {
        _showMessage(
          'Could not open phone dialer.',
        );
      }
    } catch (_) {
      if (mounted) {
        _showMessage(
          'Could not open phone dialer.',
        );
      }
    }
  }

  // ==========================================================
  // WHATSAPP VIDEO CALL
  // ==========================================================

  Future<void> _handleVideoCall(
      Doctor doctor,
      ) async {
    // WhatsApp Click-to-Chat requires:
    // full international number
    // without +, spaces, brackets, or dashes.
    final String whatsappNumber =
    _cleanWhatsAppNumber(
      doctor.phone,
    );

    if (whatsappNumber.isEmpty) {
      _showMessage(
        'Invalid WhatsApp number.',
      );
      return;
    }

    final Uri whatsappUri = Uri.parse(
      'https://wa.me/$whatsappNumber',
    );

    try {
      final bool launched =
      await launchUrl(
        whatsappUri,
        mode:
        LaunchMode.externalApplication,
      );

      if (!launched && mounted) {
        _showMessage(
          'Could not open WhatsApp.',
        );
      }
    } catch (_) {
      if (!mounted) {
        return;
      }

      _showMessage(
        'Could not open WhatsApp.',
      );
    }
  }

  // ==========================================================
  // CLEAN WHATSAPP NUMBER
  // ==========================================================

  String _cleanWhatsAppNumber(
      String phone,
      ) {
    return phone
        .replaceAll(
      '+',
      '',
    )
        .replaceAll(
      ' ',
      '',
    )
        .replaceAll(
      '-',
      '',
    )
        .replaceAll(
      '(',
      '',
    )
        .replaceAll(
      ')',
      '',
    );
  }

  // ==========================================================
  // MESSAGE
  // ==========================================================

  void _showMessage(
      String message,
      ) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}