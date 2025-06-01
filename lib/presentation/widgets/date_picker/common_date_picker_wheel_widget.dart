import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../style/text_style.dart';
import '../common_button_widget.dart';
import 'wheel_widget.dart';

typedef OnDateSelected = void Function(DateTime selectedDate);

class CommonDatePickerWheelWidget extends HookWidget {
  final DateTime initialDate;
  final OnDateSelected onDateSelected;
  final int minYear;
  final int maxYear;
  final double itemExtent;

  CommonDatePickerWheelWidget({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
    this.minYear = 1900,
    double? itemExtent,
  })  : itemExtent = itemExtent ?? 40.0,
        maxYear = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    final years = [for (int y = minYear; y <= maxYear; y++) y];
    final selectedYear = useState<int>(initialDate.year);
    final selectedMonth = useState<int>(initialDate.month);
    final selectedDay = useState<int>(initialDate.day);

    List<int> getDaysInMonth(int year, int month) {
      final dayCount = DateUtils.getDaysInMonth(year, month);
      return [for (int d = 1; d <= dayCount; d++) d];
    }

    final daysInMonth = useState<List<int>>(
      getDaysInMonth(selectedYear.value, selectedMonth.value),
    );

    final dayController = useMemoized(
      () => FixedExtentScrollController(initialItem: selectedDay.value - 1),
      [selectedDay.value],
    );
    final monthController = useMemoized(
      () => FixedExtentScrollController(initialItem: selectedMonth.value - 1),
      [selectedMonth.value],
    );
    final yearController = useMemoized(
      () => FixedExtentScrollController(
          initialItem: selectedYear.value - minYear),
      [selectedYear.value],
    );

    useEffect(() {
      final newDays = getDaysInMonth(selectedYear.value, selectedMonth.value);
      daysInMonth.value = newDays;

      if (selectedDay.value > newDays.length) {
        selectedDay.value = newDays.length;
        dayController.jumpToItem(newDays.length - 1);
      }
      return null;
    }, [selectedYear.value, selectedMonth.value]);

    useEffect(() {
      dayController.jumpToItem(selectedDay.value - 1);
      monthController.jumpToItem(selectedMonth.value - 1);
      yearController.jumpToItem(selectedYear.value - minYear);
      return null;
    }, [selectedDay.value, selectedMonth.value, selectedYear.value]);

    final wheelHeight = 150.0;
    final wheelWidth = (MediaQuery.of(context).size.width - 64) / 3;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      height: 300,
      child: Column(
        children: [
          Text(
            "Select Your Birthdate",
            style: AppTextStyles.semiBold.copyWith(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: wheelHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Day wheel
                WheelWidget<int>(
                  controller: dayController,
                  itemExtent: itemExtent,
                  items: daysInMonth.value,
                  selectedItem: selectedDay.value,
                  onSelectedItemChanged: (day) => selectedDay.value = day,
                  itemLabelBuilder: (day) => day.toString(),
                  width: wheelWidth,
                ),

                // Month wheel
                WheelWidget<int>(
                  controller: monthController,
                  itemExtent: itemExtent,
                  items: List.generate(12, (index) => index + 1),
                  selectedItem: selectedMonth.value,
                  onSelectedItemChanged: (month) => selectedMonth.value = month,
                  itemLabelBuilder: (month) {
                    const monthNames = [
                      'Jan',
                      'Feb',
                      'Mar',
                      'Apr',
                      'May',
                      'Jun',
                      'Jul',
                      'Aug',
                      'Sep',
                      'Oct',
                      'Nov',
                      'Dec'
                    ];
                    return monthNames[month - 1];
                  },
                  width: wheelWidth,
                ),
                // Year wheel
                WheelWidget<int>(
                  controller: yearController,
                  itemExtent: itemExtent,
                  items: years,
                  selectedItem: selectedYear.value,
                  onSelectedItemChanged: (year) => selectedYear.value = year,
                  itemLabelBuilder: (year) => year.toString(),
                  width: wheelWidth,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          CommonButtonWidget(
            isLoading: false,
            label: "Save",
            onPressed: () {
              final selectedDate = DateTime(
                selectedYear.value,
                selectedMonth.value,
                selectedDay.value,
              );
              onDateSelected(selectedDate);
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
}
