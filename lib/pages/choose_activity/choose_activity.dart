import 'package:flutter/material.dart';
import 'package:productivity_app/models/activity.dart';
import 'package:productivity_app/shared/widgets/activity_card.dart';


class ActionTypesGridView extends StatelessWidget {
  const ActionTypesGridView(
      {super.key,
      required this.actionTypes,
      this.maxRows,
      required this.onTap,
      this.dense = false,
      this.crossCount = 3,
      this.hasShadow = true,
      this.cardBorder,
      this.selected});

  final bool dense;
  final List<ActionType> actionTypes;
  final int? maxRows;
  final int crossCount;
  final bool hasShadow;
  final BoxBorder? cardBorder;
  final Function(ActionType actionType, int index) onTap;
  final bool Function(int index)? selected;

  @override
  Widget build(BuildContext context) {
    int listLength = actionTypes.length;
    int amountOfGenerates =
        maxRows == null || (listLength / crossCount).ceil() < maxRows!
            ? listLength
            : 3 * maxRows!;

    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: crossCount,
      padding: EdgeInsets.all(dense ? 0 : 20),
      crossAxisSpacing: dense ? 10 : 30,
      mainAxisSpacing: dense ? 10 : 30,
      children: List.generate(
          amountOfGenerates,
          (index) => ActivityCard(
                selected: selected != null ? selected!(index) : false,
                hasShadow: hasShadow,
                dense: dense,
                actionType: actionTypes[index],
                onTap: (ActionType actionType) =>
                    onTap(actionTypes[index], index),
              )),
    );
  }
}
