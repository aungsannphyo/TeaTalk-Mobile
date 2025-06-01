import 'package:flutter/material.dart';

class WheelWidget<T> extends StatelessWidget {
  final FixedExtentScrollController controller;
  final double itemExtent;
  final List<T> items;
  final T selectedItem;
  final ValueChanged<T> onSelectedItemChanged;
  final String Function(T) itemLabelBuilder;
  final double width;

  const WheelWidget({
    super.key,
    required this.controller,
    required this.itemExtent,
    required this.items,
    required this.selectedItem,
    required this.onSelectedItemChanged,
    required this.itemLabelBuilder,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: itemExtent,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: (index) {
          if (index >= 0 && index < items.length) {
            onSelectedItemChanged(items[index]);
          }
        },
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            if (index < 0 || index >= items.length) return null;
            final item = items[index];
            final isSelected = item == selectedItem;
            return Center(
              child: Text(
                itemLabelBuilder(item),
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  color: isSelected ? Colors.black : Colors.grey,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            );
          },
          childCount: items.length,
        ),
      ),
    );
  }
}
