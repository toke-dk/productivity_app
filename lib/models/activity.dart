import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:productivity_app/models/task.dart';
import 'package:productivity_app/models/unit.dart';
import 'package:productivity_app/shared/allActionTypes.dart';
import 'package:provider/provider.dart';

class Activity {
  double amount;
  ActionType activityType;
  Units chosenUnit;
  DateTime dateCompleted;

  Activity({
    required this.amount,
    required this.activityType,
    required this.chosenUnit,
    required this.dateCompleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'activityTypeName': activityType.name,
      'amount': amount,
      'chosenUnit':chosenUnit.name.toString(),
      'dateCompleted': dateCompleted.toString(),
    };
  }

  /// factory is used in a constructor when you don't necessarily
  /// want a constructor to create a new instance of your class
  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
      activityType: map["activityTypeName"].toString().toActionType(),
      amount: map["amount"],
      chosenUnit: map["chosenUnit"].toString().toUnit(),
      dateCompleted: DateTime.parse(map["dateCompleted"].toString()),
    );
  }

  @override
  String toString() {
    return '''
    Activity{
    activityTypeName: ${activityType.name}, 
    amount: $amount, 
    chosenUnit: $chosenUnit, 
    dateCompleted: $dateCompleted}
    ''';
  }
}

extension Activities on List<Activity> {
  Map<Activity, double> get distributeActivities {
    Map<Activity, double> finalMap = {};
    forEach((element) => finalMap[element] =
        !finalMap.containsKey(element) ? (1) : (finalMap[element]! + 1));
    return finalMap;
  }
}

/// Provider
class ActivityProvider extends ChangeNotifier {
  /// When making an activity
  static ActionType? _currentActivityType;

  ActionType? get getCurrentActivityType => _currentActivityType;

  void setCurrentActivity(ActionType newActivityType) {
    _currentActivityType = newActivityType;
    notifyListeners();
  }

  static double? _currentAmount;

  double? get getAmount => _currentAmount;

  void setCurrentAmount(double newAmount) {
    _currentAmount = newAmount;
    notifyListeners();
  }

  static Units? _currentUnit;

  Units? get getCurrentUnit => _currentUnit;

  void setCurrentUnit(Units newUnit) {
    _currentUnit = newUnit;
    notifyListeners();
  }

  /// All activities
  static final List<Activity> _allActivities = [];

  List<Activity> get getAllActivities => _allActivities;

  void addActivity(Activity newActivity) {
    _allActivities.add(newActivity);
    notifyListeners();
  }
}


/// The [ActionType] class describes what type of activities is done

extension ActivityTypeStringExtension on String {
  ActionType toActionType() =>
      kAllActionTypes.firstWhere((element) => element.name == this);
}

class ActionType {
  String name;
  List<Units> possibleUnits;
  Color? color;
  Widget image;
  bool asTask;
  bool asActivity;

  ActionType({
    required this.name,
    required this.possibleUnits,
    required this.image,
    this.color,
    this.asTask = true,
    this.asActivity = true,
  });
}

class ActivityTypeCount {
  int amountDone;
  ActionType activityType;

  ActivityTypeCount({required this.amountDone, required this.activityType});
}

class ActivityTypeCountDate {
  DateTime date;
  List<ActivityTypeCount> activityTypeCounts;

  ActivityTypeCountDate({required this.date, required this.activityTypeCounts});
}



