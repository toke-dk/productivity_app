import 'package:productivity_app/pages/add_routine/pages/define_routine/define_routine.dart';
import 'package:productivity_app/pages/add_routine/pages/define_routine/widgets/add_extra_goal_dialog.dart';

import '../pages/add_routine/add_routine.dart';
import '../pages/add_routine/pages/define_routine/widgets/frequency_widget.dart';
import 'category.dart';
import 'goal.dart';

abstract class Routine {
  Routine(
      {required this.category,
      required this.name,
      this.description,
      required this.startDate,
      this.endDate});

  /// The category is what category the routine is selected for
  Category category;

  /// The name and description is what the user chooses the routine to be called
  String name;
  String? description;

  /// This is the start and the possible end date for the routine
  DateTime startDate;
  DateTime? endDate;
}

class CheckmarkTypeRoutine extends Routine {
  /// The dates where the user has completed the task
  List<DateTime> completedDates;

  CheckmarkTypeRoutine(
      {this.completedDates = const [],
      required super.category,
      required super.name,
      required super.startDate,
      super.description,
      super.endDate});
}

class NumericTypeRoutine extends Routine {
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

  /// The activities where the user has added data to the routine
  List<DoneAmountActivity> doneActivities;

  NumericTypeRoutine({
    required this.quantity,
    required this.amountForOneDay,
    this.unitName,
    required this.completionSchedule,
    this.extraGoal,
    this.doneActivities = const [],
    required super.category,
    required super.name,
    required super.startDate,
    super.description,
    super.endDate,
  });
}

class CompletionSchedule {
  int frequencyAmount;
  DayToYearTimes timePeriod;

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
