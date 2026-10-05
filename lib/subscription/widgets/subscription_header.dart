import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SubscriptionHeader extends StatelessWidget {
  final VoidCallback onBack;

  const SubscriptionHeader({
    super.key,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        20,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onBack,
            borderRadius:
            BorderRadius.circular(30),
            child: Ink(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color:
                Colors.white.withOpacity(.85),
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x18000000),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                LucideIcons.arrowLeft,
                color: Color(0xFF2563EB),
                size: 21,
              ),
            ),
          ),
        ),
      ),
    );
  }
}