import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MySizeTransition extends StatefulWidget {
  const MySizeTransition({super.key, required this.child, this.isShowing = true});

  final Widget child;
  final bool isShowing;

  @override
  State<MySizeTransition> createState() => _MySizeTransitionState();
}

class _MySizeTransitionState extends State<MySizeTransition> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: 300.milliseconds,
    );

    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {

    if (widget.isShowing) _animationController.forward();
    else if (!widget.isShowing) _animationController.reverse();

    return SizeTransition(
      sizeFactor: _animation,
      child: widget.child,
    );
  }
}