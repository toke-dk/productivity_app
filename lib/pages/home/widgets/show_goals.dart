import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:productivity_app/models/unit.dart';
import 'package:productivity_app/pages/add_activity_amount/add_activity_amount.dart';
import 'package:productivity_app/pages/add_goal/add_goal_page.dart';
import 'package:productivity_app/shared/extensions/date_time_extension.dart';
import 'package:productivity_app/widgets/MyThemeButton.dart';
import 'package:productivity_app/widgets/display_activity_type.dart';

import '../../../models/goal.dart';

class ShowGoalsWidget extends StatelessWidget {
  const ShowGoalsWidget(
      {super.key,
      required this.amountGoals,
      required this.checkmarkGoals,
      required this.onAmountGoalActivityAdded});

  final List<AmountGoal> amountGoals;
  final List<CheckmarkGoal> checkmarkGoals;
  final Function(AmountGoal goal, DoneAmountActivity activity)
      onAmountGoalActivityAdded;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.grey[100]),
      child: amountGoals.isEmpty && checkmarkGoals.isEmpty
          ? Column(
              children: [
                Text("Du har ikke sat et mål endnu"),
                SizedBox(
                  height: 20,
                ),
                MyThemeButton(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddGoalPage()));
                  },
                  labelText: "Angiv mål!",
                )
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: List.generate(checkmarkGoals.length, (index) {
                    CheckmarkGoal currentGoal = checkmarkGoals[index];
                    return Column(
                      children: [Text(currentGoal.actionType.name)],
                    );
                  }),
                ),
                Column(
                  children: List.generate(amountGoals.length, (index) {
                    AmountGoal _currentGoal = amountGoals[index];
                    double _amountDone =
                        _currentGoal.doneAmountActivities.totalAmountDone;
                    double _percent = _amountDone / _currentGoal.amountGoal;

                    List<DoneAmountActivity> _doneActivitiesToday = _currentGoal
                        .doneAmountActivities
                        .where((element) =>
                            element.date.isSameDate(DateTime.now()))
                        .toList();

                    List<DoneAmountActivity> _doneActivitiesInPast =
                        _currentGoal.doneAmountActivities
                            .where((element) =>
                                DateTime.now().difference(element.date).inDays >
                                0)
                            .toList();

                    double _goalForToday = (_currentGoal.amountGoal -
                            _doneActivitiesInPast.totalAmountDone) /
                        (_currentGoal.daysUntilEndDateFromNow + 1);
                    double _percentForToday =
                        _doneActivitiesToday.totalAmountDone / _goalForToday;

                    double _amountLeftToday =
                        _goalForToday - _doneActivitiesToday.totalAmountDone;

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
                        DisplayActionType(
                          mainAxisAlignment: MainAxisAlignment.start,
                          actionType: _currentGoal.actionType,
                          axisDirection: Axis.horizontal,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        _currentGoal.frequencyFormat ==
                                GoalFrequencyFormats.inTotal
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Dagens mål",
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  LinearPercentIndicator(
                                    barRadius: Radius.circular(20),
                                    percent: _percentForToday,
                                    progressColor:
                                        Theme.of(context).colorScheme.primary,
                                    lineHeight: 8,
                                    animation: true,
                                    animationDuration: 1000,
                                    leading: Text(
                                        "${(_percentForToday * 100).toStringAsFixed(_percentForToday * 100 % 1 == 0 ? 0 : 1)}%"),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          "${_amountLeftToday.toStringAsFixed(_amountLeftToday % 1 == 0 ? 0 : 1)} $_displayUnitString tilbage"),
                                      Text(
                                        "${_doneActivitiesToday.totalAmountDone.toStringAsFixed(_doneActivitiesToday.totalAmountDone % 1 == 0 ? 0 : 1)}"
                                        "/${_goalForToday.toStringAsFixed(_goalForToday % 1 == 0 ? 0 : 1)} $_displayUnitString",
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
                          progressColor: Theme.of(context).colorScheme.primary,
                          lineHeight: 15,
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
                                          actionType: _currentGoal.actionType,
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

                            /// TODO: should display how many amounts are left
                            Text(
                              "${_amountDone.toStringAsFixed(_amountDone % 1 == 0 ? 0 : 1)} / ${_currentGoal.amountGoal.toStringAsFixed(_currentGoal.amountGoal % 1 == 0 ? 0 : 1)} $_displayUnitString ",
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
                      ],
                    );
                  }),
                ),
                Divider(
                  height: 60,
                  thickness: 2,
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
    );
  }
}
