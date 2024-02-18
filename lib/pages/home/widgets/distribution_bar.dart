import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/activity.dart';
import '../../../widgets/display_activity_type.dart';

class _ShowActionTypeColors extends StatelessWidget {
  const _ShowActionTypeColors({required this.typeCounts});

  final Map<ActionType, int> typeCounts;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: List.generate(typeCounts.length, (index) {
      final ActionType currentType = typeCounts.keys.toList()[index];
      final int currentAmount = typeCounts.values.toList()[index];
      return Column(
        children: [
          Row(
            children: [
              DisplayActionType(actionType: currentType),
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
  DistributionBar({super.key, required this.actionTypeCounts});

  final Map<ActionType, int> actionTypeCounts;

  final List<Color> barColors = [
    Colors.green,
    Colors.orange,
    Colors.blue,
    Colors.purple,
    Colors.indigo,
    Colors.red,
  ];

  // makes the percentage list for the gradient
  List<double> makeStops(Map<ActionType, double> actionTypeDistribution) {
    List<double> percentageDuplicateList = [];

    for (var i = 0; i < actionTypeDistribution.length; i++) {
      double currentPercent = actionTypeDistribution.values.toList()[i];
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
          Map<ActionType, double> actionTypeDistribution) =>
      actionTypeDistribution.keys
          .map((e) => [e.color!, e.color!])
          .expand((element) => element)
          .toList();

  @override
  Widget build(BuildContext context) {

    // gives percentage to each type of activity
    Map<ActionType, double> actionTypeDistribution = {};
    for (var i = 0; i < actionTypeCounts.length; i++) {
      ActionType currentActionType = actionTypeCounts.keys.toList()[i];

      // set the color for the type
      currentActionType.color = barColors[i];

      // give the activity type a distribution value
      actionTypeDistribution[currentActionType] =
          actionTypeCounts.values.toList()[i] /actionTypeCounts.values.toList().reduce((a, b) => a+b);
    }

    return Column(
      children: [
        Container(
          height: 15,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: makeGradientColors(actionTypeDistribution),
                stops: makeStops(actionTypeDistribution),
                begin: Alignment.centerLeft,
                end: Alignment.centerRight),
            color: Colors.green,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        _ShowActionTypeColors(typeCounts: actionTypeCounts)
      ],
    );
  }
}
