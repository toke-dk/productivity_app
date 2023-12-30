import 'package:flutter/material.dart';
import 'package:productivity_app/widgets/display_activity_type.dart';
import '../../../models/activity.dart';
import 'distribution_bar.dart';

class ShowTodayOverview extends StatelessWidget {
  const ShowTodayOverview({super.key, required this.activityTypeCounts});

  final Map<ActivityType, int> activityTypeCounts;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            padding: const EdgeInsets.all(13),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(14)),
            child: activityTypeCounts.isNotEmpty
                ? Column(
                    children: [
                      const _QuickStatsText(),
                      const SizedBox(
                        height: 20,
                      ),
                      DistributionBar(
                        activityTypeCounts: activityTypeCounts,
                      ),
                    ],
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        "Ingen aktiviteter i dag",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  )),
      ],
    );
  }
}

class _QuickStatsText extends StatelessWidget {
  const _QuickStatsText({super.key});

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
                  "X",
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const Text(
                  " aktiviteter",
                ),
              ],
            ),
            const Row(
              children: [
                Text(
                  "y aktiviteter",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(" mere end sidste uge"),
              ],
            )
          ],
        ),
        DropdownButton(
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(child: Text("Aktivitet")),
            ],
            onChanged: null)
      ],
    );
  }
}
