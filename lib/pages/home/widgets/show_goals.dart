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

import '../../../models/goal.dart';

class ShowGoalsWidget extends StatelessWidget {
  const ShowGoalsWidget(
      {super.key,
      required this.amountGoals,
      required this.checkmarkGoals,
      required this.onAmountGoalActivityAdded,
      this.onAmountGoalDelete,
      this.onCheckmarkGoalDelete,
      required this.onCheckMarkGoalDoneDateAdd});

  final List<AmountGoal> amountGoals;
  final List<CheckmarkGoal> checkmarkGoals;
  final Function(AmountGoal goal, DoneAmountActivity activity)
      onAmountGoalActivityAdded;

  final Function(CheckmarkGoal goal, DateTime date) onCheckMarkGoalDoneDateAdd;

  final Function(AmountGoal goal)? onAmountGoalDelete;
  final Function(CheckmarkGoal goal)? onCheckmarkGoalDelete;

  @override
  Widget build(BuildContext context) {
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
                                  builder: (context) => AddGoalPage()));
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
                                )
                              ],
                            ),
                            OutlinedButton(
                              onPressed: () => onCheckMarkGoalDoneDateAdd(currentGoal, DateTime.now()),
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
                            Text("Ugens mål"),
                            Text(currentGoal.doneDates.toString()),
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
                                    element.date.isSameDate(DateTime.now()))
                                .toList();

                        List<DoneAmountActivity> _doneActivitiesInPast =
                            _currentGoal.doneAmountActivities
                                .where((element) =>
                                    DateTime.now()
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

                        TextStyle _labelTextStyle = Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(color: Colors.grey[700]);

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
                                        "Dagens mål",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      LinearPercentIndicator(
                                        barRadius: Radius.circular(20),
                                        percent: _percentForToday,
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
                                  ? "Totalt mål"
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
                                                          date: DateTime.now(),
                                                          amount: amount)),
                                              actionType:
                                                  _currentGoal.actionType,
                                            ))),
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  "Slut: ${DateFormat("DD/MM/yyyy").format(_currentGoal.endDate)} "
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
                                  builder: (context) => AddGoalPage()));
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
  const _GoalMenuOptions({super.key, this.onDelete, this.onEdit});

  final Function()? onDelete;
  final Function()? onEdit;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        itemBuilder: (context) => [
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
