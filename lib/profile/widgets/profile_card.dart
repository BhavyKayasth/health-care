import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'health_stats.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  // ============================================================
  // GET CURRENT USER NAME
  // ============================================================

  String _getUserName(User? user) {
    final displayName = user?.displayName?.trim();

    if (displayName != null && displayName.isNotEmpty) {
      return displayName;
    }

    // Fallback if displayName is unavailable.
    final email = user?.email?.trim();

    if (email != null && email.isNotEmpty) {
      final emailName = email.split('@').first.trim();

      if (emailName.isNotEmpty) {
        return emailName;
      }
    }

    return 'User';
  }

  // ============================================================
  // GET INITIALS
  // ============================================================

  String _getInitials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.isEmpty) {
      return 'U';
    }

    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }

    return '${parts.first[0]}${parts.last[0]}'
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final User? user =
        FirebaseAuth.instance.currentUser;

    final String userName =
    _getUserName(user);

    final String initials =
    _getInitials(userName);

    final String email =
    user?.email?.trim().isNotEmpty == true
        ? user!.email!.trim()
        : 'Email unavailable';

    return Transform.translate(
      offset: const Offset(0, -80),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
            BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color:
                Colors.black.withOpacity(.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              // ==================================================
              // AVATAR + NAME
              // ==================================================

              Row(
                children: [
                  Container(
                    width: 78,
                    height: 78,
                    decoration:
                    const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient:
                      LinearGradient(
                        colors: [
                          Color(0xFF3B82F6),
                          Color(0xFF06B6D4),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        initials,
                        style:
                        const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          maxLines: 1,
                          overflow:
                          TextOverflow.ellipsis,
                          style:
                          const TextStyle(
                            fontSize: 22,
                            fontWeight:
                            FontWeight.bold,
                            color:
                            Color(0xFF0F172A),
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          user?.uid != null
                              ? 'ID: ${user!.uid.substring(0, user.uid.length >= 8 ? 8 : user.uid.length)}'
                              : 'ID unavailable',
                          style:
                          const TextStyle(
                            color:
                            Color(0xFF64748B),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ==================================================
              // EMAIL
              // ==================================================

              _infoTile(
                icon: LucideIcons.mail,
                color: Colors.blue,
                text: email,
              ),

              const SizedBox(height: 14),

              // ==================================================
              // PHONE
              // ==================================================

              _infoTile(
                icon: LucideIcons.phone,
                color: Colors.green,
                text:
                user?.phoneNumber?.isNotEmpty == true
                    ? user!.phoneNumber!
                    : 'Phone number not added',
              ),

              const SizedBox(height: 14),

              // ==================================================
              // LOCATION
              // ==================================================

              _infoTile(
                icon: LucideIcons.mapPin,
                color: Colors.deepPurple,
                text: 'Location not added',
              ),

              const SizedBox(height: 22),

              const Divider(),

              const SizedBox(height: 18),

              // ==================================================
              // HEALTH STATS
              // ==================================================

              const HealthStats(
                bloodGroup: "B+",
                age: "22",
                height: "5'9\"",
                weight: "75kg",
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // INFO TILE
  // ============================================================

  Widget _infoTile({
    required IconData icon,
    required Color color,
    required String text,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: color,
          size: 20,
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF475569),
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}