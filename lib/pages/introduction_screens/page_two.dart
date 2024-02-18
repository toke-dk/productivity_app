import 'package:flutter/material.dart';

class PageTwoIntroScreen extends StatefulWidget {
  const PageTwoIntroScreen({super.key, required this.onCompletePress});

  final Function() onCompletePress;

  @override
  State<PageTwoIntroScreen> createState() => _PageTwoIntroScreenState();
}

class _PageTwoIntroScreenState extends State<PageTwoIntroScreen> {
  String nickNameVal = "";
  String firstNameVal = "";
  String lastNameVal = "";

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
              ),
              Text(
                "Lad os komme i gang",
                style: Theme.of(context).textTheme.titleMedium,
              ),
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
                      })),
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
                      })),
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
                      })),
              Spacer(
                flex: 8,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: FilledButton(
                    onPressed: nickNameVal != "" ? () => widget.onCompletePress() : null,
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
