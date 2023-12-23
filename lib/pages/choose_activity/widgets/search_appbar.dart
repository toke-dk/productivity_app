import 'package:flutter/material.dart';

class MySearchAppBar extends StatelessWidget {
  const MySearchAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          prefixIcon: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          isDense: true,
          border: const OutlineInputBorder(),
          hintText: "Søg efter aktivitet"),
    );
  }
}
