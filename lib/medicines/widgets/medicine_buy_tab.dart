import 'package:flutter/material.dart';

import '../controller/medicines_controller.dart';
import 'medicine_category_chips.dart';
import 'medicine_list.dart';
import 'medicine_search_bar.dart';

class MedicineBuyTab extends StatelessWidget {
  final MedicinesState state;
  final MedicinesController controller;

  const MedicineBuyTab({
    super.key,
    required this.state,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        30,
      ),
      child: Column(
        children: [
          MedicineSearchBar(
            initialValue: state.searchQuery,
            onChanged: controller.search,
          ),

          const SizedBox(height: 14),

          MedicineCategoryChips(
            selectedCategory:
            state.selectedCategory,
            onCategorySelected:
            controller.changeCategory,
          ),

          const SizedBox(height: 12),

          MedicineList(
            medicines: state.filteredMedicines,
          ),
        ],
      ),
    );
  }
}