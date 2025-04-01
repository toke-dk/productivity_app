import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:productivity_app/models/user.dart';
import 'package:productivity_app/pages/home/home.dart';
import 'package:productivity_app/pages/introduction_screens/main_intro_screens.dart';
import 'package:productivity_app/pages/my_splash_screen.dart';
import 'package:productivity_app/services/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  DataBaseService _databaseService = DataBaseService();
  await _databaseService.initDatabase();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String makeWelcomeMessage(DateTime date) {
    if (date.hour > 4 && date.hour <= 10) {
      return "God morgen";
    } else if (date.hour > 10 && date.hour <= 11) {
      return "God formiddag";
    } else if (date.hour > 11 && date.hour <= 16) {
      return "God eftermiddag";
    } else
      return "God aften";
  }

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool? _isFirstVisit;

  Future<void> _setFirstVisit() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setBool("isFirstVisit", true);
    setState(() {
      _isFirstVisit = true;
    });
    print(_isFirstVisit);
  }

  Future<void> _setNotFirstVisit() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setBool("isFirstVisit", false);
    setState(() {
      _isFirstVisit = false;
    });
    print(_isFirstVisit);
  }

  Future<void> _saveUserData(UserData userData) async {
    UserDataStorage.saveUserData(userData);
  }

  Future<void> _initFirstVisit() async {
    final SharedPreferences prefs = await _prefs;
    bool prefsIsFirstVisit = await prefs.getBool("isFirstVisit") ?? true;
    setState(() {
      _isFirstVisit = prefsIsFirstVisit;
    });
    print(_isFirstVisit);
  }

  @override
  void initState() {
    // kDebugMode ? _setFirstVisit() : null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initFirstVisit();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Min Rutine',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent),
        useMaterial3: true,
      ),
      home: mainContent,
    );
  }

  Widget get mainContent {
    if (_isFirstVisit == null) {
      return Scaffold(body: Center(child: const Text("Loading...")));
    }
    if (_isFirstVisit == true) {
      print("visit true:");
      return MyIntroScreens(
        onIntroComplete: (_context, nick, first, last) async {
          _saveUserData(
              UserData(nickName: nick, firstName: first, lastName: last));
          _setNotFirstVisit();
          Navigator.of(_context).popUntil((route) => route.isFirst);
        },
      );
    }
    return FutureBuilder<UserData?>(
        future: UserDataStorage.getUserData,
        builder: (context, AsyncSnapshot<UserData?> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Scaffold(
                  body: Center(child: const Text("Indlæser data...")));
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else
                return MyHomePage(
                  title: "${makeWelcomeMessage(DateTime.now())}",
                  userData: snapshot.data!,
                  editUserData: (UserData newData) {
                    setState(() {
                      _saveUserData(newData);
                    });
                  },
                );
          }
        });
  }
}
