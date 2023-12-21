import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Productivity app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Velkommen'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: [
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.bar_chart_rounded))
          ],
        ),
        body: const ShowTodayOverview());
  }
}

class ShowTodayOverview extends StatelessWidget {
  const ShowTodayOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            padding: const EdgeInsets.all(13),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(14)),
            child: Column(
              children: [
                const QuickStatsText(),
                const SizedBox(
                  height: 20,
                ),
                DistributionBar()
              ],
            )),
      ],
    );
  }
}

class QuickStatsText extends StatelessWidget {
  const QuickStatsText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "X",
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const Text(
                  " aktiviteter",
                ),
              ],
            ),
            const Row(
              children: [
                Text(
                  "y aktiviteter",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(" mere end sidste uge"),
              ],
            )
          ],
        ),
        DropdownButton(
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(child: Text("Aktivitet")),
            ],
            onChanged: null)
      ],
    );
  }
}

class DistributionBar extends StatelessWidget {
  DistributionBar({super.key});

  final List<Color> gradient = [
    Colors.green,
    Colors.green,
    Colors.yellow,
    Colors.yellow,
    Colors.brown,
    Colors.brown,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 15,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: gradient,
            stops: const [0, 0.5, 0.5, 0.7, 0.7, 1],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight),
        color: Colors.green,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
