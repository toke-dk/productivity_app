import 'package:productivity_app/models/goal.dart';
import 'package:productivity_app/shared/extensions/date_time_extensions.dart';

extension CheckMarkGoalsExtension on List<CheckmarkGoal> {
  List<CheckmarkGoal> get activeGoalsFromToday => this
      .where((element) =>
          DateTime.now().isBefore(element.endDate) ||
          DateTime.now().isAtSameMomentAs(element.endDate))
      .toList();
}

extension AmountGoalsExtension on List<AmountGoal> {
  List<AmountGoal> get activeGoalsFromToday => this
      .where((element) =>
          DateTime.now()
              .onlyYearMonthDay
              .isBefore(element.endDate.onlyYearMonthDay) ||
          DateTime.now()
              .onlyYearMonthDay
              .isAtSameMomentAs(element.endDate.onlyYearMonthDay))
      .toList();
}
