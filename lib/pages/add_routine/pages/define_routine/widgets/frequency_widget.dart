import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:productivity_app/pages/add_routine/pages/define_routine/widgets/add_extra_goal_dialog.dart';

class ChooseFrequency extends StatelessWidget {
  const ChooseFrequency({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(flex: 1, child: Text("Indtastning hver")),
        Expanded(
            flex: 2,
            child: MyValueChanger(
              handleValueChange: (int newVal) => debugPrint(newVal.toString()),
            ))
      ],
    );
  }
}
