import 'package:flutter/cupertino.dart';

import '../../pages/add_routine/add_routine.dart';
import '../../pages/add_routine/pages/define_routine/define_routine.dart';
import '../category.dart';
import '../routine.dart';
import 'package:provider/provider.dart';

class RoutineProvider extends ChangeNotifier{

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

  /// The name and description is what the user chooses the routine to be called
  String? _name;
  String? get name => _name;
  String? _description;
  String? get description => _description;

  /// The quantity is either Mindst, Total eller Ubegrænset, which is what the
  /// user wants the goal to be
  Quantity? _quantity;
  Quantity? get quantity => _quantity;

  /// This is the amount of repetetions the user wants to complete for a day
  int? _amountForOneDay;
  int? get amountForOneDay => _amountForOneDay;

  /// If the user wants a unit, this is the name
  String? _unitName;
  String? get unitName => _unitName;

  /// This is how often the user wants to complete his [amountForOneDay] goal
  CompletionSchedule? _completionSchedule;
  CompletionSchedule? get completionSchedule => _completionSchedule;

  /// If the user wants to add aditional goals to his routine, he can do it here
  ExtraGoal? _extraGoal;
  ExtraGoal? get extraGoal => _extraGoal;

  /// This is the start and the possible end date for the routine
  DateTime? _startDate;
  DateTime? get startDate => _startDate;

  DateTime? _endDate;
  DateTime? get endDate => _endDate;
}

