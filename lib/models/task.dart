import 'package:productivity_app/models/activity.dart';

class Task {
  ActivityType activityType;
  DateTime dateCompleted;

  Task({required this.activityType, required this.dateCompleted});

  Map<String, dynamic> toMap() {
    return {
      'activityTypeName': activityType.name,
      'dateCompleted': dateCompleted.toString(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
        activityType: map["activityTypeName"].toString().toActivityType(),
        dateCompleted: DateTime.parse(map["dateCompleted"].toString()));
  }
}
