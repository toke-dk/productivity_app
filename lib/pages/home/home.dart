import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:productivity_app/pages/home/widgets/show_today_overview.dart';
import 'package:productivity_app/pages/new_activity.dart';
import 'package:productivity_app/services/database_service.dart';
import 'package:provider/provider.dart';

import '../../models/activity.dart';
import '../../models/unit.dart';
import 'widgets/add_activity_fab.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DataBaseService _databaseService = DataBaseService();

  @override
  void initState() {
    _databaseService.initDatabase();
    print("initialized");
    super.initState();
  }

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
          title: Text(widget.title),
          actions: [
            IconButton(
                onPressed: () {
                  _databaseService.addActivity(Activity(
                      activityType: allActivityTypes[0],
                      chosenUnit: Units.unitLess));
                },
                icon: const Icon(Icons.bar_chart_rounded)),
            IconButton(
                onPressed: () async {
                  final res =
                      await _databaseService.getActivities(context);
                  print(" here: ${res}");
                },
                icon: Icon(Icons.hail)),
            IconButton(
                onPressed: () async {
                  await _databaseService.deleteAll();
                },
                icon: Icon(Icons.delete))
          ],
        ),
        body: ShowTodayOverview(
          activities: completedActivities,
        ));
  }
}
