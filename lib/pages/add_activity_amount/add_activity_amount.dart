import 'package:flutter/material.dart';
import 'package:productivity_app/models/activity.dart';

class AddActivityAmount extends StatefulWidget {
  const AddActivityAmount({super.key, required this.activityType});

  final ActivityType activityType;

  @override
  State<AddActivityAmount> createState() => _AddActivityAmountState();
}

class _AddActivityAmountState extends State<AddActivityAmount> {
  String typedString = "";

  bool isStringAComma(String val) {
    return val == ",";
  }

  bool doesStringContainComma(String val) {
    return val.contains(",");
  }

  bool isStringAZero(String val) {
    return val == "0";
  }

  bool isCommaInThisPosition(String val, int position) {
    return val.split("").reversed.join("").indexOf(",") == position;
  }

  bool isStringThisLength(String val, int length) {
    return val.length == length;
  }

  bool isStringEmpty(String val) {
    return val == "";
  }

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              Row(
                children: [
                  Text(
                    widget.activityType.possibleUnits[0].name,
                    style: const TextStyle(color: Colors.transparent),
                  ),
                  !isStringEmpty(typedString)
                      ? Text(
                          typedString.toString(),
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
                  widget.activityType.possibleUnits[0] != Units.unitLess
                      ? Text(widget.activityType.possibleUnits[0].name)
                      : const SizedBox(),
                ],
              ),
              !isStringEmpty(typedString)
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          typedString =
                              typedString.substring(0, typedString.length - 1);
                        });
                      },
                      icon: const Icon(Icons.arrow_back))
                  : const IconButton(
                      disabledColor: Colors.transparent,
                      onPressed: null,
                      icon: Icon(Icons.arrow_back),
                    )
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
                // the "næste" button can not be pressed
                onTap: index != 11
                    ? () {
                        // critera for the board
                        if (!((isStringAComma(currentString) &&
                                doesStringContainComma(typedString)) ||
                            (isStringAZero(currentString) &&
                                isStringAZero(typedString)) ||
                            (isCommaInThisPosition(typedString, 2)) ||
                            (!isStringAComma(currentString) &&
                                !doesStringContainComma(typedString) &&
                                isStringThisLength(typedString, 3)))) {
                          setState(() {
                            if (isStringAComma(currentString) &&
                                isStringEmpty(typedString)) {
                              typedString = "0,";
                            } else if (isStringAZero(typedString) &&
                                !isStringAComma(currentString)) {
                              typedString = currentString;
                            } else {
                              typedString = "$typedString$currentString";
                            }
                          });
                        }
                        ;
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
