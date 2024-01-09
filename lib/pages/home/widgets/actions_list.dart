import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:productivity_app/models/unit.dart';
import 'package:productivity_app/widgets/display_activity_type.dart';

import '../../../models/activity.dart';
import '../../../models/task.dart';

class ActionsList extends StatelessWidget {
  const ActionsList(
      {super.key, this.activities = const [], this.tasks = const []});

  final List<Activity> activities;
  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.grey[100]),
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Text("Akitviteter"),
          Column(
            children: List.generate(activities.length, (index) {
              final Activity currActivity = activities[index];
              return Padding(
                padding: EdgeInsets.only(top: index != 0 ? 12 : 0),
                child: Row(
                  children: [
                    DisplayActivityType(activityType: currActivity.activityType),
                    Spacer(flex: 3,),
                    Text(DateFormat("dd.MMM-yy").format(currActivity.dateCompleted).toString()),
                    Spacer(flex: 1,),
                    Text(currActivity.amount.toString()),
                    currActivity.chosenUnit.stringName != ""
                        ? Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(currActivity.chosenUnit.stringName),
                        )
                        : const SizedBox(),
                  ],
                ),
              );
            }),
          ),
          Text("Opgaver"),
          Column(
            children: List.generate(tasks.length, (index) {
              final Task currActivity = tasks[index];
              return Padding(
                padding: EdgeInsets.only(top: index != 0 ? 12 : 0),
                child: Row(
                  children: [
                    DisplayActivityType(activityType: currActivity.activityType),
                    Spacer(flex: 3,),
                    Text(DateFormat("dd.MMM-yy").format(currActivity.dateCompleted).toString()),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
