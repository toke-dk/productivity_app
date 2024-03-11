import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyDatePicker extends StatelessWidget {
  MyDatePicker({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    this.firstDateOption,
    this.lastDateOption,
  });

  final DateTime? firstDateOption;
  final DateTime? lastDateOption;
  final DateTime selectedDate;
  final Function(DateTime newDate) onDateSelected;

  @override
  Widget build(BuildContext context) {
    final DateTime _firstDateOption = firstDateOption ??
        DateTime(
            DateTime.now().year - 10, DateTime.now().month, DateTime.now().day);
    final DateTime _lastDateOption = lastDateOption ??
        DateTime(
            DateTime.now().year + 10, DateTime.now().month, DateTime.now().day);

    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context,
            firstDate: _firstDateOption,
            lastDate: _lastDateOption,
            initialDate: selectedDate);
        if (pickedDate != null && pickedDate != selectedDate) {
          onDateSelected(pickedDate);
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: Colors.grey[900]!)),
        child: Row(
          children: [
            Icon(Icons.date_range),
            SizedBox(
              width: 20,
            ),
            Text(
              DateFormat("EEE. dd. MMM. yyyy").format(selectedDate),
            ),
            Spacer()
          ],
        ),
      ),
    );
  }
}
