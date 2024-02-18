import 'package:flutter/material.dart';
import 'package:productivity_app/pages/introduction_screens/page_one.dart';
import 'package:productivity_app/pages/introduction_screens/page_two.dart';

class MyIntroScreens extends StatefulWidget {
  const MyIntroScreens({super.key});

  @override
  State<MyIntroScreens> createState() => _MyIntroScreensState();
}

class _MyIntroScreensState extends State<MyIntroScreens> {
  int currentScreenIndex = 0;

  @override
  Widget build(BuildContext context) {
    return PageOneIntroScreen(
      nextPagePressed: () {
        setState(() {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => PageTwoIntroScreen()));
        });
      },
    );
  }
}
