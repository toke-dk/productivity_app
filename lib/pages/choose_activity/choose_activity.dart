import 'package:flutter/material.dart';
import 'package:productivity_app/models/activity.dart';
import 'package:productivity_app/pages/add_activity_amount/add_activity_amount.dart';
import 'package:productivity_app/pages/choose_activity/widgets/activity_card.dart';
import 'package:productivity_app/pages/choose_activity/widgets/search_appbar.dart';
import 'package:productivity_app/pages/complete_task_page.dart';
import 'package:provider/provider.dart';

class ChooseActivityScreen extends StatelessWidget {
  const ChooseActivityScreen({super.key, required this.isTask});

  final bool isTask;
  final double horizontalPadding = 15;

  @override
  Widget build(BuildContext context) {
    final List<ActivityType> allActivityTypes =
        Provider.of<ActivityProvider>(context).getAllActivityTypes;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const MySearchAppBar(),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: const Text("Anbefalet"),
                  ),
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    padding: const EdgeInsets.all(10),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: List.generate(
                        2,
                        (index) => ActivityCard(
                              activityType: allActivityTypes[index],
                              onTap: (ActivityType activityType) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => isTask
                                            ? CompleteTaskPage(
                                                activityType: activityType,
                                              )
                                            : AddActivityAmount(
                                                activityType: activityType)));
                              },
                            )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: const Text("Alle"),
                  ),
                  GridView.count(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    padding: const EdgeInsets.all(10),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: List.generate(
                        allActivityTypes.length,
                        (index) => ActivityCard(
                              activityType: allActivityTypes[index],
                              onTap: (ActivityType activityType) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => isTask
                                            ? CompleteTaskPage(
                                                activityType: activityType,
                                              )
                                            : AddActivityAmount(
                                                activityType: activityType)));
                              },
                            )),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
