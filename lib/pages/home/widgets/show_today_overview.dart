import 'package:flutter/material.dart';
import 'package:productivity_app/pages/report_page.dart';
import 'package:productivity_app/shared/myThemedBoxShadow.dart';
import 'package:productivity_app/widgets/display_activity_type.dart';
import '../../../models/activity.dart';
import 'distribution_bar.dart';

class ShowTodayOverview extends StatelessWidget {
  const ShowTodayOverview({super.key, required this.actionTypeCounts});

  final Map<ActionType, int> actionTypeCounts;

  int countAllActions (Map<ActionType, int> actionTypeCounts) {
    int val = 0;
    actionTypeCounts.forEach((key, value) {val+=value;});
    return val;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          boxShadow: [kMyThemedBoxShadow],
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(14)),
      child: actionTypeCounts.isNotEmpty
          ? InkWell(
            onTap: () {
              print("tap");
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => ReportPage()));
              },
            child: Column(
                children: [
                  _QuickStatsText(amountOfTotalActions: countAllActions(actionTypeCounts),),
                  const SizedBox(
                    height: 20,
                  ),
                  DistributionBar(
                    actionTypeCounts: actionTypeCounts,
                  ),
                ],
              ),
          )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Ingen handlinger endnu",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
    );
  }
}

class _QuickStatsText extends StatelessWidget {
  const _QuickStatsText({required this.amountOfTotalActions});
  final int amountOfTotalActions;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amountOfTotalActions.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const Text(
                  " handlinger",
                ),
              ],
            ),
            // const Row(
            //   children: [
            //     Text(
            //       "y aktiviteter",
            //       style: TextStyle(fontWeight: FontWeight.bold),
            //     ),
            //     Text(" mere end sidste uge"),
            //   ],
            // )
          ],
        ),
        // DropdownButton(
        //     underline: const SizedBox(),
        //     items: const [
        //       DropdownMenuItem(child: Text("Aktivitet")),
        //     ],
        //     onChanged: null)
      ],
    );
  }
}
