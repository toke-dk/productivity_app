import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:productivity_app/models/unit.dart';
import 'package:productivity_app/shared/extensions/date_time_extensions.dart';
import 'package:productivity_app/widgets/display_activity_type.dart';

import '../../../models/activity.dart';
import '../../../models/task.dart';

class ActionsLog extends StatelessWidget {
  const ActionsLog(
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
      child: tasks.isEmpty && activities.isEmpty
          ? Text("Ingen handlinger endnu")
          : Column(
              children: [
                activities.isNotEmpty ? Text("Akitviteter") : SizedBox(),
                Column(
                  children: List.generate(activities.length, (index) {

                    final Activity currActivity = activities[index];
                    DateTime? previousIndexDateFormatted =
                        index != 0 ? activities[index - 1].dateCompleted : null;
                    DateTime currentIndexDateFormatted =
                        currActivity.dateCompleted;

                    return Column(
                      children: [
                        previousIndexDateFormatted != null &&
                                !previousIndexDateFormatted
                                    .isSameDate(currentIndexDateFormatted)
                            ? Divider()
                            : SizedBox(),
                        Padding(
                          padding: EdgeInsets.only(top: index != 0 ? 12 : 0),
                          child: Row(
                            children: [
                              DisplayActionType(
                                  actionType: currActivity.actionType),
                              Spacer(
                                flex: 3,
                              ),
                              Text(DateFormat("dd.MMM-yy")
                                  .format(currActivity.dateCompleted)
                                  .toString()),
                              Spacer(
                                flex: 1,
                              ),
                              Text(currActivity.amount.toString()),
                              currActivity.chosenUnit.shortStringName != ""
                                  ? Padding(
                                      padding: const EdgeInsets.only(left: 4),
                                      child: Text(currActivity
                                          .chosenUnit.shortStringName),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ),
                tasks.isNotEmpty ? Text("Opgaver") : SizedBox(),
                Column(
                  children: List.generate(tasks.length, (index) {
                    final Task currActivity = tasks[index];
                    DateTime? previousIndexDateFormatted =
                    index != 0 ? tasks[index - 1].dateCompleted : null;
                    DateTime currentIndexDateFormatted =
                        currActivity.dateCompleted;

                    return Column(
                      children: [
                        previousIndexDateFormatted != null &&
                            !previousIndexDateFormatted
                                .isSameDate(currentIndexDateFormatted)
                            ? Divider()
                            : SizedBox(),
                        Padding(
                          padding: EdgeInsets.only(top: index != 0 ? 12 : 0),
                          child: Row(
                            children: [
                              DisplayActionType(
                                  actionType: currActivity.actionType),
                              Spacer(
                                flex: 3,
                              ),
                              Text(DateFormat("dd.MMM-yy")
                                  .format(currActivity.dateCompleted)
                                  .toString()),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
    );
  }
}
