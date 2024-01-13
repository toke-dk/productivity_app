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
  int _currentStepIndex = 0;
  ActionType? _selectedActionType;
  int? _selectedIndex;

  List<Step> _steps() => [
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
                if (index == _selectedIndex) {
                  print("same");
                  setState(() {
                    _selectedActionType = null;
                    _selectedIndex = null;
                  });
                } else
                  setState(() {
                    _selectedActionType = actionType;
                    _selectedIndex = index;
                  });
              },
            )),
        Step(
            title: Text("Vælg format"),
            content: Container(
              child: Text("Text here"),
            ))
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tilføj mål"),
      ),
      body: Stepper(
          controlsBuilder: (BuildContext context, ControlsDetails details) =>
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      TextButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  _selectedActionType != null
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).disabledColor),
                              foregroundColor: MaterialStatePropertyAll(
                                  Theme.of(context).colorScheme.onPrimary)),
                          onPressed: _selectedActionType != null
                              ? details.onStepContinue
                              : null,
                          child: Text(_steps().length - 1 != details.currentStep
                              ? "Fortsæt"
                              : "Tilføj mål")),
                      SizedBox(
                        width: 10,
                      ),
                      TextButton(
                          onPressed: details.currentStep != 0
                              ? details.onStepCancel
                              : null,
                          child: Text("Tilbage")),
                    ],
                  ),
                ),
              ),
          currentStep: _currentStepIndex,
          onStepContinue: () {
            if (_currentStepIndex <= 0) {
              setState(() {
                _currentStepIndex += 1;
              });
            }
          },
          onStepCancel: () {
            if (_currentStepIndex > 0) {
              setState(() {
                _currentStepIndex -= 1;
              });
            }
          },
          onStepTapped: (int index) => setState(() {
                _currentStepIndex = index;
              }),
          steps: _steps()),
    );
  }
}
