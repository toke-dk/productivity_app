import 'package:flutter/material.dart';
import 'package:productivity_app/pages/choose_activity/choose_activity.dart';
import 'package:productivity_app/shared/allActionTypes.dart';

import '../../models/activity.dart';

class AddGoalPage extends StatelessWidget {
  const AddGoalPage({super.key});

  final int _currentStepIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tilføj mål"),
      ),
      body: Stepper(
          currentStep: 0,
          steps: [
        Step(
            title: Text("Vælg handling"),
            content: ActionTypesGridView(
              crossCount: 4,
              dense: true,
              hasShadow: false,
              cardBorder: Border.all(color: Colors.blue),
              actionTypes: kAllActionTypes,
              onTap: (ActionType actionType) {},
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
