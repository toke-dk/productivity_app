import 'package:flutter/material.dart';
import 'package:productivity_app/models/task.dart';
import 'package:productivity_app/pages/home/widgets/actions_list.dart';
import 'package:productivity_app/pages/home/widgets/show_today_overview.dart';
import 'package:productivity_app/services/database_service.dart';
import 'package:productivity_app/shared/allActionTypes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' as Foundation;

import '../../models/activity.dart';
import '../../models/unit.dart';
import 'widgets/add_activity_fab.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DataBaseService _databaseService = DataBaseService();

  late List<Activity> completedActivities;

  @override
  void initState() {
    print("init");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _databaseService.initDatabase();
      setState(() {});
    });
    super.initState();
  }

  Future<List<Activity>> _getActivities() async {
    return _databaseService.getActivities();
  }

  Future<List<Task>> _getTasks() async {
    return _databaseService.getTasks();
  }

  Future<void> _onActivityComplete({Activity? activity, Task? task}) async {
    if (activity != null) {
      _databaseService.addActivity(activity);
    } else if (task != null) {
      _databaseService.addTask(task);
    }
    setState(() {});
  }

  launchFeedBackForm() async {
    final Uri feedbackUrl = Uri.parse(
        "https://docs.google.com/forms/d/e/1FAIpQLSehUorGGbMuzEKFkIiPL3srDSerNT2EpNyOtY1X1v3qBh6L_w/viewform");
    if (!await launchUrl(feedbackUrl)) {
      throw Exception("Could not launch $feedbackUrl");
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<ActionType> allActionTypes = kAllActionTypes;

    return Scaffold(
        floatingActionButton: AddActivitiesFAB(
          onActivityComplete: _onActivityComplete,
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(child: Text("Menu")),
              ListTile(
                title: Text("Feedback"),
                onTap: launchFeedBackForm,
                leading: Icon(Icons.open_in_new),
              )
            ],
          ),
        ),
        appBar: AppBar(title: Text(widget.title), actions: [
          Foundation.kDebugMode
              ? IconButton(
                  onPressed: () async {
                    await _databaseService.addActivity(Activity(
                        amount: 42,
                        actionType: kAllActionTypes[0],
                        chosenUnit: Units.kilometer,
                        dateCompleted: DateTime.now()));
                    setState(() {});
                  },
                  icon: const Icon(Icons.add_task))
              : SizedBox(),
          Foundation.kDebugMode
              ? IconButton(
                  onPressed: () async {
                    await _databaseService.deleteAllActivities();
                    await _databaseService.deleteAllTasks();
                    setState(() {});
                  },
                  icon: const Icon(Icons.delete))
              : SizedBox()
        ]),
        body: Column(
          children: [
            FutureBuilder(
              future: Future(() async => makeActionTypeCounts(
                  activities: await _getActivities(),
                  tasks: await _getTasks())),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  return ShowTodayOverview(
                    actionTypeCounts: snapshot.data!,
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            FutureBuilder(
                future: Future(
                    () async => [await _getActivities(), await _getTasks()]),
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? ActionsList(
                          activities: snapshot.data![0] as List<Activity>,
                          tasks: snapshot.data![1] as List<Task>,
                        )
                      : Center(child: const CircularProgressIndicator());
                }),
            IconButton(
                onPressed: () => setState(() {}),
                icon: const Icon(Icons.refresh)),
          ],
        ));
  }
}

Map<ActionType, int> makeActionTypeCounts(
    {required List<Activity> activities, required List<Task> tasks}) {
  final List<ActionType> actionTypes = activities
      .map((e) => e.actionType)
      .toList()
    ..addAll(tasks.map((e) => e.actionType));

  Map<ActionType, int> actionTypeCounter = {};

  for (var actionType in actionTypes) {
    actionTypeCounter[actionType] =
        !actionTypeCounter.containsKey(actionType)
            ? (1)
            : (actionTypeCounter[actionType]! + 1);
  }

  return actionTypeCounter;
}
