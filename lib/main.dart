import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:productivity_app/models/user.dart';
import 'package:productivity_app/pages/home/home.dart';
import 'package:productivity_app/pages/introduction_screens/main_intro_screens.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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

  late Future<bool> _isFirstVisit;

  Future<void> _setFirstVisit() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      _isFirstVisit =
          prefs.setBool("isFirstVisit", true).then((bool success) => true);
    });
  }

  Future<void> _setNotFirstVisit() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      _isFirstVisit =
          prefs.setBool("isFirstVisit", false).then((bool success) => false);
    });
  }

  Future<void> _saveUserData(UserData userData) async {
    UserDataStorage.saveUserData(userData);
  }

  @override
  void initState() {
    kDebugMode ? _setFirstVisit() : null;
    _isFirstVisit = _prefs.then(
        (SharedPreferences prefs) => prefs.getBool("isFirstVisit") ?? true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Productivity app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent),
        useMaterial3: true,
      ),
      home: FutureBuilder<bool>(
          future: _isFirstVisit,
          builder: (context, AsyncSnapshot<bool> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Scaffold(body: Center(child: const Text("Loading...")));
              case ConnectionState.active:
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final bool isFirstVisit = snapshot.data!;
                  return isFirstVisit
                      ? MyIntroScreens(
                          onIntroComplete: (nick, first, last) async {
                            _saveUserData(UserData(
                                nickName: nick,
                                firstName: first,
                                lastName: last));
                            _setNotFirstVisit();
                            Navigator.pop(context);
                          },
                        )
                      : FutureBuilder<UserData?>(
                          future: UserDataStorage.getUserData,
                          builder:
                              (context, AsyncSnapshot<UserData?> snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.none:
                              case ConnectionState.waiting:
                                return Scaffold(
                                    body: Center(
                                        child: const Text("Loading...")));
                              case ConnectionState.active:
                              case ConnectionState.done:
                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else
                                  return MyHomePage(
                                    title:
                                        "${makeWelcomeMessage(DateTime.now())}",
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
          }),
    );
  }
}
