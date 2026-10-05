import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../data/medicine_data.dart';

class MedicineCategoryChips
    extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String>
  onCategorySelected;

  const MedicineCategoryChips({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
        medicineCategories.map(
              (category) {
            final bool selected =
                selectedCategory ==
                    category;

            return Padding(
              padding:
              const EdgeInsets.only(
                right: 8,
              ),
              child: ChoiceChip(
                label: Text(category),
                selected: selected,
                selectedColor:
                const Color(
                  0xFFEF6C2F,
                ),
                backgroundColor:
                Colors.white,
                labelStyle: TextStyle(
                  color: selected
                      ? Colors.white
                      : AppColors.primary,
                  fontWeight:
                  FontWeight.w600,
                  fontSize: 11,
                ),
                onSelected: (_) {
                  onCategorySelected(
                    category,
                  );
                },
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}