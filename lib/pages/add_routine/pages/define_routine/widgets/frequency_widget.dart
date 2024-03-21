import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:productivity_app/models/providers/routine_provider.dart';
import 'package:productivity_app/models/routine.dart';
import 'package:productivity_app/widgets/my_size_transition.dart';
import 'package:provider/provider.dart';
import 'package:weekday_selector/weekday_selector.dart';
import 'my_value_changer.dart';

enum DayToYearTimes {
  day("dag"),
  week("uge"),
  month('måned'),
  year('år');

  const DayToYearTimes(this.translatedName);

  final String translatedName;
}

class ChooseFrequency extends StatelessWidget {
  const ChooseFrequency({super.key});

  @override
  Widget build(BuildContext context) {
    DayToYearTimes selectedTimeUnit =
        Provider.of<RoutineProvider>(context).completionScheduleTimeUnit;

    void _onTimeUnitChanged(DayToYearTimes newValue) {
      Provider.of<RoutineProvider>(context, listen: false).setCSTimeUnit =
          newValue;
    }

    int frequencyAmount =
        Provider.of<RoutineProvider>(context).completionScheduleFrequency;

    void _handleValueChange(int newValue) {
      Provider.of<RoutineProvider>(context, listen: false).setCSFrequency =
          newValue;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Indtastninger skal udføres hver",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyValueChanger(
              handleValueChange: _handleValueChange,
              value: frequencyAmount,
            ),
            SizedBox(
              width: 30,
            ),
            DropdownButton<DayToYearTimes>(
                underline: SizedBox.shrink(),
                value: selectedTimeUnit,
                onChanged: (DayToYearTimes? frequency) {
                  if (frequency != null) {
                    _onTimeUnitChanged(frequency);

                    // Making sure to reset it to avoid having for example
                    // 8 days per week
                    Provider.of<RoutineProvider>(context, listen: false)
                        .setCSAmountPerTime = 1;
                  }
                  ;
                },
                items: DayToYearTimes.values
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

  final DayToYearTimes selectedTimeUnit;

  @override
  Widget build(BuildContext context) {
    _handleValueChange(int newVal) {
      Provider.of<RoutineProvider>(context, listen: false).setCSAmountPerTime =
          newVal;
    }

    return Column(
      children: [
        MySizeTransition(
            isShowing: selectedTimeUnit == DayToYearTimes.week,
            child: _WeekTimeUnitChild(
              handleValueChange: _handleValueChange,
            )),
        MySizeTransition(
            isShowing: selectedTimeUnit == DayToYearTimes.month,
            child: _MonthTimeUnitChild(
              handleValueChange: _handleValueChange,
            )),
        MySizeTransition(
            isShowing: selectedTimeUnit == DayToYearTimes.year,
            child: _YearTimeUnitChild(
              handleValueChange: _handleValueChange,
            )),
      ],
    );
  }
}

class _WeekTimeUnitChild extends StatelessWidget {
  const _WeekTimeUnitChild({super.key, required this.handleValueChange});

  final Function(int newVal) handleValueChange;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            MyValueChanger(
              handleValueChange: handleValueChange,
              maxValue: 6,
              value:
                  Provider.of<RoutineProvider>(context).completionScheduleDaysEachTimePeriod,
            ),
            SizedBox(
              width: 20,
            ),
            Text("dage hver uge")
          ],
        ),
      ],
    );
  }
}

class _MonthTimeUnitChild extends StatelessWidget {
  const _MonthTimeUnitChild({super.key, required this.handleValueChange});

  final Function(int newVal) handleValueChange;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            MyValueChanger(
              handleValueChange: handleValueChange,
              maxValue: 30,
              value:
                  Provider.of<RoutineProvider>(context).completionScheduleDaysEachTimePeriod,
            ),
            SizedBox(
              width: 20,
            ),
            Text("dage hver måned")
          ],
        ),
      ],
    );
  }
}

class _YearTimeUnitChild extends StatelessWidget {
  const _YearTimeUnitChild({super.key, required this.handleValueChange});

  final Function(int newVal) handleValueChange;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            MyValueChanger(
              handleValueChange: handleValueChange,
              maxValue: 30,
              value:
                  Provider.of<RoutineProvider>(context).completionScheduleDaysEachTimePeriod,
            ),
            SizedBox(
              width: 20,
            ),
            Text("dage hvert år")
          ],
        ),
      ],
    );
  }
}
