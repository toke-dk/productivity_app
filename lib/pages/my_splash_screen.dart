import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';

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

    Future.delayed(2.seconds, () {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return widget.afterSplashFinish;
      }));
    });

    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  final Duration animationDuration = 950.milliseconds;
  final Duration animationDelay = 300.milliseconds;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Gap(MediaQuery.of(context).size.height * 0.1),
          Center(
              child: Image.asset("assets/prod_app_logo.png")
                  .animate(delay: animationDelay)
                  .fadeIn(duration: animationDuration)),
          Gap(20),
          Center(
            child: Text(
              "Min Rutine",
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ).animate(delay: animationDelay).fadeIn(duration: animationDuration),
          ),
          Gap(20),
          Text("Tak til:").animate(delay: animationDelay*2.5).fadeIn(duration: animationDuration),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: supportBannerWidget(context).animate(delay: animationDelay*2.5,).fadeIn(duration: animationDuration),
          ),
        ],
      ),
    );
  }



}

Widget supportBannerWidget(context) {
  return Stack(
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 12, left: 20),
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.07),
                spreadRadius: 1,
                blurRadius: 3)
          ], borderRadius: BorderRadius.circular(5), color: Colors.white),
          padding:
          const EdgeInsets.only(top: 6, left: 50, bottom: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "DIT NAVN!",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold, letterSpacing: 0.1),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 7),
                      child: Text(
                        "DIN YNDLINGSLYD!",
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    )
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 2),
                    height: 25,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Theme.of(context).colorScheme.primary),
                    child: FittedBox(
                      child: Text(
                        "kr. 6,9",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "dato: I DAG",
                    style: Theme.of(context).textTheme.labelSmall,
                  )
                ],
              )
            ],
          ),
        ),
      ),
      Positioned(
        left: 0,
        top: 0,
        bottom: 0,
        child: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.yellow[300],
          child: Image.asset("assets/medals/gold_medal.png",width: 30,),
        ),
      ),
    ],
  );
}