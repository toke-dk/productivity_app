import 'package:flutter/material.dart';
import 'package:productivity_app/shared/myThemedBoxShadow.dart';
import 'package:productivity_app/widgets/display_activity_type.dart';

import '../../models/activity.dart';

class ActivityCard extends StatelessWidget {
  const ActivityCard(
      {super.key, required this.actionType, required this.onTap, this.dense = false, this.hasShadow = true, this.border});

  final bool dense;
  final ActionType actionType;
  final bool hasShadow;
  final BoxBorder? border;
  final Function(ActionType actionType) onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(actionType),
      splashColor: Colors.transparent,
      child: Container(
          decoration: BoxDecoration(
            boxShadow: hasShadow ? [kMyThemedBoxShadow] : [],
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: border,
          ),
          child: DisplayActionType(
            dense: dense,
            actionType: actionType,
            axisDirection: Axis.vertical,
          )),
    );
  }
}
