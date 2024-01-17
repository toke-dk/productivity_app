import 'package:flutter/material.dart';
import 'package:productivity_app/models/activity.dart';
import 'package:productivity_app/models/task.dart';
import 'package:productivity_app/pages/activity_receipt.dart';
import 'package:productivity_app/pages/add_activity_amount/widgets/number_board.dart';
import 'package:productivity_app/shared/allActionTypes.dart';
import 'package:productivity_app/widgets/display_activity_type.dart';
import 'package:provider/provider.dart';

import '../../models/unit.dart';

class AddActivityAmount extends StatefulWidget {
  const AddActivityAmount(
      {super.key, required this.actionType, this.onComplete, this.unit});

  final ActionType actionType;
  final Units? unit;
  final Function(double amount)? onComplete;

  @override
  State<AddActivityAmount> createState() => _AddActivityAmountState();
}

class _AddActivityAmountState extends State<AddActivityAmount> {
  String typedString = "";

  bool isStringEmpty(String val) {
    return val == "";
  }

  Function()? _onNextPress() {
    return widget.onComplete != null
        ? widget.onComplete!(double.parse(typedString.replaceAll(",", ".")))
        : {};
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
          DisplayActionType(actionType: widget.actionType),
          const Spacer(
            flex: 1,
          ),
          Text(
            widget.unit?.shortStringName ??
                widget.actionType.possibleUnits![0].textForUnitMeasure,
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
                    widget.actionType.possibleUnits![0].stringName,
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
                  widget.actionType.possibleUnits![0] != Units.unitLess
                      ? Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Text(
                              widget.actionType.possibleUnits![0].stringName),
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
              onNextButtonPressed:
                  !isStringEmpty(typedString) ? _onNextPress : null,
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
