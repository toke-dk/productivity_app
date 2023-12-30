import 'package:flutter/material.dart';

import '../models/activity.dart';
import '../models/unit.dart';

final List<ActivityType> kAllActivityTypes = [
  ActivityType(
      name: "Cykling",
      possibleUnits: [Units.kilometer, Units.hours, Units.minutes],
      image: Icon(Icons.directions_bike_outlined)),
  ActivityType(
      name: "Armhævning",
      possibleUnits: [Units.unitLess],
      image: Icon(Icons.fitness_center)),
  ActivityType(
      name: "Læsning",
      possibleUnits: [Units.minutes, Units.hours],
      image: Icon(Icons.chrome_reader_mode_outlined)),
  ActivityType(
      name: "Dummy", possibleUnits: [Units.unitLess], image: Placeholder())
];
