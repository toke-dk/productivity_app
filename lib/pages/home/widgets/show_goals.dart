import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:productivity_app/models/unit.dart';
import 'package:productivity_app/pages/add_activity_amount/add_activity_amount.dart';
import 'package:productivity_app/pages/add_goal/add_goal_page.dart';
import 'package:productivity_app/shared/extensions/date_time_extensions.dart';
import 'package:productivity_app/shared/extensions/double_extension.dart';
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
      required this.onAmountGoalAdd, required this.onAmountActionsLog});

  final List<AmountGoal> amountGoals;
  final List<CheckmarkGoal> checkmarkGoals;
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

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.grey[100]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          amountGoals.isNotEmpty || checkmarkGoals.isNotEmpty
              ? Column(
                  children: [
                    Text(
                      "Dine Mål",
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                )
              : SizedBox(),
          amountGoals.isEmpty && checkmarkGoals.isEmpty
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
                                        onCheckMarkGoalAdd: (CheckmarkGoal
                                                checkmarkGoal) =>
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
                      children: List.generate(checkmarkGoals.length, (index) {
                        CheckmarkGoal currentGoal = checkmarkGoals[index];
                        return Column(
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
                                        Icon(Icons.check),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text("Målet er udført!"),
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
                                        Text("Udfør!"),
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
                              onChanged: (newDate) => null,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${currentGoal.doneDaysOfWeekFromWeekNr(_currentDay.weekOfYear).length}/${currentGoal.daysPerWeek} udførte",
                                  style: _labelTextStyle,
                                ),
                                Text(
                                  "${currentGoal.weeksUntilEndDateFromNow} uger tilbage",
                                  style: _labelTextStyle,
                                ),
                              ],
                            ),
                            Divider(
                              height: 60,
                              thickness: 2,
                            ),
                          ],
                        );
                      }),
                    ),
                    Column(
                      children: List.generate(amountGoals.length, (index) {
                        AmountGoal _currentGoal = amountGoals[index];
                        double _amountDone =
                            _currentGoal.doneAmountActivities.totalAmountDone;
                        double _percent = _amountDone / _currentGoal.amountGoal;

                        List<DoneAmountActivity> _doneActivitiesToday =
                            _currentGoal
                                .doneAmountActivities
                                .where((element) =>
                                    element.date.isSameDate(_currentDay))
                                .toList();

                        List<DoneAmountActivity> _doneActivitiesInPast =
                            _currentGoal.doneAmountActivities
                                .where((element) =>
                                    _currentDay
                                        .difference(element.date)
                                        .inDays >
                                    0)
                                .toList();

                        double _goalForToday = (_currentGoal.amountGoal -
                                _doneActivitiesInPast.totalAmountDone) /
                            (_currentGoal.daysUntilEndDateFromNow + 1);
                        double _percentForToday =
                            _doneActivitiesToday.totalAmountDone /
                                _goalForToday;

                        double _amountLeftToday = _goalForToday -
                            _doneActivitiesToday.totalAmountDone;

                        String _displayUnitString =
                            _currentGoal.chosenUnit != Units.unitLess
                                ? _currentGoal.chosenUnit.shortStringName
                                : 'gange';

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                DisplayActionType(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  actionType: _currentGoal.actionType,
                                  axisDirection: Axis.horizontal,
                                ),
                                _GoalMenuOptions(
                                  onLogPress: () => onAmountActionsLog(_currentGoal),
                                  onDelete: () => onAmountGoalDelete != null
                                      ? onAmountGoalDelete!(_currentGoal)
                                      : null,
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
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
                                        height: 15,
                                      ),
                                      LinearPercentIndicator(
                                        barRadius: Radius.circular(20),
                                        percent: _percentForToday <= 1 ? _percentForToday : 1,
                                        progressColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        lineHeight: 14,
                                        animation: true,
                                        animationDuration: 1000,
                                        leading: Text(
                                            "${(_percentForToday * 100).myDoubleToString}%"),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${_amountLeftToday.myDoubleToString} $_displayUnitString tilbage",
                                            style: _labelTextStyle,
                                          ),
                                          Text(
                                            "${_doneActivitiesToday.totalAmountDone.myDoubleToString}"
                                            "/${_goalForToday.myDoubleToString} $_displayUnitString",
                                            style: _labelTextStyle,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 40,
                                      ),
                                    ],
                                  )
                                : SizedBox(),
                            Text(
                              _currentGoal.frequencyFormat ==
                                      GoalFrequencyFormats.inTotal
                                  ? "Totalt mål (${_currentGoal.amountGoal.myDoubleToString})"
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
                              leading: Text(
                                  "${(_percent * 100).toStringAsFixed((_percent * 100) % 1 == 0 ? 0 : 1)}%"),
                              trailing: IconButton(
                                icon: Icon(Icons.add_circle_outlined),
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddActivityAmount(
                                              onComplete: (amount) =>
                                                  onAmountGoalActivityAdded(
                                                      _currentGoal,
                                                      DoneAmountActivity(
                                                          date: _currentDay,
                                                          amount: amount)),
                                              actionType:
                                                  _currentGoal.actionType,
                                            ))),
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  "Slut: ${DateFormat("dd/MM/yyyy").format(_currentGoal.endDate)} "
                                  "(${_currentGoal.daysUntilEndDateFromNow} d)",
                                  style: _labelTextStyle,
                                ),
                                Text(
                                  "${_amountDone.myDoubleToString}/${_currentGoal.amountGoal.myDoubleToString} $_displayUnitString ",
                                  style: _labelTextStyle,
                                ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                            index != amountGoals.length - 1
                                ? Divider(
                                    height: 20,
                                  )
                                : SizedBox(),
                            Divider(
                              height: 60,
                              thickness: 2,
                            ),
                          ],
                        );
                      }),
                    ),
                    Center(
                      child: MyThemeButton(
                        onTap: () {
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
                        labelText: "Tilføj et mål mere",
                      ),
                    )
                  ],
                ),
        ],
      ),
    );
  }
}

class _GoalMenuOptions extends StatelessWidget {
  const _GoalMenuOptions({super.key, this.onDelete, this.onEdit, this.onLogPress});

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
                onTap: onLogPress != null ? () => onLogPress!() : null,
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
