import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:productivity_app/pages/add_routine/pages/define_routine/define_routine.dart';
import 'package:productivity_app/pages/add_routine/pages/define_routine/widgets/add_extra_goal_dialog.dart';

class Routine {
  Routine(
      {required this.category,
      required this.name,
      this.description,
      required this.quantity,
      required this.amountForOneDay,
      this.unitName,
      required this.completionSchedule,
      this.extraGoal,
      required this.startDate,
      this.endDate});

  Category category;

  String name;
  String? description;

  Quantity quantity;
  int amountForOneDay;
  String? unitName;

  CompletionSchedule completionSchedule;
  ExtraGoal? extraGoal;

  DateTime startDate;
  DateTime? endDate;
}

class CompletionSchedule {
  int frequencyAmount;
  TimeUnit timePeriod;

  /// The [daysEachTimePeriod] can be null if the timePeriod is day
  /// Becuase then it says how many days per day you want to register
  /// and that is the exact same as the [frequencyAmount]
  int? daysEachTimePeriod;

  CompletionSchedule(
      {required this.frequencyAmount,
      required this.timePeriod,
      this.daysEachTimePeriod});
}

class ExtraGoal {
  TimeUnit timePeriod;
  int amountForTotalTimePeriod;
  DateTime? startDate;
  bool? shouldEndWhenFinished;

  ExtraGoal(
      {required this.timePeriod,
      required this.amountForTotalTimePeriod,
      this.startDate,
      this.shouldEndWhenFinished});
}
