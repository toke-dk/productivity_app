import 'package:flutter/material.dart';
import 'package:productivity_app/models/activity.dart';

class AddActivityAmount extends StatelessWidget {
  const AddActivityAmount({super.key, required this.activityType});

  final ActivityType activityType;

  @override
  Widget build(BuildContext context) {
    int? typedNumber;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tilføj aktivitet"),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Row(
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
              const SizedBox(
                width: 8,
              ),
              Text(activityType.name)
            ],
          ),
          const Spacer(
            flex: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                activityType.possibleUnits[0].name,
                style: const TextStyle(color: Colors.transparent),
              ),
              typedNumber != null
                  ? Text(
                      typedNumber.toString(),
                      style: const TextStyle(fontSize: 40),
                    )
                  : const SizedBox(),
              Container(
                height: 40,
                width: 3,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(activityType.possibleUnits[0].name)
            ],
          ),
          const Spacer(
            flex: 1,
          ),
          GridView.count(
            childAspectRatio: (2 / 1),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            shrinkWrap: true,
            crossAxisCount: 3,
            children: List.generate(12, (index) {

              Widget currentChild;
              String currentString = index.toString();

              if (index == 9) {
                currentString = ",";
              } else if (index == 10) {
                currentString = "0";
              }

              currentChild = index != 11 ? Text(currentString) : MaterialButton(
                onPressed: () {},
                color: Theme.of(context).primaryColor,
                child: Text(
                  "Næste",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary),
                ),
              );

              return InkWell(
                onTap: index != 11 ? () {} : null,
                child:
                    Container(alignment: Alignment.center, child: currentChild),
              );
            }),
          )
        ],
      ),
    );
  }
}
