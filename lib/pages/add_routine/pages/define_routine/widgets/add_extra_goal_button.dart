import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:productivity_app/models/providers/routine_provider.dart';
import 'package:productivity_app/models/routine.dart';
import 'package:provider/provider.dart';

import 'add_extra_goal_dialog.dart';
import 'extra_goal_button.dart';

class AddExtraGoalButton extends StatelessWidget {
  const AddExtraGoalButton({super.key});

  @override
  Widget build(BuildContext context) {
    ExtraGoal? _extraGoal = Provider.of<RoutineProvider>(context).extraGoal;

    void openAddExtraGoalDialog(TimeUnit timeUnit) {
      showDialog(
          context: context,
          builder: (context) {
            return AddExtraGoalDialog(
              timeUnit: timeUnit,
            );
          }).then((value) {
        if (value == null) return;
        Navigator.pop(context);
        Provider.of<RoutineProvider>(context, listen: false).setExtraGoal =
            value;
      });
    }

    void openEditExtraGoalSheet() {
      if (_extraGoal == null) return;
      showModalBottomSheet(
          context: context,
          builder: (newContext) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "Målets varighed er: ${_extraGoal.timePeriod.translatedName}"),
                  Text(
                      "Antal: ${_extraGoal.amountForTotalTimePeriod.toString()}"),
                  Text(
                      "Startdato: ${_extraGoal.startDate != null ? DateFormat("EEE. dd.MMM.yyyyy").format(_extraGoal.startDate!) : '(Ingen)'}"),
                  Text(
                      "Afsluttes når fuldført: ${_extraGoal.shouldEndWhenFinished == true ? '(Ja)' : '(Nej)'}"),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                      child: OutlinedButton(
                          onPressed: () {
                            Provider.of<RoutineProvider>(context, listen: false)
                                .setExtraGoal = null;
                            Navigator.pop(context);
                          },
                          child: Text("Slet mål")))
                ],
              ),
            );
          });
    }

    return _NewGoalButton(
      leading: Icon(Icons.emoji_flags_sharp),
      title: "Tilføj et Ekstra-Mål",
      trailing: Icon(_extraGoal == null ? Icons.add_circle : Icons.edit),
      onPressed: () {
        _extraGoal != null
            ? openEditExtraGoalSheet()
            : showModalBottomSheet(
                context: context,
                builder: (context) {
                  final double space = 10;
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 40),
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
