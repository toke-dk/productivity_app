import 'package:animated_digit/animated_digit.dart';
import 'package:flutter/material.dart';
import 'package:productivity_app/pages/home/widgets/show_amount_goal.dart';
import 'package:productivity_app/shared/extensions/date_time_extensions.dart';
import 'package:weekday_selector/weekday_selector.dart';

import '../../../models/goal.dart';
import '../../../widgets/display_activity_type.dart';
import '../../add_activity_amount/add_activity_amount.dart';

List<_AmountGoalItem> generateAmountItems(List<AmountGoal> goals) {
  return goals.map((e) => _AmountGoalItem(amountGoal: e)).toList();
}

List<_CheckmarkGoalItem> generateCheckmarkItems(List<CheckmarkGoal> goals) {
  return goals.map((e) => _CheckmarkGoalItem(checkmarkGoal: e)).toList();
}

class ExpansionListForGoals extends StatefulWidget {
  const ExpansionListForGoals(
      {super.key,
      required this.amountGoals,
      required this.checkmarkGoals,
      required this.currentDay,
      required this.onAmountGoalActivityAdded,
      required this.onAmountActionsLog,
      this.onAmountGoalDelete,
      required this.onCheckmarkGoalDoneDateDelete,
      required this.onCheckMarkGoalDoneDateAdd,
      this.onCheckmarkGoalDelete});

  final List<AmountGoal> amountGoals;
  final List<CheckmarkGoal> checkmarkGoals;
  final DateTime currentDay;
  final Function(AmountGoal, DoneAmountActivity) onAmountGoalActivityAdded;
  final Function(AmountGoal) onAmountActionsLog;
  final Function(AmountGoal)? onAmountGoalDelete;

  final Function(CheckmarkGoal goal, DateTime date)
      onCheckmarkGoalDoneDateDelete;
  final Function(CheckmarkGoal goal, DateTime date) onCheckMarkGoalDoneDateAdd;
  final Function(CheckmarkGoal goal)? onCheckmarkGoalDelete;

  @override
  State<ExpansionListForGoals> createState() => _ExpansionListForGoalsState();
}

class _ExpansionListForGoalsState extends State<ExpansionListForGoals> {
  late List<_AmountGoalItem> _amountGoalItemData;
  late List<_CheckmarkGoalItem> _checkmarkGoalItemData;

  TextStyle get _labelTextStyle => Theme.of(context)
      .textTheme
      .labelMedium!
      .copyWith(color: Colors.grey[700]);

  @override
  void initState() {
    _amountGoalItemData = generateAmountItems(widget.amountGoals);
    _checkmarkGoalItemData = generateCheckmarkItems(widget.checkmarkGoals);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ExpansionListForGoals oldWidget) {
    _amountGoalItemData = generateAmountItems(widget.amountGoals);
    _checkmarkGoalItemData = generateCheckmarkItems(widget.checkmarkGoals);
    super.didUpdateWidget(oldWidget);
  }

  /// TODO: fix so that you cannot press the days before startdate
  List<bool?> makeValuesList(
      List<int> weekdays, DateTime today, DateTime startDate) {
    List<bool?> listIfMondayFirst = List.generate(7, (index) {
      if (today.weekOfYear == startDate.weekOfYear &&
          index + 1 < startDate.weekday) return null;
      return today.weekday >= index + 1 ? weekdays.contains(index + 1) : null;
    });

    List<bool?> weekdaysWhereSundayFirst = [
      listIfMondayFirst.last,
      ...listIfMondayFirst.sublist(0, listIfMondayFirst.length - 1)
    ];

    return weekdaysWhereSundayFirst;
  }

  @override
  Widget build(BuildContext context) {
    print(_amountGoalItemData.length);
    return Column(
      children: [

        /// Making the amount goals first
        Column(
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
                                            builder: (context) =>
                                                AddActivityAmount(
                                                  onComplete: (DoneAmountActivity
                                                          doneAmount) =>
                                                      widget
                                                          .onAmountGoalActivityAdded(
                                                              currentGoal,
                                                              doneAmount),
                                                  actionType:
                                                      currentGoal.actionType,
                                                  date: widget.currentDay,
                                                  goalEndDate:
                                                      currentGoal.endDate,
                                                  goalStartDate:
                                                      currentGoal.startDate,
                                                )))
                                    : null,
                              ),
                              GoalMenuOptions(
                                onLogPress: () =>
                                    widget.onAmountActionsLog(currentGoal),
                                onDelete: () => widget.onAmountGoalDelete !=
                                        null
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
        }).toList()),

        /// Then making the checkmark goals
        Column(
            children: _checkmarkGoalItemData.map((indexGoal) {
          CheckmarkGoal currentGoal = indexGoal.checkmarkGoal;
          return Column(
            children: [
              ExpansionPanelList(
                  expansionCallback: (_, bool) {
                    setState(() {
                      indexGoal.isExpanded = bool;
                    });
                  },
                  elevation: 2,
                  children: [
                    ExpansionPanel(
                      isExpanded: indexGoal.isExpanded,
                      headerBuilder: (context, isOpen) {
                        return Container(
                          padding: EdgeInsets.all(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DisplayActionType(
                                actionType: currentGoal.actionType,
                                mainAxisAlignment: MainAxisAlignment.start,
                              ),
                              currentGoal.isDateDone(widget.currentDay)
                                  ? FilledButton(
                                      onPressed: widget.currentDay.isToday
                                          ? () => widget
                                              .onCheckmarkGoalDoneDateDelete(
                                                  currentGoal,
                                                  widget.currentDay)
                                          : null,
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
                                      onPressed: widget.currentDay.isToday
                                          ? () =>
                                              widget.onCheckMarkGoalDoneDateAdd(
                                                  currentGoal,
                                                  widget.currentDay)
                                          : null,
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
                              GoalMenuOptions(
                                onDelete: () => widget.onCheckmarkGoalDelete !=
                                        null
                                    ? widget.onCheckmarkGoalDelete!(currentGoal)
                                    : null,
                                onLogPress: () => debugPrint("Show logs"),
                              )
                            ],
                          ),
                        );
                      },
                      body: Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Ugens mål (${currentGoal.daysPerWeek})",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                )),
                            WeekdaySelector(
                              onChanged: (newDate) {
                                DateTime dateToAdd = widget.currentDay
                                    .subtract(Duration(
                                        days: widget.currentDay.weekday -
                                            newDate))
                                    .onlyYearMonthDay;

                                !currentGoal.doneDates.contains(dateToAdd)
                                    ? widget.onCheckMarkGoalDoneDateAdd(
                                        currentGoal, dateToAdd)
                                    : widget.onCheckmarkGoalDoneDateDelete(
                                        currentGoal, dateToAdd);
                              },
                              values: makeValuesList(
                                  currentGoal.doneDaysOfWeekFromWeekNr(
                                      widget.currentDay.weekOfYear),
                                  widget.currentDay,
                                  currentGoal.startDate),
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
                                          widget.currentDay.weekOfYear)
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
                      ),
                    ),
                  ]),
              Divider(
                height: 0,
              )
            ],
          );
        }).toList()),
      ],
    );
  }
}

class _AmountGoalItem {
  AmountGoal amountGoal;
  bool isExpanded;

  _AmountGoalItem({required this.amountGoal, this.isExpanded = false});
}

class _CheckmarkGoalItem {
  CheckmarkGoal checkmarkGoal;
  bool isExpanded;

  _CheckmarkGoalItem({required this.checkmarkGoal, this.isExpanded = false});
}

class GoalMenuOptions extends StatelessWidget {
  const GoalMenuOptions({this.onDelete, this.onLogPress, this.onEdit});

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
