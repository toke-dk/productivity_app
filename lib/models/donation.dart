import 'package:flutter/material.dart';

class Donation {
  String name;
  String? message;
  double valueInKr;

  Donation({required this.name, this.message, required this.valueInKr});

  Medal get earnedMedal {
    final double bronzePriceMinimum = 10;
    final double silverPriceMinimum = 30;

    if (bronzePriceMinimum <= valueInKr) {
      return BronzeMedal();
    } else if (bronzePriceMinimum < valueInKr &&
        valueInKr <= silverPriceMinimum) {
      return SilverMedal();
    } else
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
      backgroundColor: bgColor[300],
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
