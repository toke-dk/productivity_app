import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:productivity_app/pages/add_routine/pages/define_routine/widgets/add_extra_goal_button.dart';
import 'package:productivity_app/pages/add_routine/pages/define_routine/widgets/frequency_widget.dart';

import '../../../../shared/decorations.dart';
import 'widgets/add_extra_goal_dialog.dart';
import 'widgets/extra_goal_button.dart';

enum Frequencies {
  atLeast("Mindst"),
  inTotal("Total"),
  unLimited("Ubegrænset");

  const Frequencies(this.label);

  final String label;
}

class DefineRoutinePage extends StatefulWidget {
  const DefineRoutinePage(
      {super.key, required this.pageTitle, required this.onNextPagePressed});

  final Widget pageTitle;
  final Function() onNextPagePressed;

  @override
  State<DefineRoutinePage> createState() => _DefineRoutinePageState();
}

class _DefineRoutinePageState<Object> extends State<DefineRoutinePage> {
  Frequencies selectedFrequency = Frequencies.atLeast;
  String? routineName = "";
  String? description;
  int? goal;
  bool _filledRequiredTexts = false;
  bool _canContinue = true;

  Widget get generateRoutineText {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
          text: TextSpan(style: textTheme.bodyMedium, children: [
        TextSpan(text: "[Rutine]\n", style: textTheme.bodyLarge),
        TextSpan(text: "[Rutineforklaring?]\n\n", style: textTheme.labelMedium),
        TextSpan(text: "Mit mål er at jeg vil lave 'mindst' [mål] [enhed?]\n"),
        TextSpan(text: "Mit mål er at jeg vil lave [mål] [enhed?] i alt \n"),
        TextSpan(text: "Jeg vil blive ved med at lave [Rutinenavn]\n\n"),
        TextSpan(
            text:
                "Derudover vil jeg også opnå mit 'ekstra-mål' om at [ekstra mål tekst]"),
      ])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.pageTitle,
            TextField(
                textCapitalization: TextCapitalization.words,
                decoration: kMyInputDecoration.copyWith(
                    labelText: "Rutine*", hintText: "Navn på din rutine...")),
            SizedBox(
              height: 20,
            ),
            TextField(
                textCapitalization: TextCapitalization.sentences,
                maxLines: 3,
                decoration: kMyInputDecoration.copyWith(
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
                          .map((e) =>
                              DropdownMenuEntry(value: e, label: e.label))
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
                        keyboardType: TextInputType.number,
                        enabled: selectedFrequency != Frequencies.unLimited,
                        decoration: kMyInputDecoration.copyWith(
                          labelText: "Antal*",
                        ))),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: TextField(
                        decoration: kMyInputDecoration.copyWith(
                            labelText: "Enhed (valgfri)",
                            hintText: "eks. km."))),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "for én dag",
              style: Theme.of(context).textTheme.labelMedium,
            )
                .animate(
                    target: selectedFrequency == Frequencies.atLeast ? 1 : 0)
                .show()
                .then()
                .slide(),
            SizedBox(
              height: 10,
            ),
            Divider(
              height: 30,
            ),
            ChooseFrequency(),
            SizedBox(height: 20,),
            AddExtraGoalButton(),
            SizedBox(
              height: 25,
            ),
            Align(
                alignment: Alignment.center,
                child: FilledButton(
                    onPressed: () => widget.onNextPagePressed(),
                    child: Text("Næste"))),
            SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}
