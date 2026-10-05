import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../auth/controller/auth_controller.dart';
import '../../auth/screens/auth_screen.dart';

import 'settings_item.dart';

class SettingsSection extends ConsumerWidget {
  const SettingsSection({super.key});

  // ============================================================
  // LOGOUT
  // ============================================================

  Future<void> _logout(
      BuildContext context,
      WidgetRef ref,
      ) async {
    // ----------------------------------------------------------
    // CONFIRM LOGOUT
    // ----------------------------------------------------------

    final bool? shouldLogout =
    await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Logout',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Are you sure you want to logout?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext)
                    .pop(false);
              },
              child: const Text(
                'Cancel',
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext)
                    .pop(true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Logout',
              ),
            ),
          ],
        );
      },
    );

    // ----------------------------------------------------------
    // USER CANCELLED
    // ----------------------------------------------------------

    if (shouldLogout != true) {
      return;
    }

    // ----------------------------------------------------------
    // PERFORM LOGOUT
    // ----------------------------------------------------------

    try {
      await ref
          .read(
        authControllerProvider.notifier,
      )
          .signOut();

      if (!context.mounted) {
        return;
      }

      // --------------------------------------------------------
      // REMOVE ALL PREVIOUS SCREENS
      // AND RETURN TO LOGIN SCREEN
      // --------------------------------------------------------

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) =>
          const AuthScreen(),
        ),
            (route) => false,
      );
    } catch (e) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              'Unable to logout. Please try again.',
            ),
            behavior:
            SnackBarBehavior.floating,
          ),
        );
    }
  }

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          // ====================================================
          // ACCOUNT SETTINGS
          // ====================================================

          _buildSection(
            title: "Account Settings",
            children: [
              SettingsItem(
                icon: LucideIcons.user,
                title: "Personal Information",
                onTap: () {},
              ),

              SettingsItem(
                icon: LucideIcons.lock,
                title: "Privacy & Security",
                onTap: () {},
              ),

              SettingsItem(
                icon: LucideIcons.bell,
                title: "Notifications",
                badge: "3",
                onTap: () {},
              ),

              SettingsItem(
                icon: LucideIcons.creditCard,
                title: "Payment Methods",
                showDivider: false,
                onTap: () {},
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ====================================================
          // HEALTH
          // ====================================================

          _buildSection(
            title: "Health",
            children: [
              SettingsItem(
                icon: LucideIcons.heart,
                title: "Medical History",
                iconColor: Colors.red,
                onTap: () {},
              ),

              SettingsItem(
                icon: LucideIcons.fileText,
                title: "Insurance Details",
                iconColor: Colors.indigo,
                onTap: () {},
              ),

              SettingsItem(
                icon: LucideIcons.shield,
                title: "Emergency Contacts",
                iconColor: Colors.green,
                showDivider: false,
                onTap: () {},
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ====================================================
          // SUPPORT
          // ====================================================

          _buildSection(
            title: "Support",
            children: [
              SettingsItem(
                icon:
                LucideIcons.helpCircle,
                title: "Help & Support",
                iconColor: Colors.orange,
                onTap: () {},
              ),

              SettingsItem(
                icon: LucideIcons.fileText,
                title: "Terms & Privacy",
                iconColor: Colors.purple,
                onTap: () {},
              ),

              SettingsItem(
                icon: LucideIcons.settings,
                title: "App Settings",
                showDivider: false,
                onTap: () {},
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ====================================================
          // ABOUT
          // ====================================================

          _buildSection(
            title: "About",
            children: [
              SettingsItem(
                icon: LucideIcons.info,
                title: "About Us",
                showDivider: false,
                onTap: () {},
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ====================================================
          // LOGOUT BUTTON
          // ====================================================

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                _logout(
                  context,
                  ref,
                );
              },
              icon: const Icon(
                LucideIcons.logOut,
                color: Colors.white,
              ),
              label: const Text(
                "Logout",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),
              style:
              ElevatedButton.styleFrom(
                backgroundColor:
                Colors.red,
                foregroundColor:
                Colors.white,
                elevation: 2,
                padding:
                const EdgeInsets.symmetric(
                  vertical: 16,
                ),
                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(
                    18,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ====================================================
          // APP VERSION
          // ====================================================

          const Center(
            child: Text(
              "HealthCare AI v1.0.0",
              style: TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 12,
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION BUILDER
  // ============================================================

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 6,
            bottom: 12,
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
        ),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
            BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color:
                Colors.black.withOpacity(
                  .05,
                ),
                blurRadius: 12,
                offset:
                const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}