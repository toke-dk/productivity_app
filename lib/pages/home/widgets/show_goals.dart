import 'package:animated_digit/animated_digit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:productivity_app/models/unit.dart';
import 'package:productivity_app/pages/add_activity_amount/add_activity_amount.dart';
import 'package:productivity_app/pages/add_goal/add_goal_page.dart';
import 'package:productivity_app/pages/home/widgets/show_amount_goals.dart';
import 'package:productivity_app/shared/extensions/date_time_extensions.dart';
import 'package:productivity_app/shared/extensions/double_extension.dart';
import 'package:productivity_app/shared/extensions/gaol_extensions.dart';
import 'package:productivity_app/widgets/display_activity_type.dart';
import 'package:weekday_selector/weekday_selector.dart';

import '../../../models/goal.dart';

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

  DateTime get _currentDay => DateTime.now();

  late List<bool> _expandedCheckmarkGoals;

  late List<bool> _expandedAmountGoals;

  @override
  void initState() {
    _expandedCheckmarkGoals =
        List.generate(activeCheckmarkGoalsSelectedDay.length, (index) => false);
    _expandedAmountGoals =
        List.generate(activeAmountGoalsSelectedDay.length, (index) => false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle _labelTextStyle = Theme.of(context)
        .textTheme
        .labelMedium!
        .copyWith(color: Colors.grey[700]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Center(
        //   child: _DayChanger(
        //     date: _currentDay,
        //     onPrevDate: (old) => setState(() {
        //       _currentDay = _currentDay.subtract(Duration(days: 1));
        //       print(_currentDay);
        //     }),
        //     onNextDate:
        //         _currentDay.onlyYearMonthDay != DateTime.now().onlyYearMonthDay
        //             ? (old) {
        //                 setState(() {
        //                   _currentDay = _currentDay.add(Duration(days: 1));
        //                   print(_currentDay);
        //                 });
        //               }
        //             : null,
        //   ),
        // ),
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
            : ExpansionPanelList(
                expansionCallback: (int, bool) {
                  setState(() {
                    _expandedCheckmarkGoals[int] = bool;
                  });
                },
                elevation: 2,
                children: List.generate(activeCheckmarkGoalsSelectedDay.length,
                    (index) {
                  CheckmarkGoal currentGoal =
                      activeCheckmarkGoalsSelectedDay[index];
                  return ExpansionPanel(
                    isExpanded: _expandedCheckmarkGoals[index],
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
                            currentGoal.isDateDone(_currentDay)
                                ? FilledButton(
                                    onPressed: _currentDay.isToday
                                        ? () => widget
                                            .onCheckmarkGoalDoneDateDelete(
                                                currentGoal, _currentDay)
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
                                    onPressed: _currentDay.isToday
                                        ? () =>
                                            widget.onCheckMarkGoalDoneDateAdd(
                                                currentGoal, _currentDay)
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
                              DateTime dateToAdd = _currentDay
                                  .subtract(Duration(
                                      days: _currentDay.weekday - newDate))
                                  .onlyYearMonthDay;

                              !currentGoal.doneDates.contains(dateToAdd)
                                  ? widget.onCheckMarkGoalDoneDateAdd(
                                      currentGoal, dateToAdd)
                                  : widget.onCheckmarkGoalDoneDateDelete(
                                      currentGoal, dateToAdd);
                            },
                            values: makeValuesList(
                                currentGoal.doneDaysOfWeekFromWeekNr(
                                    _currentDay.weekOfYear),
                                _currentDay,
                                currentGoal.startDate),
                            elevation: 0,
                            shortWeekdays: ["S", "M", "T", "O", "T", "F", "L"],
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
                    ),
                  );
                })),
        Divider(
          height: 0,
        ),
        Column(
            children:
                List.generate(activeAmountGoalsSelectedDay.length, (index) {
          AmountGoal currentGoal = activeAmountGoalsSelectedDay[index];
          return Column(
            children: [
              ExpansionPanelList(
                expansionCallback: (_, bool) {
                  setState(() {
                    _expandedAmountGoals[index] = bool;
                  });
                },
                children: [
                  ExpansionPanel(
                      isExpanded: _expandedAmountGoals[index],
                      headerBuilder: (context, bool) {
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
                                onPressed: _currentDay.isToday
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
                                                  date: _currentDay,
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
                        child: ShowAmountGoals(
                          goals: activeAmountGoalsSelectedDay,
                          currentDay: _currentDay,
                          onAmountGoalActivityAdded:
                              widget.onAmountGoalActivityAdded,
                          onAmountActionsLog: widget.onAmountActionsLog,
                          onAmountGoalDelete: widget.onAmountGoalDelete,
                        ),
                      )),
                ],
              ),
              Divider(height: 0,),
            ],
          );
        })),
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
              // PopupMenuItem(
              //   onTap: onEdit,
              //   child: ListTile(
              //     leading: Icon(Icons.edit),
              //     title: Text("Rediger"),
              //   ),
              // ),
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
