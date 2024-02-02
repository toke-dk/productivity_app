extension DateExtension on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool get isToday => this.onlyYearMonthDay == DateTime.now().onlyYearMonthDay;

  int get weekOfYear {
    final startOfYear = DateTime(year, 1, 1);
    final weekNumber =
        ((difference(startOfYear).inDays + startOfYear.weekday) / 7).ceil();
    return weekNumber;
  }

  DateTime get onlyYearMonthDay => DateTime(this.year, this.month, this.day);
}

extension ListDateExtension on List<DateTime> {
  bool containsDate(DateTime other) => this.any((e) => e.isSameDate(other));
}
