import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:productivity_app/pages/home/widgets/show_today_overview.dart';
import 'package:productivity_app/pages/new_activity.dart';

import '../../models/activity.dart';
import 'widgets/add_activity_fab.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final activitiesPlaceHolder = [
      Activity(
        amount: 5,
        activityType: kActivityTypes[0],
        chosenUnit: Units.kilometer,
      ),
      Activity(
        amount: 10,
        activityType: kActivityTypes[0],
        chosenUnit: Units.kilometer,
      ),
      Activity(
        amount: 15,
        activityType: kActivityTypes[1],
        chosenUnit: Units.unitLess,
      ),
      Activity(
        amount: 3,
        activityType: kActivityTypes[1],
        chosenUnit: Units.unitLess,
      ),
      Activity(
        amount: 3,
        activityType: kActivityTypes[1],
        chosenUnit: Units.unitLess,
      ),
      Activity(
        amount: 3,
        activityType: kActivityTypes[1],
        chosenUnit: Units.unitLess,
      ),
      Activity(
        amount: 20,
        activityType: kActivityTypes[2],
        chosenUnit: Units.minutes,
      ),
    ];

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
          activities: activitiesPlaceHolder,
        ));
  }
}
