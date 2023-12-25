import 'package:flutter/material.dart';
import 'package:productivity_app/models/activity.dart';
import 'package:productivity_app/pages/activity_receipt.dart';
import 'package:productivity_app/pages/add_activity_amount/widgets/number_board.dart';
import 'package:productivity_app/widgets/display_activity_type.dart';

class AddActivityAmount extends StatefulWidget {
  const AddActivityAmount({super.key, required this.activityType});

  final ActivityType activityType;

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tilføj aktivitet"),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          DisplayActivityType(activityType: widget.activityType),
          const Spacer(
            flex: 1,
          ),
          Text(
            widget.activityType.possibleUnits[0].textForUnitMeasure,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: 8,),
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
                    widget.activityType.possibleUnits[0].stringName,
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
                      ? Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Text(widget.activityType.possibleUnits[0].stringName),
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
                                    activityType: widget.activityType,

                                    //// TODO: Make this right
                                    chosenUnit:
                                        widget.activityType.possibleUnits[0]),
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
