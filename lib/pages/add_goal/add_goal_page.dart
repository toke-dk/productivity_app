import 'package:flutter/material.dart';
import 'package:productivity_app/models/goal.dart';
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

  GoalTypeFormats? _selectedFormat;

  bool nextButtonDisabled() {
    if (_currentStepIndex == 0 && _selectedActionType == null)
      return true;
    else if (_currentStepIndex == 1 && _selectedFormat == null) return true;
    return false;
  }

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
            content: Row(
              children: [
                _FormatBox(
                  selected: _selectedFormat == GoalTypeFormats.typing,
                  format: GoalTypeFormats.typing,
                  onTap: () {
                    if (_selectedFormat == GoalTypeFormats.typing) {
                      setState(() {
                        _selectedFormat = null;
                      });
                    } else
                      setState(() {
                        _selectedFormat = GoalTypeFormats.typing;
                      });
                  },
                ),
                SizedBox(
                  width: 40,
                ),
                _FormatBox(
                  selected: _selectedFormat == GoalTypeFormats.checkMark,
                  format: GoalTypeFormats.checkMark,
                  onTap: () {
                    if (_selectedFormat == GoalTypeFormats.checkMark) {
                      setState(() {
                        _selectedFormat = null;
                      });
                    } else
                      setState(() {
                        _selectedFormat = GoalTypeFormats.checkMark;
                      });
                  },
                )
              ],
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
                                  !nextButtonDisabled()
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).disabledColor),
                              foregroundColor: MaterialStatePropertyAll(
                                  Theme.of(context).colorScheme.onPrimary)),
                          onPressed: !nextButtonDisabled()
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
          steps: _steps()),
    );
  }
}

class _FormatBox extends StatelessWidget {
  const _FormatBox(
      {super.key,
      this.selected = false,
      required this.format,
      required this.onTap});

  final GoalTypeFormats format;
  final bool selected;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding: EdgeInsets.all(10),
        width: 110,
        height: 150,
        decoration: BoxDecoration(
            border: selected ? Border.all(color: Colors.blue) : null,
            borderRadius: BorderRadius.circular(15),
            color: Colors.grey[100]),
        child: Stack(
          children: [
            Center(
                child: format == GoalTypeFormats.typing
                    ? Icon(
                        Icons.check_circle,
                        size: 30,
                      )
                    : Icon(
                        Icons.onetwothree,
                        size: 50,
                      )),
            Positioned(
                left: 0,
                right: 0,
                child: Text(
                  format == GoalTypeFormats.typing
                      ? "Indtastning"
                      : "Afkrydsning",
                  textAlign: TextAlign.center,
                ))
          ],
        ),
      ),
    );
  }
}
