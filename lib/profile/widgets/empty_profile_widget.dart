import 'package:flutter/material.dart';

class EmptyProfileWidget extends StatelessWidget {
  const EmptyProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFEFF6FF), // blue-50
            Colors.white,
            Color(0xFFECFEFF), // cyan-50
          ],
        ),
      ),
      child: const Center(
        child: Text(
          "Profile not found",
          style: TextStyle(
            color: Color(0xFF2563EB),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}