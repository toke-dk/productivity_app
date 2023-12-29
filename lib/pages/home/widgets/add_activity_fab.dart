import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:productivity_app/models/activity.dart';
import 'package:productivity_app/pages/choose_activity/choose_activity.dart';

class AddActivitiesFAB extends StatelessWidget {
  const AddActivitiesFAB({super.key, required this.onActivityComplete});

  final Function(Activity activity) onActivityComplete;

  SpeedDialChild makeAccordingDial(
    BuildContext context, {
    required bool isTask,
  }) {
    return SpeedDialChild(
        shape: const CircleBorder(),
        elevation: 0,
        labelWidget: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: isTask ? const Text("Opgave") : const Text("Aktivitet"),
        ),
        child: isTask ? const Icon(Icons.task_alt) : const Icon(Icons.task),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChooseActivityScreen(isTask: isTask, onActivityComplete: onActivityComplete,)));
        });
  }

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close,
      spaceBetweenChildren: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      children: [
        makeAccordingDial(context, isTask: true),
        makeAccordingDial(context, isTask: false)
      ],
    );
  }
}
