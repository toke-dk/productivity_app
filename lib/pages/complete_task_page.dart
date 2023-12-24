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
              children: [
                IconButton(
                  onPressed: () => setState(() {
                    _isToggled = !_isToggled;
                  }),
                  icon: const Icon(
                    Icons.check_circle_outlined,
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
                    Icons.thumb_up,
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
