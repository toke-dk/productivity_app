import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:productivity_app/models/activity.dart';
import 'package:productivity_app/widgets/MyThemeButton.dart';
import 'package:productivity_app/widgets/display_activity_type.dart';

class ActivityReceipt extends StatelessWidget {
  const ActivityReceipt({super.key, required this.activityType});

  final ActivityType activityType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 60),
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    width: 200,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              offset: const Offset(5, 5),
                              blurRadius: 11),
                        ],
                        color: Colors.grey[100],
                        borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(20))),
                    child: SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DisplayActivityType(activityType: activityType),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Fuldført",
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Icon(
                            Icons.check_circle_outline_rounded,
                            size: 100,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Af",
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Navn",
                          )
                        ],
                      ),
                    ),
                  )
                      .animate(target: 1)
                      .moveY(
                          begin: -400,
                          duration: 1.5.seconds,
                          curve: Curves.easeOutExpo)
                      .then(),
                ),
              ],
            ),
            Spacer(),
            MyThemeButton(
              onTap: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              trailingIcon: Icons.arrow_forward,
              labelText: "Færdiggør",
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
