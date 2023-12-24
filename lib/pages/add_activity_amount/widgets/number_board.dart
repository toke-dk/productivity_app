import 'package:flutter/material.dart';

class MyNumberBoard extends StatelessWidget {
  const MyNumberBoard(
      {super.key, required this.changeTypedString, required this.typedString});

  final Function(String newString) changeTypedString;
  final String typedString;

  @override
  Widget build(BuildContext context) {
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

    return GridView.count(
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
            style:
            TextStyle(color: Theme.of(context).colorScheme.onPrimary),
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
              if (isStringAComma(currentString) &&
                  isStringEmpty(typedString)) {
                changeTypedString("0,");
              } else if (isStringAZero(typedString) &&
                  !isStringAComma(currentString)) {
                changeTypedString(currentString);
              } else {
                changeTypedString("$typedString$currentString");
              }
            }
            ;
          }
              : null,
          child: Container(alignment: Alignment.center, child: currentChild),
        );
      }),
    );
  }
}
