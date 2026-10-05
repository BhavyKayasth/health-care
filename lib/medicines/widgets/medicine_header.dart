import 'package:flutter/material.dart';

import '../controller/medicines_controller.dart';
import 'medicine_tab_bar.dart';

class MedicineHeader extends StatelessWidget {
  final MedicinesState state;
  final VoidCallback onBack;
  final VoidCallback onCartTap;
  final ValueChanged<MedicineTab> onTabChanged;

  const MedicineHeader({
    super.key,
    required this.state,
    required this.onBack,
    required this.onCartTap,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        16,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFF97316),
            Color(0xFFEF4444),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(34),
          bottomRight: Radius.circular(34),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _HeaderButton(
                icon: Icons.arrow_back_rounded,
                onTap: onBack,
              ),

              const Expanded(
                child: Text(
                  'Health Buddy Pharmacy',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Stack(
                clipBehavior: Clip.none,
                children: [
                  _HeaderButton(
                    icon:
                    Icons.shopping_cart_outlined,
                    onTap: onCartTap,
                  ),

                  if (state.cart.isNotEmpty)
                    Positioned(
                      top: -2,
                      right: -2,
                      child: Container(
                        width: 19,
                        height: 19,
                        decoration:
                        const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${state.cart.length}',
                            style:
                            const TextStyle(
                              color: Color(
                                0xFFEA580C,
                              ),
                              fontSize: 10,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          MedicineTabBar(
            activeTab: state.activeTab,
            onTabChanged: onTabChanged,
          ),
        ],
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius:
        BorderRadius.circular(30),
        child: Ink(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.20),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }
}