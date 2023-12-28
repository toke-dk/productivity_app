import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:productivity_app/pages/home/widgets/show_today_overview.dart';
import 'package:productivity_app/pages/new_activity.dart';
import 'package:provider/provider.dart';

import '../../models/activity.dart';
import '../../models/unit.dart';
import 'widgets/add_activity_fab.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final List<ActivityType> allActivityTypes =
        Provider.of<ActivityProvider>(context).getAllActivityTypes;

    final activitiesPlaceHolder = [
      Activity(
        amount: 5,
        activityType: allActivityTypes[0],
        chosenUnit: Units.kilometer,
      ),
      Activity(
        amount: 10,
        activityType: allActivityTypes[0],
        chosenUnit: Units.kilometer,
      ),
      Activity(
        amount: 15,
        activityType: allActivityTypes[1],
        chosenUnit: Units.unitLess,
      ),
      Activity(
        amount: 3,
        activityType: allActivityTypes[1],
        chosenUnit: Units.unitLess,
      ),
      Activity(
        amount: 3,
        activityType: allActivityTypes[1],
        chosenUnit: Units.unitLess,
      ),
      Activity(
        amount: 3,
        activityType: allActivityTypes[1],
        chosenUnit: Units.unitLess,
      ),
      Activity(
        amount: 20,
        activityType: allActivityTypes[2],
        chosenUnit: Units.minutes,
      ),
    ];

    final completedActivities =
        Provider.of<ActivityProvider>(context).getAllActivities;

    return Scaffold(
        floatingActionButton: const AddActivitiesFAB(),
        appBar: AppBar(
          title: Text(title),
          actions: [
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.bar_chart_rounded))
          ],
        ),
        body: ShowTodayOverview(
          activities: completedActivities,
        ));
  }
}
