import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

enum Frequencies {
  atLeast("Mindst"),
  inTotal("Total"),
  unLimited("Ubegrænset");

  const Frequencies(this.label);

  final String label;
}

class DefineRoutinePage extends StatefulWidget {
  const DefineRoutinePage(
      {super.key, required this.pageTitle, required this.readyToContinue});

  final Widget pageTitle;
  final Function(bool val) readyToContinue;

  @override
  State<DefineRoutinePage> createState() => _DefineRoutinePageState();
}

class _DefineRoutinePageState<Object> extends State<DefineRoutinePage> {
  Frequencies selectedFrequency = Frequencies.atLeast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.pageTitle,
          TextField(
              onChanged: (val) => widget.readyToContinue(true),
              decoration: _myInputDecoration.copyWith(
                  labelText: "Rutine*", hintText: "Navn på din rutine...")),
          SizedBox(
            height: 20,
          ),
          TextField(
              maxLines: 3,
              decoration: _myInputDecoration.copyWith(
                  hintText: "Med denne rutine skal jeg...",
                  labelText: "Forklaring (valgfri)",
                  alignLabelWithHint: true)),
          SizedBox(
            height: 40,
          ),
          SizedBox(
            height: 50,
            child: Align(
              alignment: Alignment.centerLeft,
              child: FittedBox(
                child: DropdownMenu(
                    initialSelection: Frequencies.atLeast,
                    onSelected: (Frequencies? frequency) {
                      if (frequency != null)
                        setState(() {
                          selectedFrequency = frequency;
                        });
                    },
                    dropdownMenuEntries: Frequencies.values
                        .map((e) => DropdownMenuEntry(value: e, label: e.label))
                        .toList()),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                  child: TextField(
                      enabled: selectedFrequency != Frequencies.unLimited,
                      decoration: _myInputDecoration.copyWith(
                        labelText: "Mål*",
                      ))),
              SizedBox(
                width: 10,
              ),
              Expanded(
                  child: TextField(
                      decoration: _myInputDecoration.copyWith(
                          labelText: "Enhed (valgfri)", hintText: "eks. km."))),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "for én dag",
            style: Theme.of(context).textTheme.labelMedium,
          )
              .animate(target: selectedFrequency == Frequencies.atLeast ? 1 : 0)
              .show()
              .then()
              .slide(),
        ],
      ),
    );
  }
}

InputDecoration _myInputDecoration = InputDecoration(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(9)));
