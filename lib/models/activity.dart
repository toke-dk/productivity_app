import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:productivity_app/models/unit.dart';
import 'package:productivity_app/shared/allActivityTypes.dart';
import 'package:provider/provider.dart';

class Activity {
  double? amount;
  ActivityType activityType;
  bool? isTask;
  Units? chosenUnit;

  Activity({
    this.amount,
    required this.activityType,
    this.chosenUnit,
    this.isTask,
  });

  Map<String, dynamic> toMap() {
    return {
      'activityTypeName': activityType.name,
    };
  }

  /// factory is used in a constructor when you don't necessarily
  /// want a constructor to create a new instance of your class
  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
        activityType: map["activityTypeName"].toString().toActivityType());
  }

  @override
  String toString() {
    return 'Activity{activityTypeName: ${activityType.name}}';
  }
}

extension ActivityTypeStringExtension on String {
  ActivityType toActivityType() => kAllActivityTypes.firstWhere((element) => element.name == this);
}

class ActivityType {
  String name;
  List<Units> possibleUnits;
  Color? color;
  Widget image;

  ActivityType({
    required this.name,
    required this.possibleUnits,
    required this.image,
    this.color,
  });
}

extension Activities on List<Activity> {
  Map<Activity, double> get distributeActivities {
    Map<Activity, double> finalMap = {};
    forEach((element) =>
    finalMap[element] =
    !finalMap.containsKey(element) ? (1) : (finalMap[element]! + 1));
    return finalMap;
  }
}

/// Provider
class ActivityProvider extends ChangeNotifier {

  /// When making an activity
  static ActivityType? _currentActivityType;

  ActivityType? get getCurrentActivityType => _currentActivityType;

  void setCurrentActivity(ActivityType newActivityType) {
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
