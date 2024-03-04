import 'package:flutter/material.dart';
import 'package:productivity_app/pages/home/widgets/show_amount_goal.dart';
import 'package:productivity_app/pages/home/widgets/show_goals.dart';
import 'package:productivity_app/shared/extensions/date_time_extensions.dart';

import '../../../models/goal.dart';
import '../../../widgets/display_activity_type.dart';
import '../../add_activity_amount/add_activity_amount.dart';

List<_AmountGoalItem> generateAmountItems(List<AmountGoal> goals) {
  return goals.map((e) => _AmountGoalItem(amountGoal: e)).toList();
}

class ExpansionListForGoals extends StatefulWidget {
  const ExpansionListForGoals(
      {super.key,
        required this.amountGoals,
        required this.checkmarkGoals,
        required this.currentDay,
        required this.onAmountGoalActivityAdded,
        required this.onAmountActionsLog,
        this.onAmountGoalDelete});

  final List<AmountGoal> amountGoals;
  final List<CheckmarkGoal> checkmarkGoals;
  final DateTime currentDay;
  final Function(AmountGoal, DoneAmountActivity) onAmountGoalActivityAdded;
  final Function(AmountGoal) onAmountActionsLog;
  final Function(AmountGoal)? onAmountGoalDelete;

  @override
  State<ExpansionListForGoals> createState() => _ExpansionListForGoalsState();
}

class _ExpansionListForGoalsState extends State<ExpansionListForGoals> {
  late List<_AmountGoalItem> _amountGoalItemData;

  @override
  void initState() {
    _amountGoalItemData = generateAmountItems(widget.amountGoals);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ExpansionListForGoals oldWidget) {
    _amountGoalItemData = generateAmountItems(widget.amountGoals);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    print(_amountGoalItemData.length);
    return Column(
        children: _amountGoalItemData.map((indexGoal) {
          AmountGoal currentGoal = indexGoal.amountGoal;
          return Column(
            children: [
              ExpansionPanelList(
                expansionCallback: (_, bool) {
                  print(indexGoal.isExpanded);
                  setState(() {
                    indexGoal.isExpanded = bool;
                  });
                  print(indexGoal.isExpanded);
                },
                children: [
                  ExpansionPanel(
                      isExpanded: indexGoal.isExpanded,
                      headerBuilder: (context, _) {
                        return Container(
                          padding: EdgeInsets.all(12),
                          child: Row(
                            children: [
                              DisplayActionType(
                                mainAxisAlignment: MainAxisAlignment.start,
                                actionType: currentGoal.actionType,
                                axisDirection: Axis.horizontal,
                              ),
                              Spacer(),
                              TextButton.icon(
                                label: Text("Tilføj"),
                                icon: Icon(
                                  Icons.add_circle_outlined,
                                  size: 25,
                                ),
                                onPressed: widget.currentDay.isToday
                                    ? () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddActivityAmount(
                                          onComplete: (DoneAmountActivity
                                          doneAmount) =>
                                              widget
                                                  .onAmountGoalActivityAdded(
                                                  currentGoal,
                                                  doneAmount),
                                          actionType:
                                          currentGoal.actionType,
                                          date: widget.currentDay,
                                          goalEndDate: currentGoal.endDate,
                                          goalStartDate:
                                          currentGoal.startDate,
                                        )))
                                    : null,
                              ),
                              GoalMenuOptions(
                                onLogPress: () =>
                                    widget.onAmountActionsLog(currentGoal),
                                onDelete: () => widget.onAmountGoalDelete != null
                                    ? widget.onAmountGoalDelete!(currentGoal)
                                    : null,
                              ),
                            ],
                          ),
                        );
                      },
                      body: Container(
                        padding: EdgeInsets.all(20),
                        child: ShowAmountGoal(
                          goal: indexGoal.amountGoal,
                          currentDay: widget.currentDay,
                          onAmountGoalActivityAdded:
                          widget.onAmountGoalActivityAdded,
                          onAmountActionsLog: widget.onAmountActionsLog,
                          onAmountGoalDelete: widget.onAmountGoalDelete,
                        ),
                      )),
                ],
              ),
              Divider(
                height: 0,
              ),
            ],
          );
        }).toList());
  }
}

class _AmountGoalItem {
  AmountGoal amountGoal;
  bool isExpanded;

  _AmountGoalItem({required this.amountGoal, this.isExpanded = false});
}