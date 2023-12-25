import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final List<ActivityType> kActivityTypes = [
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
  ActivityType(name: "Dummy", possibleUnits: [Units.unitLess], image: Placeholder())
];

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

enum Units { unitLess, kilometer, hours, minutes }

extension UnitsExtension on Units {
  bool get isDistance {
    switch (this) {
      case Units.kilometer:
        return true;
      case Units.hours:
        return false;
      case Units.minutes:
        return false;
      case Units.unitLess:
        return false;
    }
  }

  bool get isDuration {
    switch (this) {
      case Units.kilometer:
        return false;
      case Units.hours:
        return true;
      case Units.minutes:
        return true;
      case Units.unitLess:
        return false;
    }
  }
}
