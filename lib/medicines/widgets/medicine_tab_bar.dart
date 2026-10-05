import 'package:flutter/material.dart';

import '../controller/medicines_controller.dart';

class MedicineTabBar extends StatelessWidget {
  final MedicineTab activeTab;
  final ValueChanged<MedicineTab> onTabChanged;

  const MedicineTabBar({
    super.key,
    required this.activeTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _TabButton(
            label: 'Buy',
            icon: Icons.shopping_cart,
            selected:
            activeTab == MedicineTab.buy,
            onTap: () {
              onTabChanged(
                MedicineTab.buy,
              );
            },
          ),

          _TabButton(
            label: 'Scan',
            icon:
            Icons.document_scanner_outlined,
            selected:
            activeTab == MedicineTab.scan,
            onTap: () {
              onTabChanged(
                MedicineTab.scan,
              );
            },
          ),

          _TabButton(
            label: 'AI Check',
            icon: Icons.auto_awesome,
            selected:
            activeTab ==
                MedicineTab.symptoms,
            onTap: () {
              onTabChanged(
                MedicineTab.symptoms,
              );
            },
          ),

          _TabButton(
            label: 'Orders',
            icon:
            Icons.inventory_2_outlined,
            selected:
            activeTab ==
                MedicineTab.orders,
            onTap: () {
              onTabChanged(
                MedicineTab.orders,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius:
        BorderRadius.circular(30),
        child: Container(
          padding:
          const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 9,
          ),
          decoration: BoxDecoration(
            color: selected
                ? Colors.white
                : Colors.white.withOpacity(.20),
            borderRadius:
            BorderRadius.circular(30),
            boxShadow: selected
                ? const [
              BoxShadow(
                color: Color(0x26000000),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ]
                : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: selected
                    ? const Color(
                  0xFFEA580C,
                )
                    : Colors.white,
              ),

              const SizedBox(width: 6),

              Text(
                label,
                style: TextStyle(
                  color: selected
                      ? const Color(
                    0xFFEA580C,
                  )
                      : Colors.white,
                  fontSize: 11,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}