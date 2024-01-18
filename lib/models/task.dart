import 'package:productivity_app/models/activity.dart';
import 'package:productivity_app/shared/extensions/string_extensions.dart';

class Task {
  ActionType actionType;
  DateTime dateCompleted;

  Task({required this.actionType, required this.dateCompleted});

  Map<String, dynamic> toMap() {
    return {
      'activityTypeName': actionType.name,
      'dateCompleted': dateCompleted.toString(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
        actionType: map["activityTypeName"].toString().toActionType(),
        dateCompleted: DateTime.parse(map["dateCompleted"].toString()));
  }
}
