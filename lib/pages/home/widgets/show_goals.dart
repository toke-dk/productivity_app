import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:productivity_app/pages/add_goal/add_goal_page.dart';
import 'package:productivity_app/widgets/MyThemeButton.dart';
import 'package:productivity_app/widgets/display_activity_type.dart';

import '../../../models/goal.dart';

class ShowGoalsWidget extends StatelessWidget {
  const ShowGoalsWidget(
      {super.key, required this.amountGoals, required this.checkmarkGoals});

  final List<AmountGoal> amountGoals;
  final List<CheckmarkGoal> checkmarkGoals;

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
                    AmountGoal currentGoal = amountGoals[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DisplayActionType(
                          actionType: currentGoal.actionType,
                          axisDirection: Axis.horizontal,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          currentGoal.frequencyFormat ==
                                  GoalFrequencyFormats.inTotal
                              ? "Totalt mål"
                              : currentGoal.frequencyFormat ==
                                      GoalFrequencyFormats.perWeek
                                  ? "Dagens mål"
                                  : currentGoal.frequencyFormat ==
                                          GoalFrequencyFormats.perDay
                                      ? "Dagens mål"
                                      : "FEJL!!",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        SizedBox(height: 10,),
                        LinearPercentIndicator(
                          barRadius: Radius.circular(20),
                          percent: 0.4,
                          progressColor: Theme.of(context).colorScheme.primary,
                          lineHeight: 15,
                          animation: true,
                          animationDuration: 1000,
                          leading: Text("40%"),
                        )
                      ],
                    );
                  }),
                ),
              ],
            ),
    );
  }
}
