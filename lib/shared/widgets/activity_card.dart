import 'package:flutter/material.dart';
import 'package:productivity_app/shared/myThemedBoxShadow.dart';
import 'package:productivity_app/widgets/display_activity_type.dart';

import '../../models/activity.dart';

class ActivityCard extends StatelessWidget {
  const ActivityCard(
      {super.key, required this.activityType, required this.onTap});

  final ActivityType activityType;
  final Function(ActivityType activityType) onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(activityType),
      splashColor: Colors.transparent,
      child: Container(
          decoration: BoxDecoration(
            boxShadow: [kMyThemedBoxShadow],
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: DisplayActivityType(
            activityType: activityType,
            axisDirection: Axis.vertical,
          )),
    );
  }
}
