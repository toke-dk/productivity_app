import 'dart:convert';

import 'package:productivity_app/models/activity.dart';
import 'package:productivity_app/models/unit.dart';
import 'package:productivity_app/shared/extensions/date_time_extensions.dart';
import 'package:productivity_app/shared/extensions/string_extensions.dart';
import 'package:uuid/uuid.dart';

class AmountGoal {
  String id;
  ActionType actionType;
  DateTime startDate;
  DateTime endDate;
  GoalFrequencyFormats frequencyFormat;
  Units chosenUnit;
  double amountGoal;
  List<DoneAmountActivity> doneAmountActivities;

  AmountGoal(
      {String? id,
      required this.actionType,
      required this.startDate,
      required this.endDate,
      required this.frequencyFormat,
      required this.chosenUnit,
      required this.amountGoal,
      this.doneAmountActivities = const <DoneAmountActivity>[]})
      : id = id ?? Uuid().v1();

  void addDoneAmountActivity(DoneAmountActivity activity) =>
      doneAmountActivities.add(activity);

  int get daysUntilEndDateFromNow =>
      endDate.difference(DateTime.now().onlyYearMonthDay).inDays;

  int daysUntilEndDateFromDate(DateTime date) =>
      endDate.difference(date.onlyYearMonthDay).inDays;

  List<DoneAmountActivity> doneActivitiesBeforeDate(DateTime date) =>
      doneAmountActivities
          .where((activityDate) => activityDate.date.isBefore(date) || activityDate.date.isAtSameMomentAs(date))
          .toList();

  double percentOfTotalAmountFromDate(DateTime date) => doneActivitiesBeforeDate(date).totalAmountDone/amountGoal;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'goalActionTypeName': actionType.name,
      'goalStartDate': startDate.toString(),
      'goalEndDate': endDate.toString(),
      'goalFrequencyFormat': frequencyFormat.name.toString(),
      'goalChosenUnit': chosenUnit.name.toString(),
      'amountGoal': amountGoal,
      //TODO: maybe change this
      'doneAmountActivities':
          doneAmountActivities.map((e) => e.encodeToJson()).toList().toString(),
    };
  }

  factory AmountGoal.fromMap(Map<String, dynamic> map) {
    /// TODO this is the problem
    // print(
    //     "hiii: ${(json.decode(map["doneAmountActivities"].toString()) as List)
    //     .map((e) => DoneAmountActivity(date: DateTime.now(), amount: 2)).toList().runtimeType}");
    return AmountGoal(
      id: map["id"].toString(),
      actionType: map["goalActionTypeName"].toString().toActionType(),
      startDate: DateTime.parse(map["goalStartDate"].toString()),
      endDate: DateTime.parse(map["goalEndDate"].toString()),
      frequencyFormat:
          map["goalFrequencyFormat"].toString().toGoalFrequencyFormats()!,
      chosenUnit: map["goalChosenUnit"].toString().toUnit()!,
      amountGoal: map["amountGoal"],
      doneAmountActivities:
          (json.decode(map["doneAmountActivities"].toString()) as List)
              .map((a) => DoneAmountActivity(
                  date: DateTime.parse(a["date"].toString()),
                  amount: double.parse(a["amount"].toString())))
              .toList(),
    );
  }
}

class DoneAmountActivity {
  DateTime date;
  double amount;

  DoneAmountActivity({required this.date, required this.amount});

  String encodeToJson() {
    return json.encode({"date": date.toString(), "amount": amount});
  }
}

extension DoneAmountActivityExtension on List<DoneAmountActivity> {
  double get totalAmountDone => this.isNotEmpty
      ? this.map((e) => e.amount).reduce((value, element) => value + element)
      : 0;

  Map<DateTime, List<DoneAmountActivity>> get groupDoneAmountByDate {
    Map<DateTime, List<DoneAmountActivity>> mapToReturn = {};
    List<DoneAmountActivity> sortedDates = this..sort((DoneAmountActivity a, DoneAmountActivity b) => b.date.compareTo(a.date));
    sortedDates.forEach((DoneAmountActivity activity) {
      if (mapToReturn.containsKey(activity.date.onlyYearMonthDay)) {
        mapToReturn[activity.date.onlyYearMonthDay]!.add(activity);
      } else {
        mapToReturn[activity.date.onlyYearMonthDay] = [activity];
      }
    });
    return mapToReturn;
  }
}

class CheckmarkGoal {
  String id;
  ActionType actionType;
  DateTime startDate;
  DateTime endDate;
  int daysPerWeek;
  List<DateTime> doneDates;

  CheckmarkGoal(
      {String? id,
      required this.actionType,
      required this.startDate,
      required this.endDate,
      required this.daysPerWeek,
      this.doneDates = const <DateTime>[]})
      : id = id ?? Uuid().v1();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'goalActionTypeName': actionType.name,
      'goalStartDate': startDate.toString(),
      'goalEndDate': endDate.toString(),
      'goalDaysPerWeek': daysPerWeek,
      'doneDates':
          doneDates.map((e) => json.encode(e.toString())).toList().toString(),
    };
  }

  factory CheckmarkGoal.fromMap(Map<String, dynamic> map) {
    return CheckmarkGoal(
      id: map["id"].toString(),
      actionType: map["goalActionTypeName"].toString().toActionType(),
      startDate: DateTime.parse(map["goalStartDate"].toString()),
      endDate: DateTime.parse(map["goalEndDate"].toString()),
      daysPerWeek: map["goalDaysPerWeek"],
      doneDates: (json.decode(map["doneDates"].toString()) as List)
          .map((date) => DateTime.parse(date.toString()))
          .toList(),
    );
  }

  bool isDateDone(DateTime date) => doneDates.containsDate(date);

  void addDoneDate(DateTime date) => doneDates.add(date);

  int get weeksUntilEndDateFromNow =>
      (endDate.difference(DateTime.now().onlyYearMonthDay).inDays / 7).floor();

  List<int> doneDaysOfWeekFromWeekNr(int weekOfYear) {
    final List<int> _listToReturn = [];
    doneDates.forEach((e) {
      if (e.weekOfYear == weekOfYear) _listToReturn.add(e.weekday);
    });
    return _listToReturn;
  }

  void removeDoneDate(DateTime date) =>
      doneDates.removeWhere((d) => d.isSameDate(date));
}

enum GoalTypeFormats { checkMark, typing }

enum GoalFrequencyFormats { perDay, perWeek, inTotal }
