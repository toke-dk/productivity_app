import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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

  final double widgetHeight = 38;
  static const double textSize = 30;

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
          Stack(
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  !isStringEmpty(typedString)
                      ? Container(
                          height: widgetHeight,
                          alignment: Alignment.center,
                          child: Text(
                            typedString.toString(),
                            style: const TextStyle(fontSize: textSize),
                          ),
                        )
                      : const SizedBox(),
                  Container(
                    height: widgetHeight,
                    width: 3,
                    color: Theme.of(context).primaryColor,
                  )
                      .animate(
                        onPlay: (controller) => controller.repeat(),
                      )
                      .then(delay: 300.milliseconds)
                      .fadeIn(duration: 150.milliseconds)
                      .then(delay: 350.milliseconds)
                      .fadeOut(duration: 150.milliseconds),
                  const SizedBox(
                    width: 5,
                  ),
                  widget.actionType.possibleUnits![0] != Units.unitLess
                      ? Container(
                          height: widgetHeight,
                          child: Text(
                            widget.actionType.possibleUnits![0].shortStringName,
                            style: const TextStyle(
                              fontSize: textSize,
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
              Positioned(
                right: 0,
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        typedString =
                            typedString.substring(0, typedString.length - 1);
                      });
                    },
                    icon: const Icon(Icons.backspace)),
              ).animate(target: !isStringEmpty(typedString) ? 0 : 1,).scaleXY(end: 0, curve: Curves.easeOutExpo)
            ],
          ),
          Spacer(),
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
