import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:productivity_app/models/user.dart';
import 'package:productivity_app/pages/introduction_screens/page_two.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.userData, required this.onSave});

  final UserData userData;

  final Function(UserData newUserData) onSave;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final nickNameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  @override
  void initState() {
    nickNameController.text = widget.userData.nickName;
    firstNameController.text = widget.userData.firstName ?? "";
    lastNameController.text = widget.userData.lastName ?? "";

    super.initState();
  }

  bool nickNameChange = false;
  bool firstNameChange = false;
  bool lastNameChange = false;

  bool saveButtonActive = false;

  @override
  Widget build(BuildContext context) {
    print(nickNameChange || firstNameChange || lastNameChange);
    setState(() {
      saveButtonActive = nickNameChange || firstNameChange || lastNameChange;
    });

    print("here: ${widget.userData.lastName.runtimeType}");
    return Scaffold(
      appBar: AppBar(
        title: Text("Indstillinger"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 30,
                child: Icon(
                  Icons.account_circle,
                  size: 30,
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "Kaldenavn *",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            TextField(
              controller: nickNameController,
              onChanged: (newVal) => setState(() {
                nickNameChange = newVal != "" ? widget.userData.nickName != newVal : false;
              }),
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Fornavn",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            TextField(
              controller: firstNameController,
              onChanged: (newVal) => setState(() {
                firstNameChange =
                    widget.userData.firstName == null && newVal == ""
                        ? false
                        : widget.userData.firstName != newVal;
              }),
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Efternavn",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            TextField(
              controller: lastNameController,
              onChanged: (newVal) => setState(() {
                lastNameChange =
                    widget.userData.lastName == null && newVal == ""
                        ? false
                        : widget.userData.lastName != newVal;
              }),
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                  onPressed: saveButtonActive
                      ? () => widget.onSave(UserData(
                          nickName: nickNameController.text,
                          firstName: firstNameController.text,
                          lastName: lastNameController.text))
                      : null,
                  child: Text("Gem")),
            )
          ],
        ),
      ),
    );
  }
}
