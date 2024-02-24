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
  const DefineRoutinePage({super.key, required this.pageTitle});

  final Widget pageTitle;

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
            TextSpan(text: "Derudover vil jeg også opnå mit 'ekstra-mål' om at [ekstra mål tekst]"),

          ])),
    );
  }

  @override
  void initState() {
    super.initState();
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
                decoration: _myInputDecoration.copyWith(
                    labelText: "Rutine*", hintText: "Navn på din rutine...")),
            SizedBox(
              height: 20,
            ),
            TextField(
                textCapitalization: TextCapitalization.sentences,
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
                        decoration: _myInputDecoration.copyWith(
                          labelText: "Mål*",
                        ))),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: TextField(
                        decoration: _myInputDecoration.copyWith(
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
            _NewGoalButton(
              trailing: Icon(Icons.add),
              title: "Tilføj et ekstra-mål",
              onPressed: () {},
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border:
                      Border.all(color: Theme.of(context).colorScheme.outline)),
              child: Column(
                children: [
                  generateRoutineText,
                  CheckboxListTile(
                    enabled: _filledRequiredTexts,
                    value: false,
                    onChanged: (bool? newVal) {},
                    title: Text("Det er jeg klar på!"),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _NewGoalButton extends StatelessWidget {
  const _NewGoalButton(
      {super.key,
      this.onPressed,
      required this.title,
      this.description,
      this.trailing = const SizedBox()});

  final Function()? onPressed;
  final String title;
  final String? description;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
            ),
            trailing,
          ],
        ),
        style: ButtonStyle(
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6)))),
      ),
    );
  }
}

InputDecoration _myInputDecoration = InputDecoration(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(9)));
