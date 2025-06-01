import 'package:flutter/material.dart';

class CommonSelectBoxWidget<T> extends StatelessWidget {
  final List<T> values;
  final T? selectedValue;
  final void Function(T) onSelect;
  final String Function(T) labelBuilder;
  final String? errorText;

  const CommonSelectBoxWidget({
    super.key,
    required this.values,
    required this.selectedValue,
    required this.onSelect,
    required this.labelBuilder,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 12,
          children: values.map((v) {
            final isSelected = selectedValue == v;
            return ChoiceChip(
              label: Text(labelBuilder(v)),
              selected: isSelected,
              onSelected: (_) => onSelect(v),
              selectedColor: Theme.of(context).primaryColor,
              backgroundColor: Colors.grey.shade200,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            );
          }).toList(),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              errorText!,
              style: TextStyle(
                color: Colors.red.shade600,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
