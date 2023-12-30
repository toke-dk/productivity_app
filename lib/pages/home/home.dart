import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:productivity_app/models/task.dart';
import 'package:productivity_app/pages/home/widgets/show_today_overview.dart';
import 'package:productivity_app/pages/new_activity.dart';
import 'package:productivity_app/services/database_service.dart';
import 'package:productivity_app/shared/allActivityTypes.dart';
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

  late List<Activity> completedActivities;

  @override
  void initState() {
    _databaseService.initDatabase();
    print("initialized");
    super.initState();
  }

  Future<List<Activity>> _getActivities() async {
    return _databaseService.getActivities(context);
  }

  Future<void> _onActivityComplete({Activity? activity, Task? task}) async {
    if (activity != null) _databaseService.addActivity(activity);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final List<ActivityType> allActivityTypes = kAllActivityTypes;

    return Scaffold(
        floatingActionButton: AddActivitiesFAB(onActivityComplete: _onActivityComplete,),
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            IconButton(
                onPressed: () {
                  _databaseService.addActivity(Activity(
                      activityType: allActivityTypes[0],
                      chosenUnit: Units.unitLess, amount: 42, dateCompleted: DateTime.now()));
                  setState(() {});
                },
                icon: const Icon(Icons.bar_chart_rounded)),
            IconButton(
                onPressed: () async {
                  final res = await _databaseService.getActivities(context);
                  setState(() {});
                  print(" here: ${res}");
                },
                icon: const Icon(Icons.hail)),
            IconButton(
                onPressed: () async {
                  await _databaseService.deleteAll();
                },
                icon: const Icon(Icons.delete))
          ],
        ),
        body: Column(
          children: [
            FutureBuilder(
              future: _getActivities(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  print(snapshot.data!);
                  return ShowTodayOverview(
                    activities: snapshot.data!,
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            IconButton(
                onPressed: () => setState(() {}),
                icon: const Icon(Icons.refresh))
          ],
        ));
  }
}
