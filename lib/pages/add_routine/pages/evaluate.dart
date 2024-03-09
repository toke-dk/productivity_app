import 'package:flutter/material.dart';

import '../add_routine.dart';

class EvaluatePage extends StatelessWidget {
  const EvaluatePage(
      {super.key, required this.pageTitle, required this.onEvaluationTypeSelected});

  final Widget pageTitle;
  final Function(EvaluationType enteredType) onEvaluationTypeSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        pageTitle,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            children: [
              EvaluateButtonSection(
                onPressed: () {
                  onEvaluationTypeSelected(EvaluationType.checkMark);
                },
                title: 'Med afkrydsning',
                description:
                    "Hvis du blot vil måle om du har 'Udført' eller 'Ikke Udført' aktiviteten",
              ),
              SizedBox(
                height: 40,
              ),
              EvaluateButtonSection(
                onPressed: () {
                  onEvaluationTypeSelected(EvaluationType.numeric);
                },
                title: 'Med en numerisk værdi',
                description:
                    "Hvis du gerne vil angive en værdi som et dagligt mål for din rutine",
              ),
            ],
          ),
        )
      ],
    );
  }
}

class EvaluateButtonSection extends StatelessWidget {
  const EvaluateButtonSection(
      {super.key, this.onPressed, required this.title, this.description});

  final Function()? onPressed;
  final String title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton(
          onPressed: onPressed,
          child: Text(
            title,
            textAlign: TextAlign.center,
          ),
          style: ButtonStyle(
              padding: MaterialStatePropertyAll(
                  EdgeInsets.symmetric(vertical: 10, horizontal: 20)),
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)))),
        ),
        SizedBox(
          height: 2,
        ),
        description != null
            ? Text(
                description!,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              )
            : SizedBox()
      ],
    );
  }
}
