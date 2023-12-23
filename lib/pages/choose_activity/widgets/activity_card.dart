import 'package:flutter/material.dart';

import '../../../models/activity.dart';

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
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 20,
              child: ClipOval(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: activityType.image,
              )),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(activityType.name)
          ],
        ),
      ),
    );
  }
}
