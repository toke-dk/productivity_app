import 'package:flutter/material.dart';

class PageTwoIntroScreen extends StatelessWidget {
  const PageTwoIntroScreen({super.key, required this.onCompletePress});

  final Function() onCompletePress;

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
                  child: myTextField(text: "Kaldenavn *")),
              SizedBox(
                height: 40,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: myTextField(text: "Fornavn (valgfri)")),
              SizedBox(
                height: 20,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: myTextField(text: "Efternavn (valgfri)")),
              Spacer(
                flex: 8,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: FilledButton(
                    onPressed: () => onCompletePress(),
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

TextField myTextField({required String text}) {
  return TextField(
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
