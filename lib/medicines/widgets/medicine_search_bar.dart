import 'package:flutter/material.dart';

class MedicineSearchBar extends StatelessWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;

  const MedicineSearchBar({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      controller: TextEditingController(
        text: initialValue,
      )..selection =
      TextSelection.collapsed(
        offset: initialValue.length,
      ),
      decoration: InputDecoration(
        hintText: 'Search medicines...',
        prefixIcon: const Icon(
          Icons.search,
          color: Color(0xFF60A5FA),
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}