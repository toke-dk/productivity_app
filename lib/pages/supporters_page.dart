import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:productivity_app/pages/my_splash_screen.dart';
import 'package:productivity_app/shared/all_donations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/donation.dart';
import '../shared/widgets/support_banner.dart';

class SupportersPage extends StatelessWidget {
  SupportersPage({super.key});

  final List<Donation> _donationsSortedByDate = kAllDonations.dateSortDesc;

  Future<void> launchLink(String link) async {
    final Uri feedbackUrl = Uri.parse(link);
    if (!await launchUrl(feedbackUrl)) {
      throw Exception("Could not launch $feedbackUrl");
    }
  }

  final String _donateLink = "https://www.buymeacoffee.com/toke.f";

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
            Gap(8),
            OutlinedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => SimpleDialog(
                            title: Text("Vi sætter pris på din støtte"),
                            contentPadding: EdgeInsets.all(25),
                            children: [
                              Text(
                                  "Dit bidrag kan gives ved at donnere til appen på nedenstående knap"),
                              Gap(8),
                              Text("Inden for få dage vil din støtte blive vist, inde i appen, sammen med de andre"),
                              Gap(8),
                              Text("Tak for hjælpen\n- Toke"),
                              Gap(20),
                              OutlinedButton.icon(onPressed: (){
                                launchLink(_donateLink);
                              }, icon: Icon(FontAwesomeIcons.coins), label: Text("Tryk her for at donere!"), ),
                              Text('- Donationen foregår gennem "buymeacoffee.com"', style: Theme.of(context).textTheme.labelSmall!.copyWith(fontStyle: FontStyle.italic),)
                            ],
                          ));
                },
                child: Text("Tilføj dit bidrag")),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                height: 40,
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
                itemCount: _donationsSortedByDate.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child:
                        SupportBanner(donation: _donationsSortedByDate[index]),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
