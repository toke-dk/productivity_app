import 'package:flutter/material.dart';
import 'package:productivity_app/models/activity.dart';
import 'package:productivity_app/pages/activity_receipt.dart';
import 'package:productivity_app/pages/add_activity_amount/widgets/number_board.dart';
import 'package:productivity_app/widgets/display_activity_type.dart';
import 'package:provider/provider.dart';

import '../../models/unit.dart';

class AddActivityAmount extends StatefulWidget {
  const AddActivityAmount({super.key, required this.onActivityComplete});

  final Function(Activity activity) onActivityComplete;

  @override
  State<AddActivityAmount> createState() => _AddActivityAmountState();
}

class _AddActivityAmountState extends State<AddActivityAmount> {
  String typedString = "";

  bool isStringEmpty(String val) {
    return val == "";
  }

  @override
  Widget build(BuildContext context) {
    final ActivityType activityType =
        Provider.of<ActivityProvider>(context).getCurrentActivityType!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tilføj aktivitet"),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          DisplayActivityType(activityType: activityType),
          const Spacer(
            flex: 1,
          ),
          Text(
            activityType.possibleUnits[0].textForUnitMeasure,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Invisible icon so the space is even
              const IconButton(
                disabledColor: Colors.transparent,
                onPressed: null,
                icon: Icon(Icons.arrow_back),
              ),
              Row(
                children: [
                  Text(
                    activityType.possibleUnits[0].stringName,
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
                  activityType.possibleUnits[0] != Units.unitLess
                      ? Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Text(
                              activityType.possibleUnits[0].stringName),
                        )
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
            flex: 2,
          ),
          MyNumberBoard(
              onNextButtonPressed: !isStringEmpty(typedString)
                  ? () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ActivityReceipt(
                                activity: Activity(
                                    amount: double.parse(
                                        typedString.replaceAll(",", ".")),
                                    activityType: activityType,

                                    //// TODO: Make this right
                                    chosenUnit:
                                        activityType.possibleUnits[0]), onActivityComplete: widget.onActivityComplete,
                              )))
                  : null,
              changeTypedString: (String newString) {
                setState(() {
                  typedString = newString;
                });
              },
              typedString: typedString)
        ],
      ),
    );
  }
}
