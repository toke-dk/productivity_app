import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as Foundation;
import '../models/activity.dart';
import '../models/unit.dart';

final List<ActionType> kAllActionTypes = [
  ActionType(
      name: "Cykling",
      possibleUnits: [Units.kilometer, Units.hours, Units.minutes],
      image: const Icon(Icons.directions_bike_outlined)),
  ActionType(
      name: "Løb",
      possibleUnits: [Units.kilometer, Units.hours, Units.minutes],
      image: const Icon(Icons.directions_run)),
  ActionType(
      name: "Armhævning",
      possibleUnits: [Units.unitLess],
      image: const Icon(Icons.fitness_center)),
  ActionType(
      name: "Læsning",
      possibleUnits: [Units.minutes, Units.hours],
      image: const Icon(Icons.chrome_reader_mode_outlined)),
  ActionType(
      name: "Squats",
      possibleUnits: [Units.unitLess],
      image: const Icon(Icons.snowboarding)),
  ActionType(
      asActivity: false,
      name: "Ingen Slik",
      image: const Icon(Icons.health_and_safety)),
  ActionType(
      asActivity: false,
      name: "Ingen Rød Kød",
      image: const Icon(Icons.no_food)),
  ActionType(name: "Vinterbad", image: Icon(Icons.water), asActivity: false),
  ActionType(
      name: "Fod øvelser", image: Icon(Icons.snowshoeing), asActivity: false),
  ActionType(
      name: "Ryd op", image: Icon(Icons.dry_cleaning), asActivity: false),
];
