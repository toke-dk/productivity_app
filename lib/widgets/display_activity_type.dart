import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:productivity_app/models/activity.dart';

class DisplayActionType extends StatelessWidget {
  const DisplayActionType(
      {super.key,
      required this.actionType,
      this.axisDirection = Axis.horizontal,
      this.dense = false,
      this.mainAxisAlignment = MainAxisAlignment.center});

  final ActionType actionType;
  final Axis axisDirection;
  final bool dense;
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    List<Widget> childrenToDisplay = [
      /// [AspectRatio] shows the size of the widget compared to its parent
      CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        radius: 20,
        child: FittedBox(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: actionType.image,
        )),
      ),
      SizedBox(
        width: axisDirection == Axis.horizontal ? 10 : 0,
        height: axisDirection == Axis.vertical ? 4 : 0,
      ),
      FittedBox(fit: BoxFit.fitWidth, child: Text(actionType.name))
    ];

    return axisDirection == Axis.horizontal
        ? Transform.scale(
            scale: dense ? 0.8 : 1,
            child: Row(
                mainAxisAlignment: mainAxisAlignment,
                children: childrenToDisplay),
          )
        : Transform.scale(
            scale: dense ? 0.8 : 1,
            child: Column(
              mainAxisAlignment: mainAxisAlignment,
              children: childrenToDisplay,
            ),
          );
  }
}
