import 'package:flutter/material.dart';


class AuthDivider extends StatelessWidget {
  const AuthDivider({
    super.key,
    this.text = "or",
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            thickness: 1.2,
            color: Color(0xFFD6E4FF),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF93C5FD),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        const Expanded(
          child: Divider(
            thickness: 1.2,
            color: Color(0xFFD6E4FF),
          ),
        ),
      ],
    );
  }
}