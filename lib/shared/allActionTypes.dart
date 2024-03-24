import 'package:flutter/material.dart';
import '../models/activity.dart';
import '../models/unit.dart';

final List<ActionType> kAllActionTypes = [
  ActionType(
      name: "Cykling",
      possibleUnits: [Units.kilometer, Units.hours, Units.minutes],
      image: const Icon(
        Icons.directions_bike_outlined,
        color: Colors.white,
      )),
  ActionType(
      name: "Løb",
      possibleUnits: [Units.kilometer, Units.hours, Units.minutes],
      image: const Icon(
        Icons.directions_run,
        color: Colors.white,
      )),
  ActionType(
      name: "Armhævning",
      possibleUnits: [Units.unitLess],
      image: const Icon(
        Icons.fitness_center,
        color: Colors.white,
      )),
  ActionType(
      name: "Læsning",
      possibleUnits: [Units.minutes, Units.hours],
      image: const Icon(
        Icons.chrome_reader_mode_outlined,
        color: Colors.white,
      )),
  ActionType(
      name: "Squats",
      possibleUnits: [Units.unitLess],
      image: const Icon(
        Icons.snowboarding,
        color: Colors.white,
      )),
  ActionType(
      asActivity: false,
      name: "Ingen Slik",
      image: const Icon(
        Icons.health_and_safety,
        color: Colors.white,
      )),
  ActionType(
      asActivity: false,
      name: "Ingen Rød Kød",
      image: const Icon(Icons.no_food, color: Colors.white,)),
  ActionType(
      name: "Vinterbad",
      image: Icon(
        Icons.water,
        color: Colors.white,
      ),
      asActivity: false),
  ActionType(
      name: "Fod øvelser",
      image: Icon(
        Icons.snowshoeing,
        color: Colors.white,
      ),
      asActivity: false),
  ActionType(
      name: "Ryd op",
      image: Icon(
        Icons.dry_cleaning,
        color: Colors.white,
      ),
      asActivity: false),
];
