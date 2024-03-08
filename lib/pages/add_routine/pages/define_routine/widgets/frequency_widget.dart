import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:productivity_app/pages/add_routine/pages/define_routine/widgets/add_extra_goal_dialog.dart';

import '../define_routine.dart';


enum _TimeUnit {
  day("dag"),
  week("uge"),
  month('måned'),
  year('år');

  const _TimeUnit(this.translatedName);

  final String translatedName;
}


class ChooseFrequency extends StatefulWidget {
  const ChooseFrequency({super.key});

  @override
  State<ChooseFrequency> createState() => _ChooseFrequencyState();
}

class _ChooseFrequencyState extends State<ChooseFrequency> {

  _TimeUnit selectedFrequency = _TimeUnit.day;


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Indtastning hver"),
        SizedBox(height: 10,),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
                flex: 2,
                child: MyValueChanger(
                  handleValueChange: (int newVal) => debugPrint(newVal.toString()),
                )),
            Expanded(
              flex: 1,
              child: FittedBox(
                child: DropdownMenu(
                    initialSelection: _TimeUnit.day,
                    onSelected: (_TimeUnit? frequency) {
                      if (frequency != null)
                        setState(() {
                          selectedFrequency = frequency;
                        });
                    },
                    dropdownMenuEntries: _TimeUnit.values
                        .map((e) =>
                        DropdownMenuEntry(value: e, label: e.translatedName))
                        .toList()),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
