import 'package:flutter/material.dart';
import 'package:productivity_app/pages/introduction_screens/page_one.dart';
import 'package:productivity_app/pages/introduction_screens/page_two.dart';

class MyIntroScreens extends StatelessWidget {
  const MyIntroScreens({super.key, required this.onIntroComplete});

  final Function(String nickName, String? firstName, String? lastName) onIntroComplete;

  @override
  Widget build(BuildContext context) {
    return PageOneIntroScreen(
      nextPagePressed: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PageTwoIntroScreen(
                  onCompletePress: (nick,first,last) => onIntroComplete(nick,first,last),
                )));
      },
    );
  }
}
