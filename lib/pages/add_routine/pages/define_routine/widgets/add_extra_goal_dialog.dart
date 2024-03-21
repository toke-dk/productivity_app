import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:productivity_app/models/routine.dart';

import '../../../../../widgets/my_date_picker.dart';
import '../../../../../widgets/my_size_transition.dart';
import 'my_value_changer.dart';

enum TimeUnit {
  year('for et år'),
  month('for en måned'),
  total("i alt"),
  week("for en uge"),
  day("for en dag");

  const TimeUnit(this.translatedName);

  final String translatedName;
}

class AddExtraGoalDialog extends StatefulWidget {
  final TimeUnit timeUnit;

  const AddExtraGoalDialog({super.key, required this.timeUnit});

  @override
  State<AddExtraGoalDialog> createState() => _AddExtraGoalDialogState();
}

class _AddExtraGoalDialogState extends State<AddExtraGoalDialog> {
  late TextEditingController _goalText;

  @override
  void initState() {
    super.initState();
    _goalText = new TextEditingController(text: '0');
  }

  bool _exactEndDateActivated = false;

  int goalValue = 1;

  bool hasExactStartDate = false;
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text("Tilføj et Ekstra-Mål"),
      contentPadding: EdgeInsets.all(30),
      children: [
        Text(
          "Mål ${widget.timeUnit.translatedName}",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        SizedBox(
          height: 10,
        ),
        MyValueChanger(
          handleValueChange: (int newVal) {
            setState(() {
              goalValue = newVal;
            });
          },
          minValue: 1,
          value: goalValue,
        ),
        SizedBox(
          height: 20,
        ),
        _StartDateField(
          isVisible: hasExactStartDate,
          onVisibilityChange: (bool newVal) {
            setState(() {
              hasExactStartDate = newVal;
            });
          },
          selectedDate: _selectedDate,
          onDateChange: (DateTime newDate) {
            setState(() {
              _selectedDate = newDate;
            });
          },
        ),
        SizedBox(
          height: 20,
        ),
        SwitchListTile(
          value: _exactEndDateActivated,
          onChanged: (newVal) {
            setState(() {
              _exactEndDateActivated = !_exactEndDateActivated;
            });
          },
          title: Text("Afslutning"),
          subtitle:
              Text("Vil du afslutte rutinen når ekstra-målet er fuldført?"),
        ),
        SizedBox(
          height: 18,
        ),
        Row(
          children: [
            OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Annuler")),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: FilledButton(
                  onPressed: () {
                    Navigator.pop(
                        context,
                        ExtraGoal(
                            timePeriod: widget.timeUnit,
                            amountForTotalTimePeriod: goalValue,
                            startDate: hasExactStartDate ? _selectedDate : null,
                            shouldEndWhenFinished: _exactEndDateActivated));
                  },
                  child: Text("Opret mål")),
            ),
          ],
        )
      ],
    );
  }
}

class _StartDateField extends StatefulWidget {
  const _StartDateField(
      {super.key,
      required this.isVisible,
      required this.onVisibilityChange,
      required this.selectedDate,
      required this.onDateChange});

  final bool isVisible;
  final Function(bool newVal) onVisibilityChange;
  final DateTime selectedDate;
  final Function(DateTime newDate) onDateChange;

  @override
  State<_StartDateField> createState() => _StartDateFieldState();
}

class _StartDateFieldState extends State<_StartDateField>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          value: widget.isVisible,
          onChanged: widget.onVisibilityChange,
          title: Text("Start dato"),
        ),
        MySizeTransition(
            isShowing: widget.isVisible,
            child: MyDatePicker(
                selectedDate: widget.selectedDate,
                onDateSelected: widget.onDateChange)),
      ],
    );
  }
}
