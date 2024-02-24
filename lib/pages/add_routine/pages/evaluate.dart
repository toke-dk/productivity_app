import 'package:flutter/material.dart';

class EvaluatePage extends StatelessWidget {
  const EvaluatePage({super.key, required this.pageTitle});
  final Widget pageTitle;


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
                onPressed: () {},
                title: 'Med "udført" eller "ikke udført"',
                description:
                "Hvis du blot vil måle om du har eller ikke har udført aktiviteten",
              ),
              SizedBox(
                height: 40,
              ),
              EvaluateButtonSection(
                onPressed: () {},
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
          child: Text(title),
          style: ButtonStyle(
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
