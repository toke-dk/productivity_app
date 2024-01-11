import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:productivity_app/models/activity.dart';
import 'package:productivity_app/models/task.dart';
import 'package:productivity_app/models/unit.dart';
import 'package:productivity_app/services/database_service.dart';
import 'package:productivity_app/widgets/MyThemeButton.dart';
import 'package:productivity_app/widgets/display_activity_type.dart';
import 'package:provider/provider.dart';

class ActivityReceipt extends StatelessWidget {
  ActivityReceipt(
      {super.key, this.activity, required this.onActivityComplete, this.task});

  final Activity? activity;
  final Task? task;

  final Function({Activity? activity, Task? task}) onActivityComplete;

  @override
  Widget build(BuildContext context) {
    final finalTask = Column(
      children: [
        Text(
          task != null ? "Fuldført" : activity!.chosenUnit.textForUnitMeasure,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(
          height: 20,
        ),
        task != null
            ? const Icon(
                Icons.check_circle_outline_rounded,
                size: 100,
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    activity!.activityType.possibleUnits[0].stringName,
                    style: const TextStyle(color: Colors.transparent),
                  ),
                  Text(
                    activity!.amount.toString(),
                    style: const TextStyle(fontSize: 40),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  activity!.activityType.possibleUnits[0] != Units.unitLess
                      ? Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Text(activity!
                              .activityType.possibleUnits[0].stringName))
                      : const SizedBox(),
                ],
              ),
        const SizedBox(
          height: 20,
        ),
      ],
    );

    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 60),
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    width: 200,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              offset: const Offset(5, 5),
                              blurRadius: 11),
                        ],
                        color: Colors.grey[100],
                        borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(20))),
                    child: SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DisplayActivityType(
                              activityType:
                                  task?.activityType ?? activity!.activityType),
                          const SizedBox(
                            height: 20,
                          ),
                          finalTask,
                          Text(
                            "Af",
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Anja A. Hansen",
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Divider(
                              height: 20,
                            ),
                          ),
                          Text(DateFormat("dd-MM-yyyy")
                              .format(DateTime.now())
                              .toString()),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                  )
                      .animate(target: 1)
                      .moveY(
                          begin: -400,
                          duration: 1.5.seconds,
                          curve: Curves.easeOutExpo)
                      .then(),
                ),
              ],
            ),
            const Spacer(),
            MyThemeButton(
              onTap: () {
                if (task != null) {
                  onActivityComplete(task: task);
                } else {
                  onActivityComplete(activity: activity);
                }
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              trailingIcon: Icons.arrow_forward,
              labelText: "Færdiggør",
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
