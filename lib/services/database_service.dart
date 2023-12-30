import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:productivity_app/models/activity.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

/// Documentation: https://docs.flutter.dev/cookbook/persistence/sqlite
/// Medium example: https://suragch.medium.com/simple-sqflite-database-example-in-flutter-e56a5aaa3f91
/// Github example: https://github.com/thecodexhub/flutter-sqflite-example/blob/main/lib/services/database_service.dart
class DataBaseService {
  static const String _databaseName = 'productivity_data.dart';
  static const int _databaseVersion = 1;

  static const String tableName = "activities";

  static const String columnId = "id";
  static const String columnActivityTypeName = "activityTypeName";
  static const String columnChosenUnit = "chosenUnit";
  static const String columnAmount = "amount";
  static const String columnDateCompleted = "dateCompleted";

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
        CREATE TABLE $tableName(
        $columnId INTEGER PRIMARY KEY, 
        $columnActivityTypeName TEXT, 
        $columnAmount DOUBLE, 
        $columnChosenUnit TEXT, 
        $columnDateCompleted DATETIME
        )""");
  }

  Future<void> addActivity(Activity activity) async {
    await _db.insert(tableName, activity.toMap());
  }

  Future<List<Activity>> getActivities(BuildContext context) async {
    final List<Map<String, dynamic>> maps = await _db.query(tableName);
    return List.generate(maps.length, (index) => Activity.fromMap(maps[index]));
  }

  Future<void> deleteAll() async {
    await _db.rawDelete("DELETE FROM $tableName");
  }

  /// Task
}
