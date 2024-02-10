import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:productivity_app/models/activity.dart';
import 'package:productivity_app/models/unit.dart';
import 'package:productivity_app/pages/home/home.dart';
import 'package:productivity_app/services/database_service.dart';
import 'package:productivity_app/widgets/MyThemeButton.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  String makeWelcomeMessage(DateTime date) {
    if (date.hour> 4 && date.hour <= 10) {
      return "God morgen";
    } else if (date.hour > 10 && date.hour <= 11) {
      return "God formiddag";
    } else if (date.hour > 11 && date.hour <= 16) {
      return "God eftermiddag";
    } else return "God aften";
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ActivityProvider())
      ],
      child: MaterialApp(
        title: 'Productivity app',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent),
          useMaterial3: true,
        ),
        home: MyHomePage(title: "${makeWelcomeMessage(DateTime.now())}"),
      ),
    );
  }
}
