import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/medicines_controller.dart';
import '../widgets/medicine_cart_sheet.dart';
import '../widgets/medicine_checkout_overlay.dart';
import '../widgets/medicine_header.dart';
import '../widgets/medicine_tab_content.dart';

class MedicinesScreen extends ConsumerWidget {
  final VoidCallback onBack;

  const MedicinesScreen({
    super.key,
    required this.onBack,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final state = ref.watch(
      medicinesControllerProvider,
    );

    final controller = ref.read(
      medicinesControllerProvider.notifier,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF0F7FF),
      body: SafeArea(
        child: Stack(
          children: [
            //--------------------------------------------------
            // MAIN CONTENT
            //--------------------------------------------------

            Column(
              children: [
                //------------------------------------------------
                // HEADER
                //------------------------------------------------

                MedicineHeader(
                  state: state,
                  onBack: onBack,
                  onCartTap: () {
                    _showCart(
                      context,
                      state,
                      controller,
                    );
                  },
                  onTabChanged: controller.changeTab,
                ),

                //------------------------------------------------
                // TAB CONTENT
                //------------------------------------------------

                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(
                      milliseconds: 250,
                    ),
                    child: MedicineTabContent(
                      key: ValueKey(
                        state.activeTab,
                      ),
                      state: state,
                      controller: controller,
                    ),
                  ),
                ),
              ],
            ),

            //--------------------------------------------------
            // CHECKOUT OVERLAY
            //--------------------------------------------------

            if (state.checkoutVisible)
              MedicineCheckoutOverlay(
                state: state,
                controller: controller,
              ),
          ],
        ),
      ),
    );
  }

  //------------------------------------------------------------
  // SHOW CART
  //------------------------------------------------------------

  void _showCart(
      BuildContext context,
      MedicinesState state,
      MedicinesController controller,
      ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return MedicineCartSheet(
          state: state,
          controller: controller,
        );
      },
    );
  }
}