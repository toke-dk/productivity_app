import 'package:flutter/material.dart';

import 'add_extra_goal_dialog.dart';
import 'extra_goal_button.dart';

class AddExtraGoalButton extends StatelessWidget {
  const AddExtraGoalButton({super.key});

  void openAddExtraGoalDialog(BuildContext context, TimeUnit timeUnit) {
    showDialog(
        context: context,
        builder: (context) {
          return AddExtraGoalDialog(
            timeUnit: timeUnit,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return _NewGoalButton(
      leading: Icon(Icons.emoji_flags_sharp),
      title: "Tilføj et Ekstra-Mål",
      trailing: Icon(Icons.add_circle),
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
                        openAddExtraGoalDialog(context, TimeUnit.week);
                      },
                    ),
                    SizedBox(
                      height: space,
                    ),
                    ExtraGoalButton(
                      title: "Måned mål",
                      onTap: () {
                        openAddExtraGoalDialog(context, TimeUnit.month);
                      },
                    ),
                    SizedBox(
                      height: space,
                    ),
                    ExtraGoalButton(
                      title: "År mål",
                      onTap: () {
                        openAddExtraGoalDialog(context, TimeUnit.year);
                      },
                    ),
                    SizedBox(
                      height: space,
                    ),
                    ExtraGoalButton(
                      title: "Total mål",
                      onTap: () {
                        openAddExtraGoalDialog(context, TimeUnit.total);
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