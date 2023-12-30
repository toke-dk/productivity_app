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
        home: MyHomePage(title: 'Velkommen'),
      ),
    );
  }
}
