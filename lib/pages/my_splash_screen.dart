import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:productivity_app/models/donation.dart';
import 'package:productivity_app/shared/all_donations.dart';
import 'package:productivity_app/shared/widgets/support_banner.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key, required this.afterSplashFinish});

  final Widget afterSplashFinish;

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    void delayedExit() => Future.delayed(2000.milliseconds, () {
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) {
            return widget.afterSplashFinish;
          }));
        });

    delayedExit();

    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  final Duration animationDuration = 500.milliseconds;
  final Duration animationDelay = 200.milliseconds;

  final List<Donation> _topFiveDonations = kAllDonations.valueSortDesc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Gap(MediaQuery.of(context).size.height * 0.05),
          Center(
              child: Image.asset(
            "assets/prod_app_logo.png",
            width: 100,
          ).animate(delay: animationDelay).fadeIn(duration: animationDuration)),
          Gap(20),
          Center(
            child: Text(
              "Min Rutine",
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            )
                .animate(delay: animationDelay)
                .fadeIn(duration: animationDuration),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Divider(height: 35,),
          ),
          Text("Tak til alle bidrag:", style: Theme.of(context).textTheme.labelLarge,)
              .animate(delay: animationDelay * 2.5)
              .fadeIn(duration: animationDuration),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: _topFiveDonations.length,
                itemBuilder: (context, index) {
                  return SupportBanner(donation: _topFiveDonations[index])
                      .animate(
                        delay: animationDelay * 2.5,
                      )
                      .fadeIn(duration: animationDuration);
                }),
          ),
        ],
      ),
    );
  }
}
