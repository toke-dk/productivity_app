import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:productivity_app/pages/choose_activity/choose_activity.dart';

class AddActivitiesFAB extends StatelessWidget {
  const AddActivitiesFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close,
      spaceBetweenChildren: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      children: [
        SpeedDialChild(
            shape: const CircleBorder(),
            elevation: 0,
            labelWidget: const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Text("Opgave"),
            ),
            child: const Icon(Icons.task_alt),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const ChooseActivityScreen(isTask: true)));
            }),
        SpeedDialChild(
            shape: const CircleBorder(),
            elevation: 0,
            labelWidget: const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Text("Aktivitet"),
            ),
            child: const Icon(Icons.task),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const ChooseActivityScreen(isTask: false)));
            }),
      ],
    );
  }
}
