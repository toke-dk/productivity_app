import 'package:productivity_app/models/activity.dart';
import 'package:productivity_app/models/unit.dart';

class Goal {
  ActionType actionType;
  GoalTypeFormats typeFormat;
  DateTime startDate;
  DateTime endDate;
  int? daysPerWeek;
  GoalFrequencyFormats? frequencyFormat;
  Units? chosenUnit;

  Goal(
      {required this.actionType,
      required this.typeFormat,
      required this.startDate,
      required this.endDate,
      this.daysPerWeek,
      this.frequencyFormat,
      this.chosenUnit});

  Map<String, dynamic> toMap() {
    return {
      'goalActionTypeName': actionType.name,
      'goalTypeFormat': typeFormat.name.toString(),
      'goalStartDate': startDate.toString(),
      'goalEndDate': endDate.toString(),
      'goalDaysPerWeek': daysPerWeek,
      'goalFrequencyFormat': frequencyFormat?.name.toString(),
      'goalChosenUnit': chosenUnit?.name.toString(),
    };
  }

  /// factory is used in a constructor when you don't necessarily
  /// want a constructor to create a new instance of your class
  factory Goal.fromMap(Map<String, dynamic> map) {
    return Goal(
      actionType: map["goalActionTypeName"].toString().toActionType(),
      typeFormat: map["goalTypeFormat"].toString().toGoalTypeFormats()!,
      startDate: DateTime.parse(map["goalStartDate"].toString()),
      endDate: DateTime.parse(map["goalEndDate"].toString()),
      daysPerWeek: map["goalDaysPerWeek"],
      frequencyFormat:
          map["goalFrequencyFormat"].toString().toGoalFrequencyFormats(),
      chosenUnit: map["goalChosenUnit"].toString().toUnit(),
    );
  }
}

enum GoalTypeFormats { checkMark, typing }

extension GoalTypeFormatsExtension on String {
  GoalTypeFormats? toGoalTypeFormats() => this != "null" ? GoalTypeFormats.values.byName(this) : null;
}

enum GoalFrequencyFormats { perDay, perWeek, inTotal }

extension GoalFrequencyFormatsExtension on String {
  GoalFrequencyFormats? toGoalFrequencyFormats() => this != "null" ?
      GoalFrequencyFormats.values.byName(this) : null;
}
