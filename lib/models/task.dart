import 'package:productivity_app/models/activity.dart';

class Task {
  ActivityType activityType;
  DateTime dateCompleted;

  Task({required this.activityType, required this.dateCompleted});
}