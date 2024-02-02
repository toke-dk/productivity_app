import 'package:animated_digit/animated_digit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:productivity_app/models/unit.dart';
import 'package:productivity_app/pages/add_activity_amount/add_activity_amount.dart';
import 'package:productivity_app/pages/add_goal/add_goal_page.dart';
import 'package:productivity_app/shared/extensions/date_time_extensions.dart';
import 'package:productivity_app/shared/extensions/double_extension.dart';
import 'package:productivity_app/shared/extensions/gaol_extensions.dart';
import 'package:productivity_app/widgets/MyThemeButton.dart';
import 'package:productivity_app/widgets/display_activity_type.dart';
import 'package:weekday_selector/weekday_selector.dart';

import '../../../models/goal.dart';

class ShowGoalsWidget extends StatelessWidget {
  const ShowGoalsWidget(
      {super.key,
      required this.amountGoals,
      required this.checkmarkGoals,
      required this.onAmountGoalActivityAdded,
      this.onAmountGoalDelete,
      this.onCheckmarkGoalDelete,
      required this.onCheckMarkGoalDoneDateAdd,
      required this.onCheckmarkGoalDoneDateDelete,
      required this.onCheckMarkGoalAdd,
      required this.onAmountGoalAdd,
      required this.onAmountActionsLog});

  final List<AmountGoal> amountGoals;
  final List<CheckmarkGoal> checkmarkGoals;

  List<AmountGoal> get activeAmountGoalsToday =>
      amountGoals.activeGoalsFromToday;

  List<CheckmarkGoal> get activeCheckmarkGoalsToday =>
      checkmarkGoals.activeGoalsFromToday;

  final Function(AmountGoal goal, DoneAmountActivity activity)
      onAmountGoalActivityAdded;

  final Function(AmountGoal goal) onAmountActionsLog;

  final Function(CheckmarkGoal goal, DateTime date) onCheckMarkGoalDoneDateAdd;
  final Function(CheckmarkGoal goal, DateTime date)
      onCheckmarkGoalDoneDateDelete;

  final Function(AmountGoal goal)? onAmountGoalDelete;
  final Function(CheckmarkGoal goal)? onCheckmarkGoalDelete;
  final Function(CheckmarkGoal checkmarkGoal) onCheckMarkGoalAdd;
  final Function(AmountGoal amountGoal) onAmountGoalAdd;

  List<bool?> makeValuesList(
      List<int> weekdays, DateTime today, DateTime endDate) {
    List<bool?> listIfMondayFirst = List.generate(
        7,
        (index) =>
            today.weekday >= index + 1 ? weekdays.contains(index + 1) : null);

    List<bool?> weekdaysWhereSundayFirst = [
      listIfMondayFirst.last,
      ...listIfMondayFirst.sublist(0, listIfMondayFirst.length - 1)
    ];

    return weekdaysWhereSundayFirst;
  }

  @override
  Widget build(BuildContext context) {
    DateTime _currentDay = DateTime.now();

    TextStyle _labelTextStyle = Theme.of(context)
        .textTheme
        .labelMedium!
        .copyWith(color: Colors.grey[700]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        activeAmountGoalsToday.isNotEmpty ||
                activeCheckmarkGoalsToday.isNotEmpty
            ? Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Dine Mål",
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddGoalPage(
                                        onCheckMarkGoalAdd: (CheckmarkGoal
                                                checkmarkGoal) =>
                                            onCheckMarkGoalAdd(checkmarkGoal),
                                        onAmountGoalAdd:
                                            (AmountGoal amountGoal) =>
                                                onAmountGoalAdd(amountGoal),
                                      )));
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add),
                            SizedBox(
                              width: 5,
                            ),
                            Text("Tilføj et mål mere"),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              )
            : SizedBox(),
        activeAmountGoalsToday.isEmpty && activeCheckmarkGoalsToday.isEmpty
            ? Center(
                child: Column(
                  children: [
                    Text("Du har ikke sat et mål endnu"),
                    SizedBox(
                      height: 20,
                    ),
                    MyThemeButton(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddGoalPage(
                                      onCheckMarkGoalAdd:
                                          (CheckmarkGoal checkmarkGoal) =>
                                              onCheckMarkGoalAdd(checkmarkGoal),
                                      onAmountGoalAdd: (AmountGoal goal) =>
                                          onAmountGoalAdd(goal),
                                    )));
                      },
                      labelText: "Angiv mål!",
                    ),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: List.generate(activeCheckmarkGoalsToday.length,
                        (index) {
                      CheckmarkGoal currentGoal =
                          activeCheckmarkGoalsToday[index];
                      return _GoalCard(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                DisplayActionType(
                                  actionType: currentGoal.actionType,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                ),
                                _GoalMenuOptions(
                                  onDelete: () => onCheckmarkGoalDelete != null
                                      ? onCheckmarkGoalDelete!(currentGoal)
                                      : null,
                                  onLogPress: () => debugPrint("Show logs"),
                                )
                              ],
                            ),
                            currentGoal.isDateDone(_currentDay)
                                ? FilledButton(
                                    onPressed: () =>
                                        onCheckmarkGoalDoneDateDelete(
                                            currentGoal, _currentDay),
                                    child: Row(
                                      children: [
                                        Icon(Icons.check_circle),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text("Udført!"),
                                      ],
                                      mainAxisSize: MainAxisSize.min,
                                    ),
                                  )
                                : OutlinedButton(
                                    onPressed: () => onCheckMarkGoalDoneDateAdd(
                                        currentGoal, _currentDay),
                                    child: Row(
                                      children: [
                                        Icon(Icons.add_circle_outline),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text("Udfør"),
                                      ],
                                      mainAxisSize: MainAxisSize.min,
                                    ),
                                  ),
                            SizedBox(
                              height: 10,
                            ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Ugens mål (${currentGoal.daysPerWeek})",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                )),
                            WeekdaySelector(
                              onChanged: (newDate) {
                                DateTime dateToAdd = _currentDay
                                    .subtract(Duration(
                                        days: _currentDay.weekday - newDate))
                                    .onlyYearMonthDay;

                                !currentGoal.doneDates.contains(dateToAdd)
                                    ? onCheckMarkGoalDoneDateAdd(
                                        currentGoal, dateToAdd)
                                    : onCheckmarkGoalDoneDateDelete(
                                        currentGoal, dateToAdd);
                              },
                              values: makeValuesList(
                                  currentGoal.doneDaysOfWeekFromWeekNr(
                                      _currentDay.weekOfYear),
                                  _currentDay,
                                  currentGoal.endDate),
                              elevation: 0,
                              shortWeekdays: [
                                "S",
                                "M",
                                "T",
                                "O",
                                "T",
                                "F",
                                "L"
                              ],
                              shape: CircleBorder(
                                  side: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 2)),
                            ),
                            Row(
                              children: [
                                AnimatedDigitWidget(
                                  value: currentGoal
                                      .doneDaysOfWeekFromWeekNr(
                                          _currentDay.weekOfYear)
                                      .length,
                                  textStyle: _labelTextStyle,
                                ),
                                Text(
                                  "/${currentGoal.daysPerWeek} udførte",
                                  style: _labelTextStyle,
                                ),
                                Spacer(),
                                Text(
                                  "${currentGoal.weeksUntilEndDateFromNow} uger tilbage",
                                  style: _labelTextStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                  Column(
                    children:
                        List.generate(activeAmountGoalsToday.length, (index) {
                      AmountGoal _currentGoal = activeAmountGoalsToday[index];

                      ///TODO: make theese a method in the goal class
                      double _amountDone =
                          _currentGoal.doneAmountActivities.totalAmountDone;
                      double _percent = _amountDone / _currentGoal.amountGoal;

                      double _totalAmountLeft =
                          _currentGoal.amountGoal - _amountDone;

                      List<DoneAmountActivity> _doneActivitiesToday =
                          _currentGoal.doneAmountActivities
                              .where((element) =>
                                  element.date.isSameDate(_currentDay))
                              .toList();

                      List<DoneAmountActivity> _doneActivitiesInPast =
                          _currentGoal.doneAmountActivities
                              .where((element) => element.date.onlyYearMonthDay
                                  .isBefore(_currentDay.onlyYearMonthDay))
                              .toList();

                      double _goalForToday = (_currentGoal.amountGoal -
                              _doneActivitiesInPast.totalAmountDone) /
                          (_currentGoal.daysUntilEndDateFromNow + 1);
                      double _percentForToday =
                          _doneActivitiesToday.totalAmountDone / _goalForToday;

                      double _amountLeftToday =
                          _goalForToday - _doneActivitiesToday.totalAmountDone;

                      String _displayUnitString =
                          _currentGoal.chosenUnit != Units.unitLess
                              ? _currentGoal.chosenUnit.shortStringName
                              : 'gange';

                      return _GoalCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                DisplayActionType(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  actionType: _currentGoal.actionType,
                                  axisDirection: Axis.horizontal,
                                ),
                                Spacer(),
                                TextButton.icon(
                                  label: Text("Tilføj"),
                                  icon: Icon(
                                    Icons.add_circle_outlined,
                                    size: 25,
                                  ),
                                  onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AddActivityAmount(
                                                onComplete: (DoneAmountActivity
                                                        doneAmount) =>
                                                    onAmountGoalActivityAdded(
                                                        _currentGoal,
                                                        doneAmount),
                                                actionType:
                                                    _currentGoal.actionType,
                                                date: _currentDay,
                                              ))),
                                ),
                                _GoalMenuOptions(
                                  onLogPress: () =>
                                      onAmountActionsLog(_currentGoal),
                                  onDelete: () => onAmountGoalDelete != null
                                      ? onAmountGoalDelete!(_currentGoal)
                                      : null,
                                )
                              ],
                            ),
                            _currentGoal.frequencyFormat ==
                                    GoalFrequencyFormats.inTotal
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Dagens mål (${_goalForToday.myDoubleToString})",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      LinearPercentIndicator(
                                          barRadius: Radius.circular(20),
                                          percent: _percentForToday <= 1
                                              ? _percentForToday
                                              : 1,
                                          progressColor: Theme.of(context)
                                              .colorScheme
                                              .primary,
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
                                            value: _doneActivitiesToday
                                                .totalAmountDone,
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
                              _currentGoal.frequencyFormat ==
                                      GoalFrequencyFormats.inTotal
                                  ? "Totalt mål (${_totalAmountLeft > 0 ? _currentGoal.amountGoal.myDoubleToString : 'Fuldført!'})"
                                  : _currentGoal.frequencyFormat ==
                                          GoalFrequencyFormats.perWeek
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
                              progressColor:
                                  Theme.of(context).colorScheme.primary,
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
                        ),
                      );
                    }),
                  ),
                ],
              ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  "Tidligere mål",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextButton(
                  child: Text(
                      "Se alle (${checkmarkGoals.previousGoalsFromToday.length + amountGoals.previousGoalsFromToday.length})"),
                  onPressed: () {},
                )
              ],
            ),
            Column(
              children: [
                Text(
                  "Fremtidige mål",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextButton(
                  child: Text(
                      "Se alle (${checkmarkGoals.futureGoalsFromToday.length + amountGoals.futureGoalsFromToday.length})"),
                  onPressed: () {},
                )
              ],
            ),
          ],
        )
      ],
    );
  }
}

class _GoalMenuOptions extends StatelessWidget {
  const _GoalMenuOptions(
      {super.key, this.onDelete, this.onEdit, this.onLogPress});

  final Function()? onDelete;
  final Function()? onEdit;
  final Function()? onLogPress;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        itemBuilder: (context) => [
              PopupMenuItem(
                  child: ListTile(
                leading: Icon(
                  Icons.history,
                ),
                title: Text("Logbog"),
                onTap: onLogPress != null
                    ? () {
                        Navigator.pop(context);
                        onLogPress!();
                      }
                    : null,
              )),
              PopupMenuItem(
                onTap: onEdit,
                child: ListTile(
                  leading: Icon(Icons.edit),
                  title: Text("Rediger"),
                ),
              ),
              PopupMenuItem(
                  onTap: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text("Du er i gang med at slette et mål!"),
                            content:
                                Text(" Når du først har slettet et mål kan det "
                                    "ikke gendannes"),
                            actions: [
                              OutlinedButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("Anuller")),
                              FilledButton(
                                  onPressed: () {
                                    onDelete != null ? onDelete!() : null;
                                    onDelete != null
                                        ? Navigator.pop(context)
                                        : null;
                                  },
                                  child: Text("Slet"))
                            ],
                          )),
                  child: ListTile(
                    leading: Icon(Icons.delete),
                    title: Text("Slet"),
                  )),
            ]);
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
      margin: EdgeInsets.only(top: 16),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
    );
  }
}

class _MyAnimatedPercent extends StatelessWidget {
  const _MyAnimatedPercent({super.key, required this.val, this.style});

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
