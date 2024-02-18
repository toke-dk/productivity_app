import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:productivity_app/models/goal.dart';
import 'package:productivity_app/models/unit.dart';
import 'package:productivity_app/pages/choose_activity/choose_activity.dart';
import 'package:productivity_app/services/database_service.dart';
import 'package:productivity_app/shared/allActionTypes.dart';
import 'package:productivity_app/shared/extensions/date_time_extensions.dart';

import '../../models/activity.dart';
import '../../shared/widgets/activity_card.dart';

class AddGoalPage extends StatefulWidget {
  const AddGoalPage(
      {super.key,
      required this.onCheckMarkGoalAdd,
      required this.onAmountGoalAdd});

  final Function(CheckmarkGoal checkmarkGoal) onCheckMarkGoalAdd;
  final Function(AmountGoal amountGoal) onAmountGoalAdd;

  @override
  State<AddGoalPage> createState() => _AddGoalPageState();
}

class _AddGoalPageState extends State<AddGoalPage> {
  int _currentStepIndex = 0;

  ActionType? _selectedActionType;
  int? _selectedIndex;

  GoalTypeFormats? _selectedFormat;

  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now().add(1.days);

  int _selectedDaysPerWeek = 7;

  double? _selectedTotalAmount;

  Units? _selectedUnit;

  bool doesStartEndDateConflict() =>
      _selectedStartDate.isAfter(_selectedEndDate) ||
      _selectedStartDate.isSameDate(_selectedEndDate);

  bool nextButtonDisabled() {
    if (_currentStepIndex == 0 && _selectedActionType == null)
      return true;
    else if (_currentStepIndex == 1 && _selectedFormat == null)
      return true;
    else if ((_currentStepIndex == 2 && doesStartEndDateConflict()) ||
        (_currentStepIndex == 2 &&
            _selectedTotalAmount == null &&
            _selectedFormat == GoalTypeFormats.typing)) return true;
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
                if (_selectedFormat != null) {
                  setState(() {
                    _selectedFormat = null;
                  });
                }
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
                _selectedActionType != null && _selectedActionType!.asTask
                    ? _FormatBox(
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
                    : SizedBox(),
                SizedBox(
                  width: 40,
                ),
                _selectedActionType != null && _selectedActionType!.asActivity
                    ? _FormatBox(
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
                              _selectedUnit =
                                  _selectedActionType!.possibleUnits![0];
                            });
                        },
                      )
                    : SizedBox(),
              ],
            )),
        Step(
            title: Text("Specifikationer"),
            content: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("Start Dato"),
                  GestureDetector(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                          initialDate: _selectedStartDate);
                      if (pickedDate != null &&
                          pickedDate != _selectedStartDate) {
                        setState(() {
                          _selectedStartDate = pickedDate;
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: doesStartEndDateConflict()
                              ? Colors.red[100]
                              : null,
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(color: Colors.grey[900]!)),
                      child: Row(
                        children: [
                          Text(DateFormat("EEE. dd. MMM. yyyy")
                              .format(_selectedStartDate)),
                          Spacer(),
                          doesStartEndDateConflict()
                              ? Icon(
                                  Icons.warning,
                                  color: Colors.red,
                                )
                              : SizedBox()
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Slut Dato"),
                  GestureDetector(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                          initialDate: _selectedEndDate);
                      if (pickedDate != null &&
                          pickedDate != _selectedEndDate) {
                        setState(() {
                          _selectedEndDate = pickedDate;
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(color: Colors.grey[900]!)),
                      child: Text(DateFormat("EEE. dd. MMM. yyyy")
                          .format(_selectedEndDate)),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  !doesStartEndDateConflict()
                      ? Center(
                          child: Text(
                          "${_selectedEndDate.difference(_selectedStartDate).inDays} dage",
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(color: Colors.grey[600]),
                        ))
                      : SizedBox(),
                  SizedBox(
                    height: 18,
                  ),
                  _selectedFormat != GoalTypeFormats.checkMark
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Antal i alt"),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: TextField(
                                    onChanged: (String newVal) => setState(() {
                                      _selectedTotalAmount = newVal != ""
                                          ? double.parse(newVal)
                                          : null;
                                    }),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        hintText: "Eks. 42",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        )),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                _selectedActionType != null &&
                                        _selectedActionType!.possibleUnits !=
                                            null &&
                                        (_selectedActionType!.possibleUnits!
                                                .toList()
                                              ..removeWhere((Units unit) =>
                                                  unit == Units.unitLess))
                                            .isNotEmpty
                                    ? DropdownMenu(
                                        onSelected: (String? newVal) =>
                                            setState(() {
                                              _selectedUnit = newVal
                                                      ?.toUnitFromStringName() ??
                                                  null;
                                            }),
                                        initialSelection: _selectedActionType!
                                            .possibleUnits![0].stringName,
                                        dropdownMenuEntries:
                                            _selectedActionType!.possibleUnits!
                                                .map((e) => e.stringName)
                                                .map<DropdownMenuEntry<String>>(
                                                    (String val) =>
                                                        DropdownMenuEntry(
                                                            value: val,
                                                            label: val))
                                                .toList())
                                    : SizedBox(),
                              ],
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Text("Dage om ugen ($_selectedDaysPerWeek)"),
                            Row(
                              children: [
                                Text("1"),
                                Expanded(
                                  child: Slider(
                                      min: 1,
                                      max: 7,
                                      value: _selectedDaysPerWeek.toDouble(),
                                      divisions: 7,
                                      label: _selectedDaysPerWeek.toString(),
                                      onChanged: (double newVal) {
                                        setState(() {
                                          _selectedDaysPerWeek = newVal.toInt();
                                        });
                                      }),
                                ),
                                Text("7")
                              ],
                            ),
                            SizedBox(
                              height: 18,
                            ),
                          ],
                        )
                ],
              ),
            ))
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tilføj mål"),
      ),
      body: SingleChildScrollView(
        child: Stepper(
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
              if (_currentStepIndex < _steps().length - 1) {
                setState(() {
                  _currentStepIndex += 1;
                });
              } else {
                if (_selectedFormat == GoalTypeFormats.typing) {
                  widget.onAmountGoalAdd(AmountGoal(
                      actionType: _selectedActionType!,
                      startDate: _selectedStartDate.onlyYearMonthDay,
                      endDate: _selectedEndDate.onlyYearMonthDay,
                      frequencyFormat: GoalFrequencyFormats.inTotal,
                      chosenUnit: _selectedUnit!,
                      amountGoal: _selectedTotalAmount!));
                } else if (_selectedFormat == GoalTypeFormats.checkMark) {
                  widget.onCheckMarkGoalAdd(CheckmarkGoal(
                      actionType: _selectedActionType!,
                      startDate: _selectedStartDate.onlyYearMonthDay,
                      endDate: _selectedEndDate.onlyYearMonthDay,
                      daysPerWeek: _selectedDaysPerWeek));
                }
                Navigator.pop(context);
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
      ),
    );
  }
}

class _FormatBox extends StatelessWidget {
  const _FormatBox(
      {this.selected = false,
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
                        Icons.onetwothree,
                        size: 30,
                      )
                    : Icon(
                        Icons.check_circle,
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
