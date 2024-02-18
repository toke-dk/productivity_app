import 'package:flutter/material.dart';

class PageTwoIntroScreen extends StatelessWidget {
  const PageTwoIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 20,),
              Text("Fantastisk!", style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),),
              Text("Lad os komme i gang", style: Theme.of(context).textTheme.titleMedium,)
            ],
          ),
        ),
      ),
    );
  }
}
