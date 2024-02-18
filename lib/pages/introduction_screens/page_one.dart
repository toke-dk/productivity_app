import 'package:flutter/material.dart';

class PageOneIntroScreen extends StatelessWidget {
  const PageOneIntroScreen({super.key, required this.nextPagePressed});

  final double _horizontalPadding = 50;

  final Function() nextPagePressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacer(flex: 4,),
            Center(child: Image.asset("assets/prod_app_logo.png")),
            SizedBox(
              height: 40,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
                child: Text(
                  "Start din rejse med\nMin Rutine",
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold),
                )),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
                child: Text("Skab personlige vaner, opstil klare mål, og hold styr på dine fremskridt med lethed. Skab den bedste version af dig selv")),
            Spacer(flex: 8,),
            Center(child: FilledButton(onPressed: () => nextPagePressed(), child: Text("Kom i gang!"))),
            Spacer()
          ],
        ),
      ),
    );
  }
}
