import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:productivity_app/pages/add_routine/pages/define_routine/widgets/add_extra_goal_dialog.dart';

import '../../pages/add_routine/add_routine.dart';
import '../../pages/add_routine/pages/define_routine/define_routine.dart';
import '../../pages/add_routine/pages/define_routine/widgets/frequency_widget.dart';
import '../category.dart';
import '../routine.dart';
import 'package:provider/provider.dart';

class RoutineProvider extends ChangeNotifier {
  /// If the user either wants to complete more completions per day or just
  /// one per day
  EvaluationType? _evaluationType;

  EvaluationType? get evaluationType => _evaluationType;

  set setEvaluationType(EvaluationType evaluationType) {
    _evaluationType = evaluationType;
    notifyListeners();
  }

  /// The category is what category the routine is selected for
  Category? _category;

  Category? get category => _category;

  set setCategory(Category category) {
    _category = category;
    notifyListeners();
  }

  /// The name and description is what the user chooses the routine to be called
  String? _name;

  String? get name => _name;

  set setName(String name) {
    _name = name;
    notifyListeners();
  }

  String? _description;

  String? get description => _description;

  set setDescription(String description) {
    _description = description;
    notifyListeners();
  }

  /// The quantity is either Mindst, Total eller Ubegrænset, which is what the
  /// user wants the goal to be
  Quantity _quantity = Quantity.atLeast;

  Quantity get quantity => _quantity;

  set setQuantity(Quantity quantity) {
    _quantity = quantity;
    notifyListeners();
  }

  /// This is the amount of repetetions the user wants to complete for a day
  int _amountForOneDay = 1;

  int get amountForOneDay => _amountForOneDay;

  set setAmountForOneDay(int amountForOneDay) {
    _amountForOneDay = amountForOneDay;
    notifyListeners();
  }

  /// If the user wants a unit, this is the name
  String? _unitName;

  String? get unitName => _unitName;

  set setUnitName(String unitName) {
    _unitName = unitName;
    notifyListeners();
  }

  /// This section is for [CompletionSchedule] class
  int _completionScheduleFrequency = 1;

  int get completionScheduleFrequency => _completionScheduleFrequency;

  set setCSFrequency(int newValue) {
    _completionScheduleFrequency = newValue;
    notifyListeners();
  }

  DayToYearTimes _completionScheduleTimeUnit = DayToYearTimes.day;

  DayToYearTimes get completionScheduleTimeUnit => _completionScheduleTimeUnit;

  set setCSTimeUnit(DayToYearTimes timeUnit) {
    _completionScheduleTimeUnit = timeUnit;
    notifyListeners();
  }

  /// If the user wants to add aditional goals to his routine, he can do it here
  ExtraGoal? _extraGoal;

  ExtraGoal? get extraGoal => _extraGoal;

  set setExtraGoal(ExtraGoal extraGoal) {
    _extraGoal = extraGoal;
    notifyListeners();
  }

  /// This is the start and the possible end date for the routine
  DateTime _startDate = DateTime.now();

  DateTime get startDate => _startDate;

  set setStartDate(DateTime startDate) {
    _startDate = startDate;
    notifyListeners();
  }

  DateTime _endDate = DateTime.now().add(1.days);

  DateTime get endDate => _endDate;

  set setEndDate(DateTime endDate) {
    _endDate = endDate;
    notifyListeners();
  }

  /// If the routine even has an enddate
  bool _hasEndDate = false;

  bool get hasEndDate => _hasEndDate;

  set setHasEndDate(bool value) {
    _hasEndDate = value;
    notifyListeners();
  }
}
