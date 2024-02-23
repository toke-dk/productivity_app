import 'package:flutter/material.dart';
import 'package:productivity_app/models/goal.dart';

class AddRoutine extends StatelessWidget {
  const AddRoutine(
      {super.key,
      required this.onCheckMarkGoalAdd,
      required this.onAmountGoalAdd});

  final Function(CheckmarkGoal) onCheckMarkGoalAdd;
  final Function(AmountGoal) onAmountGoalAdd;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tilføj rutine"),
      ),
    );
  }
}
