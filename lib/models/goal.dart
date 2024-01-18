import 'dart:convert';

import 'package:productivity_app/models/activity.dart';
import 'package:productivity_app/models/unit.dart';
import 'package:productivity_app/shared/string_extensions.dart';

class AmountGoal {
  ActionType actionType;
  DateTime startDate;
  DateTime endDate;
  GoalFrequencyFormats frequencyFormat;
  Units chosenUnit;
  double amountGoal;
  List<DoneAmountActivity> doneAmountActivities;

  AmountGoal(
      {required this.actionType,
      required this.startDate,
      required this.endDate,
      required this.frequencyFormat,
      required this.chosenUnit,
      required this.amountGoal,
      this.doneAmountActivities = const <DoneAmountActivity>[]});

  void addDoneAmountActivity(DoneAmountActivity activity) => doneAmountActivities.add(activity);

  Map<String, dynamic> toMap() {
    return {
      'goalActionTypeName': actionType.name,
      'goalStartDate': startDate.toString(),
      'goalEndDate': endDate.toString(),
      'goalFrequencyFormat': frequencyFormat.name.toString(),
      'goalChosenUnit': chosenUnit.name.toString(),
      'amountGoal': amountGoal,
      'doneAmountActivities': doneAmountActivities.toString(),
    };
  }

  factory AmountGoal.fromMap(Map<String, dynamic> map) {
    /// TODO this is the problem
    // print(
    //     "hiii: ${(json.decode(map["doneAmountActivities"].toString()) as List)
    //     .map((e) => DoneAmountActivity(date: DateTime.now(), amount: 2)).toList().runtimeType}");
    return AmountGoal(
      actionType: map["goalActionTypeName"].toString().toActionType(),
      startDate: DateTime.parse(map["goalStartDate"].toString()),
      endDate: DateTime.parse(map["goalEndDate"].toString()),
      frequencyFormat:
          map["goalFrequencyFormat"].toString().toGoalFrequencyFormats()!,
      chosenUnit: map["goalChosenUnit"].toString().toUnit()!,
      amountGoal: map["amountGoal"],
      doneAmountActivities:
          (json.decode(map["doneAmountActivities"].toString()) as List)
              .map((a) => DoneAmountActivity(date: DateTime.now(), amount: 2))
              .toList(),
    );
  }
}

class DoneAmountActivity {
  DateTime date;
  double amount;

  DoneAmountActivity({required this.date, required this.amount});

  @override
  String toString() {
    return "CompletedActivity{date: $date, amount: $amount}";
  }
}

extension DoneAmountActivityExtension on List<DoneAmountActivity> {
  double get totalAmountDone => this.isNotEmpty
      ? this.map((e) => e.amount).reduce((value, element) => value + element)
      : 0;
}

class CheckmarkGoal {
  ActionType actionType;
  DateTime startDate;
  DateTime endDate;
  int daysPerWeek;

  CheckmarkGoal(
      {required this.actionType,
      required this.startDate,
      required this.endDate,
      required this.daysPerWeek});

  Map<String, dynamic> toMap() {
    return {
      'goalActionTypeName': actionType.name,
      'goalStartDate': startDate.toString(),
      'goalEndDate': endDate.toString(),
      'goalDaysPerWeek': daysPerWeek,
    };
  }

  factory CheckmarkGoal.fromMap(Map<String, dynamic> map) {
    return CheckmarkGoal(
      actionType: map["goalActionTypeName"].toString().toActionType(),
      startDate: DateTime.parse(map["goalStartDate"].toString()),
      endDate: DateTime.parse(map["goalEndDate"].toString()),
      daysPerWeek: map["goalDaysPerWeek"],
    );
  }
}

enum GoalTypeFormats { checkMark, typing }

enum GoalFrequencyFormats { perDay, perWeek, inTotal }
