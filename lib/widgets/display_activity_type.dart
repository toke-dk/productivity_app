import 'package:flutter/material.dart';
import 'package:productivity_app/models/activity.dart';

class DisplayActionType extends StatelessWidget {
  const DisplayActionType(
      {super.key,
      required this.actionType,
      this.axisDirection = Axis.horizontal});

  final ActionType actionType;
  final Axis axisDirection;

  @override
  Widget build(BuildContext context) {
    List<Widget> childrenToDisplay = [
      CircleAvatar(
        radius: 20,
        child: ClipOval(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: actionType.image,
        )),
      ),
      SizedBox(
        width: axisDirection == Axis.horizontal ? 10 : 0,
        height: axisDirection == Axis.vertical ? 10 : 0,
      ),
      Text(actionType.name)
    ];

    return axisDirection == Axis.horizontal
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: childrenToDisplay)
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: childrenToDisplay,
          );
  }
}
