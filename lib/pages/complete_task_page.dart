import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:productivity_app/models/activity.dart';

class CompleteTaskPage extends StatefulWidget {
  const CompleteTaskPage({super.key, required this.activityType});

  final ActivityType activityType;

  @override
  State<CompleteTaskPage> createState() => _CompleteTaskPageState();
}

class _CompleteTaskPageState extends State<CompleteTaskPage> {
  bool _isToggled = false;
  bool _showConfetti = false;

  final controller = ConfettiController();

  @override
  void initState() {
    controller.addListener(() {
      setState(() {
        _showConfetti = controller.state == ConfettiControllerState.playing;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tilføj aktivitet"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  onPressed: () async {
                    setState(() {
                      _isToggled = !_isToggled;
                      _showConfetti = true;
                    });
                    await Future.delayed(const Duration(milliseconds: 350));
                    controller.play();
                    await Future.delayed(const Duration(milliseconds: 50));
                    controller.stop();
                    await Future.delayed(const Duration(seconds: 2));
                    if (context.mounted) {
                      //// TODO navigate to page here
                    }

                    setState(() {});
                  },
                  icon: const Icon(
                    Icons.check_circle_outline_rounded,
                    size: 200,
                  ),
                )
                    .animate(onPlay: (controller) => controller.repeat())
                    .shake(
                        hz: 4,
                        curve: Curves.easeInOutCubic,
                        duration: 700.ms,
                        delay: 1.seconds)
                    .animate(target: _isToggled ? 1 : 0)
                    .scaleXY(end: 0, duration: 100.ms),
                IconButton(
                  onPressed: () => setState(() {
                    _isToggled = !_isToggled;
                  }),
                  icon: const Icon(
                    Icons.thumb_up_alt_rounded,
                    size: 200,
                  ),
                )
                    .animate(target: _isToggled ? 1 : 0)
                    .then(delay: 400.ms)
                    .scaleXY(
                      begin: 0,
                      end: 1.1,
                      duration: 100.ms,
                      curve: Curves.easeInOutCubic,
                    )
                    .then(delay: 50.ms)
                    .scaleXY(end: 1 / 1.1, duration: 100.ms),
                ConfettiWidget(
                  confettiController: controller,
                  gravity: 0.01,
                  blastDirectionality: BlastDirectionality.explosive,
                  emissionFrequency: 0,
                  maxBlastForce: 10,
                  minBlastForce: 9,
                  maximumSize: Size(15, 15),
                  minimumSize: Size(14, 14),
                  numberOfParticles: 35,
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            const Icon(Icons.arrow_downward)
                .animate(
                    onPlay: (controller) => controller.repeat(reverse: true))
                .moveY(end: 10, delay: 1.seconds),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 20,
                  child: ClipOval(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: widget.activityType.image,
                  )),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(widget.activityType.name)
              ],
            )
          ],
        ),
      ),
    );
  }
}
