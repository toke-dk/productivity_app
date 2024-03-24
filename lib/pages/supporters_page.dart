import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:productivity_app/pages/my_splash_screen.dart';

class SupportersPage extends StatelessWidget {
  const SupportersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Støtte"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Gap(20),
            Center(
                child: Text(
              "Om at støtte Min Rutine",
              style: Theme.of(context).textTheme.titleLarge,
            )),
            Gap(10),
            Container(
              width: 300,
              child: Text(
                "Min Rutine modtager ingen penge fra brugerne, og derfor er din støtte afgørende for at sikre, at appen fortsat kan udvikles på.",
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                height: 60,
              ),
            ),
            Center(
                child: Text(
              "Alle Bidrag",
              style: Theme.of(context).textTheme.titleLarge,
            )),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
                itemCount: 20,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: supportBannerWidget(context),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
