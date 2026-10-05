import 'package:flutter/material.dart';

class HealthTrackerTabs extends StatelessWidget {
  final String activeTab;
  final ValueChanged<String> onChanged;

  const HealthTrackerTabs({
    super.key,
    required this.activeTab,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 18),

      padding: const EdgeInsets.all(4),

      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),

        borderRadius: BorderRadius.circular(16),
      ),

      child: Row(children: [_buildTab('Today'), _buildTab('This Week')]),
    );
  }

  Widget _buildTab(String title) {
    final bool selected = activeTab == title;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          onChanged(title);
        },

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),

          padding: const EdgeInsets.symmetric(vertical: 11),

          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,

            borderRadius: BorderRadius.circular(13),

            boxShadow: selected
                ? const [
                    BoxShadow(
                      color: Color(0x12000000),
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ]
                : null,
          ),

          child: Text(
            title,

            textAlign: TextAlign.center,

            style: TextStyle(
              color: selected
                  ? const Color(0xFF2563EB)
                  : const Color(0xFF60A5FA),

              fontSize: 13,

              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
