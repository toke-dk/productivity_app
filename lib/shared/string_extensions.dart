
import 'package:productivity_app/models/unit.dart';

import '../models/activity.dart';
import '../models/goal.dart';
import 'allActionTypes.dart';


extension MyStringExtensions on String {
  GoalFrequencyFormats? toGoalFrequencyFormats() =>
      this != "null" ? GoalFrequencyFormats.values.byName(this) : null;

  Units? toUnit() => this != "null" ? Units.values.byName(this) : null;

  ActionType toActionType() =>
      kAllActionTypes.firstWhere((element) => element.name == this);

}