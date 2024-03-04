import 'package:flutter/material.dart';
import 'package:productivity_app/pages/add_goal/add_goal_page.dart';
import 'package:productivity_app/shared/extensions/gaol_extensions.dart';

import '../../../models/goal.dart';
import 'expansion_list_amountgoal.dart';

class ShowGoalsWidget extends StatefulWidget {
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

  @override
  State<ShowGoalsWidget> createState() => _ShowGoalsWidgetState();
}

class _ShowGoalsWidgetState extends State<ShowGoalsWidget> {
  List<AmountGoal> get activeAmountGoalsSelectedDay =>
      widget.amountGoals.activeGoalsFromDate(_currentDay);

  List<CheckmarkGoal> get activeCheckmarkGoalsSelectedDay =>
      widget.checkmarkGoals.activeGoalsFromDate(_currentDay);

  DateTime get _currentDay => DateTime.now();

  late List<bool> _expandedCheckmarkGoals;

  late List<bool> _expandedAmountGoals;

  @override
  void initState() {
    print("h");
    _expandedCheckmarkGoals =
        List.generate(activeCheckmarkGoalsSelectedDay.length, (index) => false);
    print(activeCheckmarkGoalsSelectedDay.length);
    _expandedAmountGoals =
        List.generate(activeAmountGoalsSelectedDay.length, (index) => false);

    print("initstate");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        activeAmountGoalsSelectedDay.isNotEmpty ||
                activeCheckmarkGoalsSelectedDay.isNotEmpty
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
                                        onCheckMarkGoalAdd:
                                            (CheckmarkGoal checkmarkGoal) =>
                                                widget.onCheckMarkGoalAdd(
                                                    checkmarkGoal),
                                        onAmountGoalAdd:
                                            (AmountGoal amountGoal) => widget
                                                .onAmountGoalAdd(amountGoal),
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
        activeAmountGoalsSelectedDay.isEmpty &&
                activeCheckmarkGoalsSelectedDay.isEmpty
            ? Center(
                child: Column(
                  children: [
                    Text("Du har ikke sat et mål endnu"),
                    SizedBox(
                      height: 20,
                    ),
                    FilledButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddGoalPage(
                                      onCheckMarkGoalAdd:
                                          (CheckmarkGoal checkmarkGoal) =>
                                              widget.onCheckMarkGoalAdd(
                                                  checkmarkGoal),
                                      onAmountGoalAdd: (AmountGoal goal) =>
                                          widget.onAmountGoalAdd(goal),
                                    )));
                      },
                      child: Text("Angiv mål!"),
                    ),
                  ],
                ),
              )
            : SizedBox(),

        ExpansionListForGoals(
          amountGoals: activeAmountGoalsSelectedDay,
          checkmarkGoals: activeCheckmarkGoalsSelectedDay,
          currentDay: _currentDay,
          onAmountGoalActivityAdded: widget.onAmountGoalActivityAdded,
          onAmountActionsLog: widget.onAmountActionsLog,
          onCheckmarkGoalDelete: widget.onCheckmarkGoalDelete,
          onAmountGoalDelete: widget.onAmountGoalDelete,
          onCheckmarkGoalDoneDateDelete: widget.onCheckmarkGoalDoneDateDelete,
          onCheckMarkGoalDoneDateAdd: widget.onCheckMarkGoalDoneDateAdd,
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
                      "Se alle (${widget.checkmarkGoals.previousGoalsFromToday.length + widget.amountGoals.previousGoalsFromToday.length})"),
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
                      "Se alle (${widget.checkmarkGoals.futureGoalsFromToday.length + widget.amountGoals.futureGoalsFromToday.length})"),
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
