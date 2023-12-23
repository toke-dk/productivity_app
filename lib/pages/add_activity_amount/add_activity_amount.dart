import 'package:flutter/material.dart';
import 'package:productivity_app/models/activity.dart';

class AddActivityAmount extends StatefulWidget {
  const AddActivityAmount({super.key, required this.activityType});

  final ActivityType activityType;

  @override
  State<AddActivityAmount> createState() => _AddActivityAmountState();
}

class _AddActivityAmountState extends State<AddActivityAmount> {
  String? typedString;

  @override
  Widget build(BuildContext context) {

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
                  child: widget.activityType.image,
                )),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(widget.activityType.name)
            ],
          ),
          const Spacer(
            flex: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.activityType.possibleUnits[0].name,
                style: const TextStyle(color: Colors.transparent),
              ),
              Text(
                typedString.toString(),
                style: const TextStyle(fontSize: 40),
              ),
              Container(
                height: 40,
                width: 3,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(widget.activityType.possibleUnits[0].name)
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

              currentChild = index != 11
                  ? Text(currentString)
                  : MaterialButton(
                      onPressed: () {},
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        "Næste",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    );

              return InkWell(
                onTap: index != 11
                    ? () {
                        setState(() {
                          typedString = "$typedString$currentString";
                        });
                      }
                    : null,
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
