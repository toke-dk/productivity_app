import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
        TextSpan(
            text:
                "Derudover vil jeg også opnå mit 'ekstra-mål' om at [ekstra mål tekst]"),
      ])),
    );
  }

  void openAddExtraGoalDialog(TimeUnit timeUnit) {
    showDialog(
        context: context,
        builder: (context) {
          return AddExtraGoalDialog(timeUnit: timeUnit,);
        });
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
                          labelText: "Mål*",
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
            _NewGoalButton(
              leading: Icon(Icons.emoji_flags_sharp),
              title: "Tilføj et Ekstra-Mål",
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      final double space = 10;
                      return Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 30, horizontal: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Ekstra-Mål",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(
                              "Her kan du vælge at lave et mål ud fra dit daglige mål",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ExtraGoalButton(
                              title: "Uge mål",
                              onTap: () {
                                openAddExtraGoalDialog(TimeUnit.week);
                              },
                            ),
                            SizedBox(
                              height: space,
                            ),
                            ExtraGoalButton(
                              title: "Måned mål",
                              onTap: () {
                                openAddExtraGoalDialog(TimeUnit.month);

                              },
                            ),
                            SizedBox(
                              height: space,
                            ),
                            ExtraGoalButton(
                              title: "År mål",
                              onTap: () {
                                openAddExtraGoalDialog(TimeUnit.year);

                              },
                            ),
                            SizedBox(
                              height: space,
                            ),
                            ExtraGoalButton(
                              title: "Total mål",
                              onTap: () {
                                openAddExtraGoalDialog(TimeUnit.total);
                              },
                            ),
                          ],
                        ),
                      );
                    });
              },
            ),
            SizedBox(height: 10,),
            ChooseFrequency()
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
      this.trailing = const SizedBox(),
      this.leading = const SizedBox()});

  final Function()? onPressed;
  final Widget leading;
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
          children: [
            leading,
            SizedBox(
              width: 10,
            ),
            Text(
              title,
            ),
            Spacer(),
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

