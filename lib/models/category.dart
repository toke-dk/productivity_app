import 'package:flutter/cupertino.dart';

class Category {
  final String name;
  final Widget child;
  final Color color;

  const Category(
      {required this.name, required this.child, required this.color});
}
