import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:productivity_app/models/unit.dart';

class Activity {
  double? amount;
  ActivityType activityType;
  bool? isTask;
  Units chosenUnit;

  Activity({
    this.amount,
    required this.activityType,
    required this.chosenUnit,
    this.isTask,
  });
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
    forEach((element) => finalMap[element] =
        !finalMap.containsKey(element) ? (1) : (finalMap[element]! + 1));
    return finalMap;
  }
}

/// Provider
class ActivityProvider extends ChangeNotifier{

  /// Activity types
  final List<ActivityType> _allActivityTypes = [
    ActivityType(
        name: "Cykling",
        possibleUnits: [Units.kilometer, Units.hours, Units.minutes],
        image: Icon(Icons.directions_bike_outlined)),
    ActivityType(
        name: "Armhævning",
        possibleUnits: [Units.unitLess],
        image: Icon(Icons.fitness_center)),
    ActivityType(
        name: "Læsning",
        possibleUnits: [Units.minutes, Units.hours],
        image: Icon(Icons.chrome_reader_mode_outlined)),
    ActivityType(
        name: "Dummy", possibleUnits: [Units.unitLess], image: Placeholder())
  ];

  List<ActivityType> get getAllActivityTypes => UnmodifiableListView(_allActivityTypes);

  /// When making an activity
  static ActivityType? _currentActivityType;
  ActivityType? get getCurrentActivityType => _currentActivityType;

  void setCurrentActivity(ActivityType newActivityType){
    _currentActivityType = newActivityType;
    notifyListeners();
  }

  static double? _currentAmount;
  double? get getAmount => _currentAmount;

  void setCurrentAmount(double newAmount){
    _currentAmount = newAmount;
    notifyListeners();
  }

  static Units? _currentUnit;
  Units? get getCurrentUnit => _currentUnit;

  void setCurrentUnit(Units newUnit){
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
