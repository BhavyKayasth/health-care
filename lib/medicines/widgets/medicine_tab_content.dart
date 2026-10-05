import 'package:flutter/material.dart';

import '../controller/medicines_controller.dart';
import 'medicine_buy_tab.dart';
import 'medicine_scan_view.dart';

class MedicineTabContent extends StatelessWidget {
  final MedicinesState state;
  final MedicinesController controller;

  const MedicineTabContent({
    super.key,
    required this.state,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    switch (state.activeTab) {
      case MedicineTab.buy:
        return MedicineBuyTab(
          state: state,
          controller: controller,
        );

      case MedicineTab.scan:
        return MedicineScanView(
          state: state,
          controller: controller,
        );

      case MedicineTab.symptoms:
        return _SymptomsPlaceholder(
          state: state,
          controller: controller,
        );

      case MedicineTab.orders:
        return const _OrdersPlaceholder();
    }
  }
}

//============================================================
// TEMPORARY AI CHECK TAB
//============================================================

class _SymptomsPlaceholder extends StatelessWidget {
  final MedicinesState state;
  final MedicinesController controller;

  const _SymptomsPlaceholder({
    required this.state,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFA855F7),
                  Color(0xFFEC4899),
                ],
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 30,
            ),
          ),

          const SizedBox(height: 14),

          const Text(
            'AI Symptom Checker',
            style: TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Describe your symptoms and get medicine suggestions',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF2563EB),
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 22),

          TextField(
            minLines: 4,
            maxLines: 6,
            onChanged: controller.updateSymptoms,
            decoration: InputDecoration(
              hintText:
              'E.g., Headache, fever, cold...',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 14),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed:
              state.symptoms.trim().isEmpty ||
                  state.analyzingSymptoms
                  ? null
                  : controller.analyzeSymptoms,
              icon: state.analyzingSymptoms
                  ? const SizedBox(
                width: 18,
                height: 18,
                child:
                CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : const Icon(
                Icons.auto_awesome,
              ),
              label: Text(
                state.analyzingSymptoms
                    ? 'Analyzing...'
                    : 'Analyze Symptoms',
              ),
              style:
              ElevatedButton.styleFrom(
                backgroundColor:
                const Color(0xFFA855F7),
                foregroundColor: Colors.white,
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

          const SizedBox(height: 20),

          ...state.aiSuggestions.map(
                (medicine) => Container(
              width: double.infinity,
              margin: const EdgeInsets.only(
                bottom: 12,
              ),
              padding:
              const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x10000000),
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    medicine.name,
                    style: const TextStyle(
                      color: Color(0xFF0F172A),
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    medicine.description,
                    style: const TextStyle(
                      color: Color(0xFF2563EB),
                      fontSize: 11,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    '₹${medicine.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Color(0xFF0F172A),
                      fontWeight:
                      FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//============================================================
// TEMPORARY ORDERS TAB
//============================================================

class _OrdersPlaceholder
    extends StatelessWidget {
  const _OrdersPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 80,
              color: Color(0xFFBFDBFE),
            ),
            SizedBox(height: 15),
            Text(
              'No Orders Yet',
              style: TextStyle(
                color: Color(0xFF0F172A),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Your medicine orders will appear here',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF2563EB),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}