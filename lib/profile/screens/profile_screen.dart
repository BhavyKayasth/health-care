import 'package:flutter/material.dart';

import '../widgets/profile_header.dart';
import '../widgets/profile_card.dart';
import '../widgets/settings_section.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FAFF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: const [
              ProfileHeader(),

              SizedBox(height: 20),

              ProfileCard(),

              SizedBox(height: 20),

              SettingsSection(),
            ],
          ),
        ),
      ),
    );
  }
}