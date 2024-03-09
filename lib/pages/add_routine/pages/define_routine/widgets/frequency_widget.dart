import 'package:flutter/material.dart';
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
        Text("Indtastning hver"),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
                flex: 2,
                child: MyValueChanger(
                  handleValueChange: (int newVal) =>
                      debugPrint(newVal.toString()),
                )),
            SizedBox(
              width: 30,
            ),
            Expanded(
              flex: 1,
              child: FittedBox(
                child: DropdownMenu(
                    initialSelection: _TimeUnit.day,
                    onSelected: (_TimeUnit? frequency) {
                      if (frequency != null)
                        setState(() {
                          selectedTimeUnit = frequency;
                        });
                    },
                    dropdownMenuEntries: _TimeUnit.values
                        .map((e) => DropdownMenuEntry(
                            value: e, label: e.translatedName))
                        .toList()),
              ),
            ),
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
    }
    return SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return MySizeTransition(
      isShowing: selectedTimeUnit == _TimeUnit.week,
      child: Column(
        children: [
          Row(
            children: [
              MyValueChanger(
                handleValueChange: (int newVal) {},
                maxValue: 7,
              ),
              SizedBox(
                width: 20,
              ),
              Text("dage hver ${selectedTimeUnit.translatedName}")
            ],
          ),
          SizedBox(
            height: 20,
          ),
          buildChildForUnit(),
          SizedBox(height: 40,)
        ],
      ),
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
        SwitchListTile(
            title: Text("Tilpasset"),
            value: _isCustomSelected,
            onChanged: (bool newVal) {
              setState(() {
                _isCustomSelected = newVal;
              });
            }),
        MySizeTransition(
          isShowing: _isCustomSelected,
            child: Column(
          children: [
            WeekdaySelector(
                onChanged: (int newVal) {},
                values: List.generate(7, (index) => false))
          ],
        )),
      ],
    );
  }
}
