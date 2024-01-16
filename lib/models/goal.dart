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

  AmountGoal(
      {required this.actionType,
      required this.startDate,
      required this.endDate,
      required this.frequencyFormat,
      required this.chosenUnit,
      required this.amountGoal});

  Map<String, dynamic> toMap() {
    return {
      'goalActionTypeName': actionType.name,
      'goalStartDate': startDate.toString(),
      'goalEndDate': endDate.toString(),
      'goalFrequencyFormat': frequencyFormat.name.toString(),
      'goalChosenUnit': chosenUnit.name.toString(),
      'amountGoal': amountGoal
    };
  }

  factory AmountGoal.fromMap(Map<String, dynamic> map) {
    return AmountGoal(
      actionType: map["goalActionTypeName"].toString().toActionType(),
      startDate: DateTime.parse(map["goalStartDate"].toString()),
      endDate: DateTime.parse(map["goalEndDate"].toString()),
      frequencyFormat:
          map["goalFrequencyFormat"].toString().toGoalFrequencyFormats()!,
      chosenUnit: map["goalChosenUnit"].toString().toUnit()!,
      amountGoal: map["amountGoal"],
    );
  }
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
