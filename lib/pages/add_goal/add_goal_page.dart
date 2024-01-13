import 'package:flutter/material.dart';
import 'package:productivity_app/pages/choose_activity/choose_activity.dart';
import 'package:productivity_app/shared/allActionTypes.dart';

import '../../models/activity.dart';
import '../../shared/widgets/activity_card.dart';

class AddGoalPage extends StatefulWidget {
  const AddGoalPage({super.key});

  @override
  State<AddGoalPage> createState() => _AddGoalPageState();
}

class _AddGoalPageState extends State<AddGoalPage> {
  final int _currentStepIndex = 0;
  ActionType? _selectedActionType;
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tilføj mål"),
      ),
      body: Stepper(currentStep: 0, steps: [
        Step(
            title: Text("Vælg handling"),
            content: ActionTypesGridView(
              crossCount: 4,
              hasShadow: false,
              selected: (int index) {
                return _selectedIndex == index;
              },
              dense: true,
              actionTypes: kAllActionTypes,
              onTap: (ActionType actionType, int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            )),
        Step(
            title: Text("Vælg format"),
            content: Container(
              child: Text("Text here"),
            ))
      ]),
    );
  }
}
