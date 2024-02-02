import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:productivity_app/models/unit.dart';
import 'package:productivity_app/shared/extensions/double_extension.dart';

import '../models/goal.dart';

class ActionsLogPage extends StatelessWidget {
  const ActionsLogPage({super.key, required this.goal});

  final AmountGoal goal;

  Map<DateTime, List<DoneAmountActivity>> get groupedAmountByDate =>
      goal.doneAmountActivities.groupDoneAmountByDate;

  @override
  Widget build(BuildContext context) {
    print(goal.doneAmountActivities.groupDoneAmountByDate);
    return Scaffold(
      appBar: AppBar(title: Text("Logbog")),
      body: SingleChildScrollView(
        child: Column(
            children: groupedAmountByDate.entries.map((e) {

          /// Each grouped date
          List<DoneAmountActivity> _currentActivitiesForDate = e.value;
          DateTime _currentDate = e.key;
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ShowDateLabel(date: _currentDate),
                  Expanded(
                    child: Column(
                      children: List.generate(_currentActivitiesForDate.length,
                          (index) {
                    
                        /// Each date
                        DoneAmountActivity _currentActivity =
                            _currentActivitiesForDate[index];
                        return Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${_currentActivity.amount.myDoubleToString} ${goal.chosenUnit.shortStringName}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
                                        ),
                                        Divider(),
                                        Text(
                                          "Total",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                "${goal.doneActivitiesBeforeDate(_currentActivity.date).totalAmountDone.myDoubleToString}/${goal.amountGoal.myDoubleToString}"),
                                            Text(
                                                "${(goal.percentOfTotalAmountFromDate(_currentActivity.date) * 100).myDoubleToString}%")
                                          ],
                                        ),
                                        Divider(),
                                        Text(
                                          'kl. ${DateFormat("HH:mm").format(_currentActivity.date)}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium,
                                        )
                                      ],
                                    ),
                                  ),
                                  PopupMenuButton(
                                      itemBuilder: (context) =>
                                          [PopupMenuItem(child: Text("Edit"))]),
                                ],
                              ),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey[100]),
                            ),
                            SizedBox(
                              height: 5,
                            )
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              )
            ],
          );
        }).toList()),
      ),
    );
  }
}

class _ShowDateLabel extends StatelessWidget {
  const _ShowDateLabel({super.key, required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(DateFormat("EEE").format(date)),
        CircleAvatar(
          child: Text(DateFormat("dd").format(date)),
        ),
        Text(DateFormat("MMM").format(date)),
      ],
    );
  }
}
