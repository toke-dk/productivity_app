import 'package:flutter/material.dart';

import '../add_routine.dart';

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
