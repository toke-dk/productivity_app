enum Units { unitLess, kilometer, hours, minutes }

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
        return "";
      case Units.kilometer:
        return "kilometer";
      case Units.hours:
        return "timer";
      case Units.minutes:
        return "minutter";
    }
  }
}