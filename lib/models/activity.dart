import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:productivity_app/models/unit.dart';
import 'package:productivity_app/shared/extensions/string_extensions.dart';

/// The [ActionType] class describes what type of activities is done

class ActionType {
  String name;
  List<Units>? possibleUnits;
  Color? color;
  Widget image;
  bool asTask;
  bool asActivity;

  ActionType({
    required this.name,
    this.possibleUnits,
    required this.image,
    this.color,
    this.asTask = true,
    this.asActivity = true,
  });
}

class ActionTypeCount {
  int amountDone;
  ActionType actionType;

  ActionTypeCount({required this.amountDone, required this.actionType});
}

class ActionTypeCountDate {
  DateTime date;
  List<ActionTypeCount> actionTypeCounts;

  ActionTypeCountDate({required this.date, required this.actionTypeCounts});
}



