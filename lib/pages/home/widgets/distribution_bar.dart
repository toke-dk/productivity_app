import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/activity.dart';
import '../../../widgets/display_activity_type.dart';

class _ShowActivityTypeColors extends StatelessWidget {
  const _ShowActivityTypeColors({super.key, required this.typeCounts});

  final Map<ActivityType, int> typeCounts;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: List.generate(typeCounts.length, (index) {
      final ActivityType currentType = typeCounts.keys.toList()[index];
      final int currentAmount = typeCounts.values.toList()[index];
      return Column(
        children: [
          Row(
            children: [
              DisplayActivityType(activityType: currentType),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 15,
                    height: 8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: currentType.color),
                  ),
                  Text(currentAmount.toString()),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 10,
          )
        ],
      );
    }));
  }
}

class DistributionBar extends StatelessWidget {
  DistributionBar({super.key, required this.activities});

  final List<Activity> activities;

  final List<Color> barColors = [
    Colors.green,
    Colors.orange,
    Colors.blue,
    Colors.purple,
    Colors.indigo,
    Colors.red,
  ];

  // makes the percentage list for the gradient
  List<double> makeStops(Map<ActivityType, double> activityTypeDistribution) {
    List<double> percentageDuplicateList = [];

    for (var i = 0; i < activityTypeDistribution.length; i++) {
      double currentPercent = activityTypeDistribution.values.toList()[i];
      if (i == 0) {
        percentageDuplicateList.addAll([currentPercent, currentPercent]);
      } else {
        double previousPercent = percentageDuplicateList.last;
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
        ),
        const SizedBox(
          height: 15,
        ),
        _ShowActivityTypeColors(typeCounts: activityTypeCounter)
      ],
    );
  }
}
