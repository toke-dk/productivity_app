import 'package:flutter/material.dart';

class NewActivityPage extends StatelessWidget {
  const NewActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    print("Here");
    return Scaffold(
      appBar: AppBar(title: Text("Tilføj aktivitet"),),
      body: Container(),
    );
  }
}
