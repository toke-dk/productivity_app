import 'package:flutter/material.dart';
import 'package:productivity_app/pages/add_goal/add_goal_page.dart';
import 'package:productivity_app/widgets/MyThemeButton.dart';

import '../../../models/goal.dart';

class ShowGoalsWidget extends StatelessWidget {
  const ShowGoalsWidget({super.key, required this.goals});

  final List<Goal> goals;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.grey[100]),
      child: goals.isEmpty
          ? Column(
              children: [
                Text("Du har ikke sat et mål endnu"),
                SizedBox(
                  height: 20,
                ),
                MyThemeButton(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddGoalPage()));
                  },
                  labelText: "Angiv mål!",
                )
              ],
            )
          : Text("Should desplay goal here"),
    );
  }
}
