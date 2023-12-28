import 'package:flutter/material.dart';
import 'package:productivity_app/widgets/display_activity_type.dart';
import '../../../models/activity.dart';

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
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(14)),
            child: activities.isNotEmpty ? Column(
              children: [
                const _QuickStatsText(),
                const SizedBox(
                  height: 20,
                ),
                _DistributionBar(
                  activityTypeDistribution: activityTypeDistribution,
                ),
                const SizedBox(
                  height: 15,
                ),
                _ShowActivityTypeColors(typeCounts: activityTypeCounter)
              ],
            ): Center(child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text("Ingen aktiviteter i dag", style: Theme.of(context).textTheme.bodyLarge,),
            ),)),
      ],
    );
  }
}

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

class _QuickStatsText extends StatelessWidget {
  const _QuickStatsText({super.key});

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

class _DistributionBar extends StatelessWidget {
  const _DistributionBar({super.key, required this.activityTypeDistribution});

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
