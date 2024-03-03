import 'package:flutter/material.dart';
import 'package:animated_digit/animated_digit.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:productivity_app/models/unit.dart';
import 'package:productivity_app/shared/extensions/date_time_extensions.dart';
import 'package:productivity_app/shared/extensions/double_extension.dart';

import '../../../models/goal.dart';

class ShowAmountGoals extends StatelessWidget {
  const ShowAmountGoals(
      {super.key,
      required this.goals,
      required this.currentDay,
      required this.onAmountGoalActivityAdded,
      required this.onAmountActionsLog,
      this.onAmountGoalDelete});

  final List<AmountGoal> goals;
  final DateTime currentDay;
  final Function(AmountGoal goal, DoneAmountActivity activity)
      onAmountGoalActivityAdded;
  final Function(AmountGoal goal) onAmountActionsLog;
  final Function(AmountGoal goal)? onAmountGoalDelete;

  @override
  Widget build(BuildContext context) {
    final TextStyle _labelTextStyle = Theme.of(context).textTheme.labelMedium!;

    return Column(
      children: List.generate(goals.length, (index) {
        AmountGoal _currentGoal = goals[index];

        ///TODO: make theese a method in the goal class
        double _amountDone = _currentGoal.doneAmountActivities.totalAmountDone;
        double _percent = _amountDone / _currentGoal.amountGoal;

        double _totalAmountLeft = _currentGoal.amountGoal - _amountDone;

        List<DoneAmountActivity> _doneActivitiesToday = _currentGoal
            .doneAmountActivities
            .where((element) => element.date.isSameDate(currentDay))
            .toList();

        List<DoneAmountActivity> _doneActivitiesInPast = _currentGoal
            .doneAmountActivities
            .where((element) => element.date.onlyYearMonthDay
                .isBefore(currentDay.onlyYearMonthDay))
            .toList();

        double _goalForToday =
            (_currentGoal.amountGoal - _doneActivitiesInPast.totalAmountDone) /
                (_currentGoal.daysUntilEndDateFromNow + 1);
        double _percentForToday =
            _doneActivitiesToday.totalAmountDone / _goalForToday;

        double _amountLeftToday =
            _goalForToday - _doneActivitiesToday.totalAmountDone;

        String _displayUnitString = _currentGoal.chosenUnit != Units.unitLess
            ? _currentGoal.chosenUnit.shortStringName
            : 'gange';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _currentGoal.frequencyFormat == GoalFrequencyFormats.inTotal
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Dagens mål (${_goalForToday.myDoubleToString})",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      LinearPercentIndicator(
                          barRadius: Radius.circular(20),
                          percent: _percentForToday <= 1 ? _percentForToday : 1,
                          progressColor: Theme.of(context).colorScheme.primary,
                          lineHeight: 14,
                          animation: true,
                          animationDuration: 1000,
                          leading: _MyAnimatedPercent(
                              val: (_percentForToday * 100))),
                      Row(
                        children: [
                          _amountLeftToday > 0
                              ? AnimatedDigitWidget(
                                  duration: 1500.milliseconds,
                                  value: _amountLeftToday,
                                  textStyle: _labelTextStyle,
                                )
                              : SizedBox(),
                          Text(
                            _amountLeftToday > 0
                                ? " $_displayUnitString tilbage"
                                : "Fuldført!",
                            style: _labelTextStyle,
                          ),
                          Spacer(),
                          AnimatedDigitWidget(
                            value: _doneActivitiesToday.totalAmountDone,
                            textStyle: _labelTextStyle,
                            duration: 1500.milliseconds,
                          ),
                          Text(
                            "/${_goalForToday.myDoubleToString} $_displayUnitString",
                            style: _labelTextStyle,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  )
                : SizedBox(),
            Text(
              _currentGoal.frequencyFormat == GoalFrequencyFormats.inTotal
                  ? "Totalt mål (${_totalAmountLeft > 0 ? _currentGoal.amountGoal.myDoubleToString : 'Fuldført!'})"
                  : _currentGoal.frequencyFormat == GoalFrequencyFormats.perWeek
                      ? "Ugens mål"
                      : _currentGoal.frequencyFormat ==
                              GoalFrequencyFormats.perDay
                          ? "Dagens mål"
                          : "FEJL!!",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            LinearPercentIndicator(
              barRadius: Radius.circular(20),
              percent: _percent > 1 ? 1 : _percent,
              progressColor: Theme.of(context).colorScheme.primary,
              lineHeight: 11,
              animation: true,
              animationDuration: 1000,
              leading: _MyAnimatedPercent(
                val: _percent * 100,
              ),
            ),
            Row(
              children: [
                Text(
                  "Slut: ${DateFormat("dd/MM/yyyy").format(_currentGoal.endDate)} "
                  "(${_currentGoal.daysUntilEndDateFromNow} d)",
                  style: _labelTextStyle,
                ),
                Spacer(),
                AnimatedDigitWidget(
                  value: _amountDone,
                  textStyle: _labelTextStyle,
                  duration: 1500.milliseconds,
                ),
                Text(
                  "/${_currentGoal.amountGoal.myDoubleToString} $_displayUnitString ",
                  style: _labelTextStyle,
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}

class _MyAnimatedPercent extends StatelessWidget {
  const _MyAnimatedPercent({required this.val, this.style});

  final double val;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return AnimatedDigitWidget(
      duration: 1500.milliseconds,
      value: val,
      suffix: "%",
      decimalSeparator: ",",
      textStyle: style ?? Theme.of(context).textTheme.bodyMedium,
    );
  }
}
