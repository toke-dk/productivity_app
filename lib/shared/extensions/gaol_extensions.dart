import 'package:productivity_app/models/goal.dart';
import 'package:productivity_app/shared/extensions/date_time_extensions.dart';

extension CheckMarkGoalsExtension on List<CheckmarkGoal> {
  static DateTime get nowOnlyYMD => DateTime
      .now()
      .onlyYearMonthDay;

  List<CheckmarkGoal> get activeGoalsFromToday =>
      this
          .where((element) =>
      nowOnlyYMD.isAfter(element.startDate) &&
          nowOnlyYMD.isBefore(element.endDate) ||
          nowOnlyYMD.isAtSameMomentAs(element.endDate) ||
          nowOnlyYMD.isAtSameMomentAs(element.startDate))
          .toList();

  List<CheckmarkGoal> get previousGoalsFromToday =>
      this.where((element) =>
          element.endDate.isBefore(nowOnlyYMD)).toList();

  List<CheckmarkGoal> get futureGoalsFromToday =>
      this.where((element) =>
          element.startDate.isAfter(nowOnlyYMD)).toList();
}

extension AmountGoalsExtension on List<AmountGoal> {
  static DateTime get nowOnlyYMD => DateTime
      .now()
      .onlyYearMonthDay;


  List<AmountGoal> get activeGoalsFromToday =>
      this
          .where((element) =>
      nowOnlyYMD.isAfter(element.startDate) &&
          nowOnlyYMD.isBefore(element.endDate) ||
          nowOnlyYMD.isAtSameMomentAs(element.endDate) ||
          nowOnlyYMD.isAtSameMomentAs(element.startDate))
          .toList();

  List<AmountGoal> get previousGoalsFromToday =>
      this.where((element) =>
          element.endDate.isBefore(nowOnlyYMD)).toList();

  List<AmountGoal> get futureGoalsFromToday =>
      this.where((element) =>
          element.startDate.isAfter(nowOnlyYMD)).toList();
}
