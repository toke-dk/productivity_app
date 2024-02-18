import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PageTwoIntroScreen extends StatefulWidget {
  const PageTwoIntroScreen({super.key, required this.onCompletePress});

  final Function(String nickName, String? firstName, String? lastName)
      onCompletePress;

  @override
  State<PageTwoIntroScreen> createState() => _PageTwoIntroScreenState();
}

class _PageTwoIntroScreenState extends State<PageTwoIntroScreen> {
  String nickNameVal = "";
  String firstNameVal = "";
  String lastNameVal = "";

  final Duration animationDuration = 600.milliseconds;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "Fantastisk!",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ).animate().fadeIn(duration: animationDuration).moveX(begin: -10,duration: animationDuration),
              Text(
                "Lad os komme i gang",
                style: Theme.of(context).textTheme.titleMedium,
              ).animate(delay: 500.milliseconds).fadeIn(duration: animationDuration).moveX(begin: -10,duration: animationDuration),
              SizedBox(
                height: 40,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: myTextField(
                      text: "Kaldenavn *",
                      onChanged: (String newVal) {
                        setState(() {
                          nickNameVal = newVal;
                        });
                      }).animate(delay: animationDuration*1.3).fadeIn(duration: animationDuration)),
              SizedBox(
                height: 40,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: myTextField(
                      text: "Fornavn (valgfri)",
                      onChanged: (String newVal) {
                        setState(() {
                          firstNameVal = newVal;
                        });
                      }).animate(delay: animationDuration*1.6).fadeIn(duration: animationDuration)),
              SizedBox(
                height: 20,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: myTextField(
                      text: "Efternavn (valgfri)",
                      onChanged: (String newVal) {
                        setState(() {
                          lastNameVal = newVal;
                        });
                      }).animate(delay: animationDuration*1.9).fadeIn(duration: animationDuration)),
              Spacer(
                flex: 8,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: FilledButton(
                    onPressed: nickNameVal != ""
                        ? () => widget.onCompletePress(
                            nickNameVal,
                            firstNameVal != "" ? firstNameVal : null,
                            lastNameVal != "" ? lastNameVal : null)
                        : null,
                    child: Text("Start Rejsen")),
              ),
              Spacer()
            ],
          ),
        ),
      ),
    );
  }
}

TextField myTextField(
    {required String text, required Function(String newVal) onChanged}) {
  return TextField(
    onChanged: (String newVal) => onChanged(newVal),
    textCapitalization: TextCapitalization.words,
    decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        labelText: text,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
        )),
  );
}
