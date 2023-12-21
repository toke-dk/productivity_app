import 'package:flutter/cupertino.dart';

final List<ActivityType> activityTypes = [
  ActivityType(name: "Cykling",
      possibleUnits: [Units.kilometer, Units.hours, Units.minutes]),
  ActivityType(name: "Armhævning", possibleUnits: [Units.unitLess])
];

class Activity {
  int amount;
  ActivityType activityType;
  Units chosenUnit;
  Widget image;

  Activity({
    required this.amount,
    required this.activityType,
    required this.chosenUnit,
    required this.image,
  });
}

class ActivityType {
  String name;
  List<Units> possibleUnits;

  ActivityType({
    required this.name,
    required this.possibleUnits,
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
