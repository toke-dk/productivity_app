import 'package:flutter/material.dart';


class ExtraGoalButton extends StatelessWidget {
  const ExtraGoalButton({super.key, required this.title, this.onTap});

  final String title;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: onTap,
        style: ButtonStyle(
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              textAlign: TextAlign.start,
            ),
            Spacer(),
            Container(
              width: 1,
              height: 50,
              color: Colors.black.withOpacity(0.3),
            ),
            SizedBox(
              width: 12,
            ),
            Icon(Icons.add),
          ],
        ));
  }
}