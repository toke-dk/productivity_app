import 'package:flutter/material.dart';
import 'package:productivity_app/models/activity.dart';

class ChooseActivityScreen extends StatelessWidget {
  const ChooseActivityScreen({super.key, required this.isTask});

  final bool isTask;
  final double horizontalPadding = 15;

  @override
  Widget build(BuildContext context) {
    final List<ActivityType> allActivityTypes = kActivityTypes;

    const double space = 10;
    const int amount = 5;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Container(
          child: TextField(
            decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 10),
                prefixIcon: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                isDense: true,
                border: OutlineInputBorder(),
                hintText: "Søg efter aktivitet"),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Text("Anbefalet"),
                  ),
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    padding: EdgeInsets.all(10),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: List.generate(
                        2,
                        (index) => ActivityCard(
                              activityType: allActivityTypes[index],
                            )),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Text("Alle"),
                  ),
                  GridView.count(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    padding: EdgeInsets.all(10),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: List.generate(
                        allActivityTypes.length,
                        (index) => ActivityCard(
                              activityType: allActivityTypes[index],
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

class ActivityCard extends StatelessWidget {
  const ActivityCard({super.key, required this.activityType});

  final ActivityType activityType;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 20,
            child: ClipOval(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: activityType.image,
            )),
          ),
          SizedBox(
            height: 8,
          ),
          Text(activityType.name)
        ],
      ),
    );
  }
}
