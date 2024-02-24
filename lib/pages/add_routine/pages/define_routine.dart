import 'package:flutter/material.dart';

class DefineRoutinePage extends StatelessWidget {
  const DefineRoutinePage({super.key, required this.pageTitle});
  final Widget pageTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        pageTitle,
      ],
    );
  }
}
