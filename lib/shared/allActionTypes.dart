import 'package:flutter/material.dart';

import '../models/activity.dart';
import '../models/unit.dart';

final List<ActionType> kAllActionTypes = [
  ActionType(
      name: "Cykling",
      possibleUnits: [Units.kilometer, Units.hours, Units.minutes],
      image: const Icon(Icons.directions_bike_outlined)),
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
      image: const Icon(Icons.chair_alt)),
  ActionType(
      asActivity: false,
      name: "Ingen Slik",
      possibleUnits: [Units.unitLess],
      image: const Icon(Icons.flag)),
  ActionType(
      asActivity: false,
      name: "Ingen Rød Kød",
      possibleUnits: [Units.unitLess],
      image: const Icon(Icons.no_food)),
  ActionType(
      asActivity: false,
      name: "Vegetar",
      possibleUnits: [Units.unitLess],
      image: const Icon(Icons.breakfast_dining)),
  ActionType(
      name: "Dummy",
      possibleUnits: [Units.unitLess],
      image: const Placeholder()),
];
