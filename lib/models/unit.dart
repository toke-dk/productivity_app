import 'package:flutter/foundation.dart';

/// The [Units.unitLess] is it is just about amounts and no distance or time
/// Therefore it is not necescaraly empty as for tasks only, but it is a just
/// counter

enum Units { unitLess, kilometer, hours, minutes }

final String _strNameUnitLess = "";
final String _strNameKilometer = "kilometer";
final String _strNameHours = "timer";
final String _strNameMinutes = "minutter";

extension UnitsExtension on Units {
  String get textForUnitMeasure {
    switch (this) {
      case Units.kilometer:
        return "Distance";
      case Units.hours:
        return "Tid";
      case Units.minutes:
        return "Tid";
      case Units.unitLess:
        return "Antal";
    }
  }

  String get stringName {
    switch (this) {
      case Units.unitLess:
        return _strNameUnitLess;
      case Units.kilometer:
        return _strNameKilometer;
      case Units.hours:
        return _strNameHours;
      case Units.minutes:
        return _strNameMinutes;
    }
  }

  String get shortStringName {
    switch (this) {
      case Units.unitLess:
        return "";
      case Units.kilometer:
        return "km";
      case Units.hours:
        return "t";
      case Units.minutes:
        return "m";
    }
  }
}

extension UnitStringExtension on String {
  Units? toUnitFromStringName() {
    if (this == _strNameUnitLess)
      return Units.unitLess;
    else if (this == _strNameMinutes)
      return Units.minutes;
    else if (this == _strNameHours)
      return Units.hours;
    else if (this == _strNameKilometer) return Units.kilometer;
    return null;
  }
}
