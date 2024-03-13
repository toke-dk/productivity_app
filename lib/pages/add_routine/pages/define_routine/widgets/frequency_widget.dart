import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:productivity_app/widgets/my_size_transition.dart';
import 'package:weekday_selector/weekday_selector.dart';
import 'my_value_changer.dart';

enum _TimeUnit {
  day("dag"),
  week("uge"),
  month('måned'),
  year('år');

  const _TimeUnit(this.translatedName);

  final String translatedName;
}

class ChooseFrequency extends StatefulWidget {
  const ChooseFrequency({super.key});

  @override
  State<ChooseFrequency> createState() => _ChooseFrequencyState();
}

class _ChooseFrequencyState extends State<ChooseFrequency> {
  _TimeUnit selectedTimeUnit = _TimeUnit.day;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Indtastninger skal udføres hver", style: Theme.of(context).textTheme.bodyLarge,),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyValueChanger(
              handleValueChange: (int newVal) =>
                  debugPrint(newVal.toString()), value: 1,
            ),
            SizedBox(
              width: 30,
            ),
            DropdownButton<_TimeUnit>(
              underline: SizedBox.shrink(),
                value: selectedTimeUnit,
                onChanged: (_TimeUnit? frequency) {
                  if (frequency != null)
                    setState(() {
                      selectedTimeUnit = frequency;
                    });
                },
                items: _TimeUnit.values
                    .map((e) => DropdownMenuItem(
                    value: e, child: Text(e.translatedName)))
                    .toList()),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        _TimeUnitChildWrapper(
          selectedTimeUnit: selectedTimeUnit,
        ),
      ],
    );
  }
}

class _TimeUnitChildWrapper extends StatelessWidget {
  const _TimeUnitChildWrapper({super.key, required this.selectedTimeUnit});

  final _TimeUnit selectedTimeUnit;

  Widget buildChildForUnit() {
    if (selectedTimeUnit == _TimeUnit.week) {
      return _WeekTimeUnitChild();
    } else if (selectedTimeUnit == _TimeUnit.month) {
      return _MonthTimeUnitChild();
    }
    return SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MySizeTransition(isShowing: selectedTimeUnit == _TimeUnit.week, child: _WeekTimeUnitChild()),
        MySizeTransition(isShowing: selectedTimeUnit == _TimeUnit.month, child: _MonthTimeUnitChild()),
      ],
    );
  }
}

class _WeekTimeUnitChild extends StatefulWidget {
  const _WeekTimeUnitChild({super.key});

  @override
  State<_WeekTimeUnitChild> createState() => _WeekTimeUnitChildState();
}

class _WeekTimeUnitChildState extends State<_WeekTimeUnitChild> {
  bool _isCustomSelected = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            MyValueChanger(
              handleValueChange: (int newVal) {},
              maxValue: 6, value: 1,
            ),
            SizedBox(
              width: 20,
            ),
            Text("dage hver uge")
          ],
        ),
        // SizedBox(height: 20,),
        // SwitchListTile(
        //     title: Text("Tilpasset"),
        //     value: _isCustomSelected,
        //     onChanged: (bool newVal) {
        //       setState(() {
        //         _isCustomSelected = newVal;
        //       });
        //     }),
        // MySizeTransition(
        //     isShowing: _isCustomSelected,
        //     child: Column(
        //       children: [
        //         WeekdaySelector(
        //             onChanged: (int newVal) {},
        //             values: List.generate(7, (index) => false))
        //       ],
        //     )),
      ],
    );
  }
}

class _MonthTimeUnitChild extends StatefulWidget {
  const _MonthTimeUnitChild({super.key});

  @override
  State<_MonthTimeUnitChild> createState() => _MonthTimeUnitChildState();
}

class _MonthTimeUnitChildState extends State<_MonthTimeUnitChild> {
  bool _isCustomSelected = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            MyValueChanger(
              handleValueChange: (int newVal) {},
              maxValue: 30, value: 1,
            ),
            SizedBox(
              width: 20,
            ),
            Text("dage hver måned")
          ],
        ),
        // SizedBox(height: 20,),
        // SwitchListTile(
        //     title: Text("Tilpasset"),
        //     value: _isCustomSelected,
        //     onChanged: (bool newVal) {
        //       setState(() {
        //         _isCustomSelected = newVal;
        //       });
        //     }),
        // MySizeTransition(
        //     isShowing: _isCustomSelected,
        //     child: Column(
        //       children: [
        //         Text("Child here")
        //       ],
        //     )),
      ],
    );
  }
}
