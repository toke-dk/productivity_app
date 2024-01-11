import 'package:flutter/material.dart';
import 'package:productivity_app/models/activity.dart';
import 'package:productivity_app/models/task.dart';
import 'package:productivity_app/pages/add_activity_amount/add_activity_amount.dart';
import 'package:productivity_app/shared/widgets/activity_card.dart';
import 'package:productivity_app/pages/choose_activity/widgets/search_appbar.dart';
import 'package:productivity_app/pages/complete_task_page.dart';
import 'package:productivity_app/shared/allActivityTypes.dart';
import 'package:provider/provider.dart';

class ChooseActivityScreen extends StatelessWidget {
  const ChooseActivityScreen(
      {super.key, required this.isTask, required this.onActivityComplete});

  final Function({Activity? activity, Task? task}) onActivityComplete;

  final bool isTask;
  final double horizontalPadding = 15;

  void setCurrentActivityType(ActivityType activityType, BuildContext context) {
    Provider.of<ActivityProvider>(context, listen: false)
        .setCurrentActivity(activityType);
  }

  Future onActivityTypeTap(
      {required ActivityType activityType, required BuildContext context}) {
    setCurrentActivityType(activityType, context);

    return Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => isTask
                ? CompleteTaskPage(
                    onActivityComplete: onActivityComplete,
                  )
                : AddActivityAmount(
                    onActivityComplete: onActivityComplete,
                  )));
  }

  @override
  Widget build(BuildContext context) {
    final List<ActivityType> allActivityTypes = kAllActivityTypes;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const MySearchAppBar(),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Padding(
                  //   padding:
                  //       EdgeInsets.symmetric(horizontal: horizontalPadding),
                  //   child: const Text("Anbefalet"),
                  // ),
                  // ActivityTypesGridView(
                  //     maxRows: 1,
                  //     activityTypes: allActivityTypes,
                  //     onTap: (ActivityType activityType) => onActivityTypeTap(
                  //         activityType: activityType, context: context)),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: const Text("Alle"),
                  ),
                  ActivityTypesGridView(
                      activityTypes: isTask
                          ? allActivityTypes
                              .where((element) => element.asTask)
                              .toList()
                          : allActivityTypes
                              .where((element) => element.asActivity)
                              .toList(),
                      onTap: (ActivityType activityType) => onActivityTypeTap(
                          activityType: activityType, context: context)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ActivityTypesGridView extends StatelessWidget {
  const ActivityTypesGridView(
      {super.key,
      required this.activityTypes,
      this.maxRows,
      required this.onTap});

  final List<ActivityType> activityTypes;
  final int? maxRows;
  final Function(ActivityType activityType) onTap;

  @override
  Widget build(BuildContext context) {
    int crossCount = 3;
    int listLength = activityTypes.length;
    int amountOfGenerates =
        maxRows == null || (listLength / crossCount).ceil() < maxRows!
            ? listLength
            : 3 * maxRows!;

    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 30,
      mainAxisSpacing: 30,
      children: List.generate(
          amountOfGenerates,
          (index) => ActivityCard(
                activityType: activityTypes[index],
                onTap: (ActivityType activityType) =>
                    onTap(activityTypes[index]),
              )),
    );
  }
}
