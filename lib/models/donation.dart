import 'package:flutter/material.dart';

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
      print("gold");
    return GoldMedal();
  }
}

class Medal extends StatelessWidget {
  const Medal({super.key, required this.bgColor, required this.imageSrc});

  final MaterialColor bgColor;
  final String imageSrc;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: bgColor[100],
      child: Image.asset(
        imageSrc,
        width: 30,
      ),
    );
  }
}

class GoldMedal extends Medal {
  GoldMedal(
      {super.bgColor = Colors.yellow,
      super.imageSrc = "assets/medals/gold_medal.png"});
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
