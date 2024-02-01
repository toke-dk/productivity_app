import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:productivity_app/models/unit.dart';
import 'package:productivity_app/shared/extensions/double_extension.dart';

import '../models/goal.dart';

class ActionsLogPage extends StatelessWidget {
  const ActionsLogPage({super.key, required this.goal});

  final AmountGoal goal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Logbog")),
      body: SingleChildScrollView(
        child: Column(
          children: List.generate(goal.doneAmountActivities.length, (index) {
            DoneAmountActivity _currentActivity =
                goal.doneAmountActivities[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Text(DateFormat("EEE").format(_currentActivity.date)),
                          CircleAvatar(
                            child: Text(
                                DateFormat("dd").format(_currentActivity.date)),
                          ),
                          Text(DateFormat("MMM").format(_currentActivity.date)),
                        ],
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${_currentActivity.amount.myDoubleToString} ${goal.chosenUnit.shortStringName}",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Divider(),
                            Text("Total",style: Theme.of(context).textTheme.titleMedium,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    "${goal.doneActivitiesBeforeDate(_currentActivity.date).totalAmountDone.myDoubleToString}/${goal.amountGoal.myDoubleToString}"),
                                Text("${(goal.percentOfTotalAmountFromDate(_currentActivity.date)*100).myDoubleToString}%")
                              ],
                            ),
                            Divider(),
                            Text(
                              'kl. ${DateFormat("HH:mm").format(_currentActivity.date)}',
                              style: Theme.of(context).textTheme.labelMedium,
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
    );
  }
}
