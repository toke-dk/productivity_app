import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PageOneIntroScreen extends StatelessWidget {
  PageOneIntroScreen({super.key, required this.nextPagePressed});

  final double _horizontalPadding = 50;

  final Function() nextPagePressed;

  final Duration animationDuration = 900.milliseconds;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacer(
              flex: 4,
            ),
            Center(
                child: Image.asset("assets/prod_app_logo.png")
                    .animate()
                    .fadeIn(duration: animationDuration)
                    .moveY(
                        begin: -20,
                        duration: animationDuration - 500.milliseconds)),
            SizedBox(
              height: 40,
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
                child: Text(
                  "Start din rejse med\nMin Rutine",
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(fontWeight: FontWeight.bold),
                )
                    .animate(
                      delay: 500.milliseconds,
                    )
                    .moveX(begin: -20, duration: animationDuration)
                    .fadeIn(duration: animationDuration)),
            SizedBox(
              height: 10,
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
                child: Text(
                        "Skab personlige vaner, opstil klare mål, og hold styr på dine fremskridt med lethed. Skab den bedste version af dig selv")
                    .animate(delay: animationDuration*1.5)
                    .moveX(begin: -20, duration: animationDuration)
                    .fadeIn(duration: animationDuration)),
            Spacer(
              flex: 8,
            ),
            Center(
                child: FilledButton(
                        onPressed: () => nextPagePressed(),
                        child: Text("Kom i gang!"))
                    .animate(delay: animationDuration*2)
                    .scaleXY(curve: Curves.easeOutCirc, duration: 1.seconds)),
            Spacer()
          ],
        ),
      ),
    );
  }
}
