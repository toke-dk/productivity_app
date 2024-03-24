import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Donation {
  String name;
  String? message;
  double valueInKr;
  DateTime dateAdded;

  Donation(
      {required this.name,
      this.message,
      required this.valueInKr,
      required this.dateAdded});

  Medal get earnedMedal {
    final double bronzePriceMinimum = 10;
    final double silverPriceMinimum = 30;

    if (valueInKr <= bronzePriceMinimum) {
      return BronzeMedal();
    } else if (valueInKr <= silverPriceMinimum) {
      return SilverMedal();
    } else
    return GoldMedal();
  }
}

class Medal extends StatelessWidget {
  const Medal(
      {super.key,
      required this.bgColor,
      required this.imageSrc,
      this.shimmer = false});

  final MaterialColor bgColor;
  final String imageSrc;

  final double _radius = 25;
  final double _border = 2;

  final bool shimmer;

  @override
  Widget build(BuildContext context) {
    final Random _random = Random();
    final int _delay =
        _random.nextInt(3500) + 1500; // Random number [2000 : 4499]

    return CircleAvatar(
        radius: _radius + _border,
        backgroundColor: bgColor == Colors.yellow ? bgColor[800] : bgColor[300],
        child: Animate(
            effects: shimmer
                ? [
                    ShimmerEffect(
                        delay: _delay.milliseconds, duration: 1.seconds)
                  ]
                : [],
            onPlay: (controller) => controller.loop(count: 4),
            child: CircleAvatar(
              radius: _radius,
              backgroundColor: bgColor[100],
              child: Image.asset(
                imageSrc,
                width: 30,
              ),
            )));
  }
}

class GoldMedal extends Medal {
  GoldMedal(
      {super.bgColor = Colors.yellow,
      super.imageSrc = "assets/medals/gold_medal.png",
      super.shimmer = true});
}

class SilverMedal extends Medal {
  SilverMedal(
      {super.bgColor = Colors.grey,
      super.imageSrc = "assets/medals/silver_medal.png"});
}

class BronzeMedal extends Medal {
  BronzeMedal(
      {super.bgColor = Colors.brown,
      super.imageSrc = "assets/medals/bronze_medal.png"});
}
