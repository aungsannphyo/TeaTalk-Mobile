import 'package:flutter/material.dart';

import '../../../style/text_style.dart';

class CommonDatePickerWidget extends StatelessWidget {
  final TextEditingController datePickerController;
  final String label;
  final Future<void> Function() pickDate;

  const CommonDatePickerWidget({
    super.key,
    required this.datePickerController,
    required this.label,
    required this.pickDate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: pickDate,
      child: AbsorbPointer(
        child: TextFormField(
          controller: datePickerController,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: AppTextStyles.regular,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            suffixIcon: const Icon(Icons.calendar_today),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Select your birthdate';
            }
            return null;
          },
        ),
      ),
    );
  }
}
