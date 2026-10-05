import 'package:flutter/material.dart';

import '../model/medicine_model.dart';
import 'medicine_card.dart';

class MedicineList extends StatelessWidget {
  final List<MedicineModel> medicines;

  const MedicineList({
    super.key,
    required this.medicines,
  });

  @override
  Widget build(BuildContext context) {
    if (medicines.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 50),
        child: Text(
          'No medicines found',
          style: TextStyle(
            color: Color(0xFF64748B),
          ),
        ),
      );
    }

    return Column(
      children: medicines
          .map(
            (medicine) => MedicineCard(
          medicine: medicine,
        ),
      )
          .toList(),
    );
  }
}