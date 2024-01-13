import 'package:flutter/material.dart';
import 'package:productivity_app/widgets/MyThemeButton.dart';

class ShowGoalsWidget extends StatelessWidget {
  const ShowGoalsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey[100]
      ),
      child: Column(
        children: [
          Text("Du har ikke sat et mål endnu"),
          SizedBox(height: 20,),
          MyThemeButton(onTap: (){}, labelText: "Angiv mål!",)
        ],
      ),
    );
  }
}
