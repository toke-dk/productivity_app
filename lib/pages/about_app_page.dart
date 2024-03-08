import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  Future<void> launchLink(String link) async {
    final Uri feedbackUrl = Uri.parse(link);
    if (!await launchUrl(feedbackUrl)) {
      throw Exception("Could not launch $feedbackUrl");
    }
  }

  final String appLinkedInLink =
      "https://www.linkedin.com/showcase/min-rutine-app/";
  final String developerLinkedInLink =
      "https://www.linkedin.com/in/toke-friis-596526241/";
  final String patreonLink =
      "https://www.patreon.com/user/shop/stot-udviklingen-af-min-rutine-149565?u=121530901&utm_medium=clipboard_copy&utm_source=copyLink&utm_campaign=productshare_creator&utm_content=join_link";
  final String companyLink = "https://www.linkedin.com/company/pinova-software";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Om appen"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Center(
                child: Image.asset(
                  "assets/prod_app_logo.png",
                  width: 100,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Min Rutine",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(
                height: 13,
              ),
              Text(
                "Udvilket af Toke Friis",
              ),
              SizedBox(
                height: 9,
              ),
              Image.asset(
                "assets/pinova_logo.png",
                width: 50,
              ),
              Divider(
                height: 60,
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.linkedin),
                title: Text("Min Rutine"),
                subtitle: Text("LinkedIn"),
                trailing: Icon(Icons.open_in_new),
                onTap: () => launchLink(appLinkedInLink),
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.linkedin),
                title: Text("Toke Friis"),
                subtitle: Text("LinkedIn"),
                trailing: Icon(Icons.open_in_new),
                onTap: () => launchLink(developerLinkedInLink),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Divider(
                    height: 10,
                  )),
              ListTile(
                leading: Icon(FontAwesomeIcons.patreon),
                subtitle: Text("Patreon"),
                title: Text("Støt udviklingen"),
                trailing: Icon(Icons.open_in_new),
                onTap: () => launchLink(patreonLink),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
