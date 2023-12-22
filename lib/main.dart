import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:productivity_app/models/activity.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Productivity app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Velkommen'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: [
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.bar_chart_rounded))
          ],
        ),
        body: ShowTodayOverview(
          activities: [
            Activity(
              amount: 5,
              activityType: activityTypes[0],
              chosenUnit: Units.kilometer,
            ),
            Activity(
              amount: 10,
              activityType: activityTypes[0],
              chosenUnit: Units.kilometer,
            ),
            Activity(
              amount: 15,
              activityType: activityTypes[1],
              chosenUnit: Units.unitLess,
            ),
            Activity(
              amount: 3,
              activityType: activityTypes[1],
              chosenUnit: Units.unitLess,
            ),
            Activity(
              amount: 3,
              activityType: activityTypes[1],
              chosenUnit: Units.unitLess,
            ),
            Activity(
              amount: 3,
              activityType: activityTypes[1],
              chosenUnit: Units.unitLess,
            ),
            Activity(
              amount: 20,
              activityType: activityTypes[2],
              chosenUnit: Units.minutes,
            ),
          ],
        ));
  }
}

class ShowTodayOverview extends StatelessWidget {
  ShowTodayOverview({super.key, required this.activities});

  final List<Activity> activities;

  final List<Color> barColors = [
    Colors.green,
    Colors.orange,
    Colors.blue,
    Colors.purple,
    Colors.indigo
  ];

  @override
  Widget build(BuildContext context) {
    // counts occurrence of each type of activity
    Map<ActivityType, int> activityTypeCounter = {};
    for (var activity in activities) {
      activityTypeCounter[activity.activityType] =
          !activityTypeCounter.containsKey(activity.activityType)
              ? (1)
              : (activityTypeCounter[activity.activityType]! + 1);
    }

    // gives percentage to each type of activity
    Map<ActivityType, double> activityTypeDistribution = {};
    for (var i = 0; i < activityTypeCounter.length; i++) {
      ActivityType currentActivityType = activityTypeCounter.keys.toList()[i];

      // set the color for the type
      currentActivityType.color = barColors[i];

      // give the activity type a distribution value
      activityTypeDistribution[currentActivityType] =
          activityTypeCounter.values.toList()[i] / activities.length;
    }

    return Column(
      children: [
        Container(
            padding: const EdgeInsets.all(13),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(14)),
            child: Column(
              children: [
                const QuickStatsText(),
                const SizedBox(
                  height: 20,
                ),
                DistributionBar(
                  activityTypeDistribution: activityTypeDistribution,
                ),
                SizedBox(
                  height: 15,
                ),
                ShowActivityTypeColors(typeCounts: activityTypeCounter)
              ],
            )),
      ],
    );
  }
}

class ShowActivityTypeColors extends StatelessWidget {
  const ShowActivityTypeColors({super.key, required this.typeCounts});

  final Map<ActivityType, int> typeCounts;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: List.generate(typeCounts.length, (index) {
      final ActivityType currentType = typeCounts.keys.toList()[index];
      final int currentAmount = typeCounts.values.toList()[index];
      return Row(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: 20, maxWidth: 20,),
            child: currentType.image
          ),
          Text(currentType.name),
          Text(currentAmount.toString()),
          Container(width: 10, height: 10,color: currentType.color,)
        ],
      );
    }));
  }
}

class QuickStatsText extends StatelessWidget {
  const QuickStatsText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "X",
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const Text(
                  " aktiviteter",
                ),
              ],
            ),
            const Row(
              children: [
                Text(
                  "y aktiviteter",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(" mere end sidste uge"),
              ],
            )
          ],
        ),
        DropdownButton(
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(child: Text("Aktivitet")),
            ],
            onChanged: null)
      ],
    );
  }
}

class DistributionBar extends StatelessWidget {
  DistributionBar({super.key, required this.activityTypeDistribution});

  final Map<ActivityType, double> activityTypeDistribution;

  // makes the percentage list for the gradient
  List<double> makeStops(Map<ActivityType, double> activityTypeDistribution) {
    List<double> percentageDuplicateList = [];
    for (var i = 0; i < activityTypeDistribution.length; i++) {
      double currentPercent = activityTypeDistribution.values.toList()[i];
      if (i == 0) {
        percentageDuplicateList.addAll([currentPercent, currentPercent]);
      } else {
        double previousPercent = percentageDuplicateList[i - 1];
        percentageDuplicateList.addAll([
          previousPercent + currentPercent,
          previousPercent + currentPercent
        ]);
      }
    }
    percentageDuplicateList = [
      0,
      ...percentageDuplicateList.sublist(0, percentageDuplicateList.length - 1),
    ];
    return percentageDuplicateList;
  }

  // makes the color list for gradients
  List<Color> makeGradientColors(
          Map<ActivityType, double> activityTypeDistribution) =>
      activityTypeDistribution.keys
          .map((e) => [e.color!, e.color!])
          .expand((element) => element)
          .toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 15,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: makeGradientColors(activityTypeDistribution),
            stops: makeStops(activityTypeDistribution),
            begin: Alignment.centerLeft,
            end: Alignment.centerRight),
        color: Colors.green,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
