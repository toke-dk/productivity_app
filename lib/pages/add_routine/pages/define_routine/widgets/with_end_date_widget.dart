import 'package:flutter/material.dart';

import '../../../../../widgets/my_date_picker.dart';
import '../../../../../widgets/my_size_transition.dart';

class WithEndDateWidget extends StatelessWidget {
  WithEndDateWidget(
      {super.key,
      required this.onDateChange,
      required this.selectedDate,
      required this.switchValue,
      required this.onSwitchChange});

  final DateTime selectedDate;
  final Function(DateTime newDate) onDateChange;
  final bool switchValue;
  final Function(bool newVale) onSwitchChange;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text("Slutdato"),
            subtitle: Text("Skal rutinen have en slutdato"),
            value: switchValue,
            onChanged: onSwitchChange),
        MySizeTransition(
          child: MyDatePicker(
              selectedDate: selectedDate, onDateSelected: onDateChange),
          isShowing: switchValue,
        ),
      ],
    );
  }
}
