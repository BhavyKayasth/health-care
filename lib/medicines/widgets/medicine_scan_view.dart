import 'package:flutter/material.dart';

import '../controller/medicines_controller.dart';

class MedicineScanView extends StatelessWidget {
  final MedicinesState state;
  final MedicinesController controller;

  const MedicineScanView({
    super.key,
    required this.state,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final medicine = state.scannedMedicine;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            'Scan Medicine',
            style: TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Point your camera at the medicine package or prescription',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF2563EB),
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 20),

          Container(
            height: 320,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFDCEEFF),
                  Color(0xFFDFFBFF),
                ],
              ),
              borderRadius:
              BorderRadius.circular(28),
            ),
            child: Center(
              child: state.scanning
                  ? const SizedBox(
                width: 90,
                height: 90,
                child:
                CircularProgressIndicator(
                  strokeWidth: 4,
                  color: Color(0xFFF97316),
                ),
              )
                  : medicine == null
                  ? const Icon(
                Icons
                    .photo_camera_outlined,
                size: 85,
                color: Color(0xFF93C5FD),
              )
                  : _ScannedMedicineCard(
                medicine:
                medicine,
              ),
            ),
          ),

          const SizedBox(height: 16),

          if (medicine != null)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      controller.addToCart(
                        medicine.id,
                      );
                      controller.clearScanResult();
                    },
                    child: const Text(
                      'Add to Cart',
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      controller.buyNow(
                        medicine,
                      );
                      controller.clearScanResult();
                    },
                    style:
                    ElevatedButton.styleFrom(
                      backgroundColor:
                      const Color(
                        0xFFF97316,
                      ),
                      foregroundColor:
                      Colors.white,
                    ),
                    child: const Text(
                      'Buy Now',
                    ),
                  ),
                ),
              ],
            )
          else
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: state.scanning
                    ? null
                    : controller.startScan,
                icon: const Icon(
                  Icons.camera_alt,
                ),
                label: Text(
                  state.scanning
                      ? 'Scanning...'
                      : 'Start Scanning',
                ),
                style:
                ElevatedButton.styleFrom(
                  backgroundColor:
                  const Color(
                    0xFFF97316,
                  ),
                  foregroundColor:
                  Colors.white,
                  padding:
                  const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ScannedMedicineCard
    extends StatelessWidget {
  final dynamic medicine;

  const _ScannedMedicineCard({
    required this.medicine,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 32,
          ),

          const SizedBox(height: 8),

          const Text(
            'Scanned Successfully!',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            medicine.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF0F172A),
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            medicine.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF2563EB),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}