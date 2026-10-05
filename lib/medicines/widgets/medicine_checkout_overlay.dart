import 'package:flutter/material.dart';

import '../controller/medicines_controller.dart';
import 'medicine_checkout_sheet.dart';

class MedicineCheckoutOverlay extends StatelessWidget {
  final MedicinesState state;
  final MedicinesController controller;

  const MedicineCheckoutOverlay({
    super.key,
    required this.state,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    //----------------------------------------------------------
    // DO NOT SHOW WHEN CHECKOUT IS CLOSED
    //----------------------------------------------------------

    if (!state.checkoutVisible ||
        state.buyNowItem == null) {
      return const SizedBox.shrink();
    }

    //----------------------------------------------------------
    // FULL SCREEN OVERLAY
    //----------------------------------------------------------

    return Positioned.fill(
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            //----------------------------------------------------
            // DARK BACKDROP
            //----------------------------------------------------

            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: controller.closeCheckout,
                child: Container(
                  color: Colors.black.withOpacity(0.60),
                ),
              ),
            ),

            //----------------------------------------------------
            // CHECKOUT SHEET
            //----------------------------------------------------

            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                top: false,
                child: MedicineCheckoutSheet(
                  state: state,
                  controller: controller,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}