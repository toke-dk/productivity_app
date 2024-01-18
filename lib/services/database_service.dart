import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:productivity_app/models/activity.dart';
import 'package:productivity_app/models/goal.dart';
import 'package:productivity_app/models/task.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

/// Documentation: https://docs.flutter.dev/cookbook/persistence/sqlite
/// Medium example: https://suragch.medium.com/simple-sqflite-database-example-in-flutter-e56a5aaa3f91
/// Github example: https://github.com/thecodexhub/flutter-sqflite-example/blob/main/lib/services/database_service.dart
class DataBaseService {
  static const String _databaseName = 'productivity_data.dart';
  static const int _databaseVersion = 1;

  /// Activity
  static const String tableActivityName = "activities";
  static const String columnId = "id";
  static const String columnActivityTypeName = "activityTypeName";
  static const String columnChosenUnit = "chosenUnit";
  static const String columnAmount = "amount";
  static const String columnDateCompleted = "dateCompleted";

  /// Task
  static const String tableTaskName = "tasks";

  /// Goal
  static const String tableAmountGoalName = "amountGoals";
  static const String tableCheckmarkGoalName = "checkmarkGoals";
  static const String columnGoalId = "id";
  static const String columnGoalActionTypeName = "goalActionTypeName";
  static const String columnGoalStartDate = "goalStartDate";
  static const String columnGoalEndDate = "goalEndDate";

  // CheckmarkGoal
  static const String columnGoalDaysPerWeek = "goalDaysPerWeek";

  // AmountGoal
  static const String columnGoalAmountGoal = "amountGoal";
  static const String columnGoalFrequencyFormat = "goalFrequencyFormat";
  static const String columnGoalChosenUnit = "goalChosenUnit";
  static const String columnGoalCompletedActivities = "doneAmountActivities";

  /// Singleton pattern
  static final DataBaseService _dataBaseService = DataBaseService._internal();

  factory DataBaseService() => _dataBaseService;

  DataBaseService._internal();

  Database? _db;

  Future<void> initDatabase() async {
    final path = join(await getDatabasesPath(), _databaseName);
    _db = await openDatabase(path,
        onCreate: _onCreate, version: _databaseVersion);
  }

  /// Activity
  Future<void> _onCreate(Database db, int version) async {
    await db.execute("""
        CREATE TABLE $tableActivityName(
        $columnId INTEGER PRIMARY KEY, 
        $columnActivityTypeName TEXT, 
        $columnAmount DOUBLE, 
        $columnChosenUnit TEXT, 
        $columnDateCompleted DATETIME
        )""");

    await db.execute("""
        CREATE TABLE $tableTaskName(
        $columnId INTEGER PRIMARY KEY, 
        $columnActivityTypeName TEXT, 
        $columnDateCompleted TEXT
        )""");

    await db.execute("""
        CREATE TABLE $tableAmountGoalName(
        $columnGoalId INTEGER PRIMARY KEY, 
        $columnGoalActionTypeName TEXT, 
        $columnGoalStartDate TEXT,
        $columnGoalEndDate TEXT,
        $columnGoalFrequencyFormat TEXT,
        $columnGoalChosenUnit TEXT,
        $columnGoalAmountGoal, INTEGER,
        $columnGoalCompletedActivities, TEXT
        )""");

    await db.execute("""
        CREATE TABLE $tableCheckmarkGoalName(
        $columnGoalId INTEGER PRIMARY KEY, 
        $columnGoalActionTypeName TEXT, 
        $columnGoalStartDate TEXT,
        $columnGoalEndDate TEXT,
        $columnGoalDaysPerWeek INTEGER
        )""");
  }

  Future<void> addActivity(Activity activity) async {
    await _db!.insert(tableActivityName, activity.toMap());
  }

  Future<void> deleteAllActivities() async {
    await _db!.rawDelete("DELETE FROM $tableActivityName");
  }

  Future<List<Activity>> getActivities() async {
    final List<Map<String, dynamic>> maps = await _db!.query(tableActivityName);
    return List.generate(maps.length, (index) => Activity.fromMap(maps[index]));
  }

  /// Task

  Future<void> deleteTasksTable() async {
    await _db!.execute("DROP TABLE $tableTaskName");
  }

  Future<void> deleteAllTasks() async {
    await _db!.rawDelete("DELETE FROM $tableTaskName");
  }

  Future<void> addTask(Task task) async {
    await _db!.insert(tableTaskName, task.toMap());
  }

  Future<List<Task>> getTasks() async {
    final List<Map<String, dynamic>> maps = await _db!.query(tableTaskName);
    return List.generate(maps.length, (index) => Task.fromMap(maps[index]));
  }

  /// Goal
  Future<void> addAmountGoal(AmountGoal goal) async {
    await _db!.insert(tableAmountGoalName, goal.toMap());
  }

  Future<void> addDoneAmountActivity(AmountGoal goal, DoneAmountActivity activity) async {
    //adds the done amount activity
    goal.addDoneAmountActivity(activity);

    // TODO: it should be the right args
    await _db!.update(tableAmountGoalName, goal.toMap(), where: "$columnGoalId = ?", whereArgs: [0]);
  }

  Future<List<AmountGoal>> getAmountGoals() async {
    final List<Map<String, dynamic>> maps = await _db?.query(tableAmountGoalName) ?? [];
    return List.generate(maps.length, (index) => AmountGoal.fromMap(maps[index]));
  }

  Future<void> addCheckmarkGoal(CheckmarkGoal goal) async {
    await _db!.insert(tableCheckmarkGoalName, goal.toMap());
  }

  Future<List<CheckmarkGoal>> getCheckmarkGoal() async {
    final List<Map<String, dynamic>> maps = await _db?.query(tableCheckmarkGoalName) ?? [];
    return List.generate(maps.length, (index) => CheckmarkGoal.fromMap(maps[index]));
  }
}
