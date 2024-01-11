import 'package:flutter/material.dart';

import '../models/activity.dart';
import '../models/unit.dart';

final List<ActivityType> kAllActivityTypes = [
  ActivityType(
      name: "Cykling",
      possibleUnits: [Units.kilometer, Units.hours, Units.minutes],
      image: const Icon(Icons.directions_bike_outlined)),
  ActivityType(
      name: "Armhævning",
      possibleUnits: [Units.unitLess],
      image: const Icon(Icons.fitness_center)),
  ActivityType(
      name: "Læsning",
      possibleUnits: [Units.minutes, Units.hours],
      image: const Icon(Icons.chrome_reader_mode_outlined)),
  ActivityType(
      name: "Squats",
      possibleUnits: [Units.unitLess],
      image: const Icon(Icons.chair_alt)),
  ActivityType(
      asActivity: false,
      name: "Ingen Slik",
      possibleUnits: [Units.unitLess],
      image: const Icon(Icons.flag)),
  ActivityType(
      asActivity: false,
      name: "Ingen Rød Kød",
      possibleUnits: [Units.unitLess],
      image: const Icon(Icons.no_food)),
  ActivityType(
      asActivity: false,
      name: "Vegetar",
      possibleUnits: [Units.unitLess],
      image: const Icon(Icons.breakfast_dining)),
  ActivityType(
      name: "Dummy",
      possibleUnits: [Units.unitLess],
      image: const Placeholder()),
];
