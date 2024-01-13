import 'package:productivity_app/models/activity.dart';
import 'package:productivity_app/models/unit.dart';

class Goal {
  ActionType actionType;
  GoalTypeFormats typeFormat;
  DateTime startDate;
  DateTime endDate;
  int daysPerWeek;
  GoalFrequencyFormats frequencyFormat;
  Units chosenUnit;

  Goal(
      {required this.actionType,
      required this.typeFormat,
      required this.startDate,
      required this.endDate,
      required this.daysPerWeek,
      required this.frequencyFormat,
      required this.chosenUnit});
}

enum GoalTypeFormats { checkMark, typing }

enum GoalFrequencyFormats { perDay, perWeek, inTotal }
