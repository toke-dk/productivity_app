import 'package:flutter/material.dart';

import '../models/donation.dart';

final List<Donation> kAllDonations = [
  Donation(name: "Test", valueInKr: 2, dateAdded: DateTime(2024,3,23)),
  Donation(name: "Test2", valueInKr: 31, message: "Should be bronze", dateAdded: DateTime(2024,3,20)),
  Donation(name: "Test3", valueInKr: 100, dateAdded: DateTime(2024,3,10)),
  Donation(name: "Dit navn", valueInKr: 6.9, message: "Din Besked", dateAdded: DateTime(2024, 3, 24)),

];