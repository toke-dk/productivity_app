import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:productivity_app/models/unit.dart';
import 'package:productivity_app/pages/add_activity_amount/add_activity_amount.dart';
import 'package:productivity_app/pages/add_goal/add_goal_page.dart';
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
                    double _percent = (_amountDone / _currentGoal.amountGoal);

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
                        Text(
                          _currentGoal.frequencyFormat ==
                                  GoalFrequencyFormats.inTotal
                              ? "Totalt mål"
                              : _currentGoal.frequencyFormat ==
                                      GoalFrequencyFormats.perWeek
                                  ? "Dagens mål"
                                  : _currentGoal.frequencyFormat ==
                                          GoalFrequencyFormats.perDay
                                      ? "Dagens mål"
                                      : "FEJL!!",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        SizedBox(
                          height: 10,
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
                              "(${_currentGoal.endDate.difference(_currentGoal.startDate).inDays} d)",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(color: Colors.grey[700]),
                            ),
                            Text(
                              "${_amountDone.toStringAsFixed(_amountDone % 1 == 0 ? 0 : 1)} / ${_currentGoal.amountGoal.toStringAsFixed(_currentGoal.amountGoal % 1 == 0 ? 0 : 1)} ${_currentGoal.chosenUnit != Units.unitLess ? _currentGoal.chosenUnit.shortStringName : 'gange'} ",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(color: Colors.grey[700]),
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
