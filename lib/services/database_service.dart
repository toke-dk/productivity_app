import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:productivity_app/models/activity.dart';
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

  // Singleton pattern
  static final DataBaseService _dataBaseService = DataBaseService._internal();

  factory DataBaseService() => _dataBaseService;

  DataBaseService._internal();

  late Database _db;

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
  }

  Future<void> addActivity(Activity activity) async {
    await _db.insert(tableActivityName, activity.toMap());
  }

  Future<void> deleteAllActivities() async {
    await _db.rawDelete("DELETE FROM $tableActivityName");
  }

  Future<List<Activity>> getActivities() async {
    final List<Map<String, dynamic>> maps = await _db.query(tableActivityName);
    return List.generate(maps.length, (index) => Activity.fromMap(maps[index]));
  }

  /// Task

  Future<void> deleteTasksTable() async {
    await _db.execute("DROP TABLE $tableTaskName");
  }

  Future<void> deleteAllTasks() async {
    await _db.rawDelete("DELETE FROM $tableTaskName");
  }

  Future<void> addTask(Task task) async {
    await _db.insert(tableTaskName, task.toMap());
  }

  Future<List<Task>> getTasks() async {
    final List<Map<String,dynamic>> maps = await _db.query(tableTaskName);
    return List.generate(maps.length, (index) => Task.fromMap(maps[index]));
  }

}
