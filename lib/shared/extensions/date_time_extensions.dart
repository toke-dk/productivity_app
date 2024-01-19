extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

extension ListDateExtension on List<DateTime> {
  bool containsDate(DateTime other) => this.any((e) => e.isSameDate(other));
}