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

  /// The category is what category the routine is selected for
  Category category;

  /// The name and description is what the user chooses the routine to be called
  String name;
  String? description;

  /// The quantity is either Mindst, Total eller Ubegrænset, which is what the
  /// user wants the goal to be
  Quantity quantity;
  /// This is the amount of repetetions the user wants to complete for a day
  int amountForOneDay;
  /// If the user wants a unit, this is the name
  String? unitName;

  /// This is how often the user wants to complete his [amountForOneDay] goal
  CompletionSchedule completionSchedule;
  /// If the user wants to add aditional goals to his routine, he can do it here
  ExtraGoal? extraGoal;

  /// This is the start and the possible end date for the routine
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
