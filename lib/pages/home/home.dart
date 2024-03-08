import 'package:flutter/material.dart';
import 'package:productivity_app/models/goal.dart';
import 'package:productivity_app/models/user.dart';
import 'package:productivity_app/pages/about_app_page.dart';
import 'package:productivity_app/pages/actions_log_page.dart';
import 'package:productivity_app/pages/home/widgets/show_goals.dart';
import 'package:productivity_app/pages/settings/settings_page.dart';
import 'package:productivity_app/services/database_service.dart';
import 'package:productivity_app/shared/allActionTypes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' as Foundation;

import '../../models/activity.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {super.key,
      required this.title,
      required this.userData,
      required this.editUserData});

  final UserData userData;
  final String title;
  final Function(UserData newData) editUserData;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DataBaseService _databaseService = DataBaseService();

  @override
  void initState() {
    super.initState();
  }

  Future<List<AmountGoal>> _getAmountGoals() async {
    return _databaseService.getAmountGoals();
  }

  Future<List<CheckmarkGoal>> _getCheckmarkGoals() async {
    return _databaseService.getCheckmarkGoal();
  }

  Future<void> _addDoneAmountActivity(
      {required AmountGoal goal,
      required DoneAmountActivity doneAmount}) async {
    _databaseService.addDoneAmountActivity(goal, doneAmount);
  }

  Future<void> launchFeedBackForm() async {
    final Uri feedbackUrl = Uri.parse(
        "https://docs.google.com/forms/d/e/1FAIpQLSehUorGGbMuzEKFkIiPL3srDSerNT2EpNyOtY1X1v3qBh6L_w/viewform");
    if (!await launchUrl(feedbackUrl)) {
      throw Exception("Could not launch $feedbackUrl");
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<ActionType> allActionTypes = kAllActionTypes;

    return Scaffold(
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(child: Text("Menu")),
              ListTile(
                leading: Icon(Icons.account_circle),
                title: Text("Profil"),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SettingsPage(
                              userData: widget.userData,
                              onSave: (UserData newUserData) {
                                widget.editUserData(newUserData);
                                Navigator.pop(context);
                              },
                            ))),
              ),
              Divider(),
              ListTile(
                title: Text("Feedback"),
                onTap: launchFeedBackForm,
                leading: Icon(Icons.open_in_new),
              ),
              ListTile(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AboutUsPage())),
                leading: Icon(Icons.account_balance_sharp),
                title: Text("Om Appen"),
              )
            ],
          ),
        ),
        appBar: AppBar(
            title: Text("${widget.title}, ${widget.userData.nickName}"),
            actions: [
              Foundation.kDebugMode
                  ? IconButton(
                      onPressed: () async {
                        setState(() {});
                      },
                      icon: const Icon(Icons.add_task))
                  : SizedBox(),
              Foundation.kDebugMode
                  ? IconButton(
                      onPressed: () async {
                        await _databaseService.deleteAllAmountGoals();
                        await _databaseService.deleteAllCheckMarkGoals();
                        setState(() {});
                      },
                      icon: const Icon(Icons.delete))
                  : SizedBox()
            ]),

        /// Main content
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: FutureBuilder(
                    future: Future(() async =>
                        [await _getAmountGoals(), await _getCheckmarkGoals()]),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return ShowGoalsWidget(
                          onAmountGoalDelete: (AmountGoal goal) {
                            setState(() {
                              _databaseService.deleteAmountGoal(goal);
                            });
                          },
                          onCheckmarkGoalDelete: (CheckmarkGoal goal) {
                            setState(() {
                              _databaseService.deleteCheckmarkGoal(goal);
                            });
                          },
                          amountGoals: (snapshot.data![0] as List<AmountGoal>),
                          checkmarkGoals:
                              (snapshot.data![1] as List<CheckmarkGoal>),
                          onAmountGoalActivityAdded: (goal, amount) {
                            setState(() {
                              _addDoneAmountActivity(
                                  goal: goal, doneAmount: amount);
                            });
                            Navigator.pop(context);
                          },
                          onCheckMarkGoalDoneDateAdd:
                              (CheckmarkGoal goal, DateTime date) {
                            setState(() {
                              _databaseService.addDoneDateToCheckmarkGoal(
                                  goal, date);
                            });
                          },
                          onCheckmarkGoalDoneDateDelete:
                              (CheckmarkGoal goal, DateTime date) {
                            setState(() {
                              _databaseService.removeDoneDateFromCheckmarkGoal(
                                  goal, date);
                            });
                          },
                          onCheckMarkGoalAdd: (CheckmarkGoal checkmarkGoal) {
                            setState(() {
                              _databaseService.addCheckmarkGoal(checkmarkGoal);
                            });
                          },
                          onAmountGoalAdd: (AmountGoal amountGoal) {
                            if (this.mounted)
                              setState(() {
                                _databaseService.addAmountGoal(amountGoal);
                              });
                          },
                          onAmountActionsLog: (AmountGoal goal) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ActionsLogPage(
                                          goal: goal,
                                        )));
                          },
                        );
                      } else if (snapshot.hasError) {
                        print(snapshot.stackTrace.toString());
                        return Text(snapshot.error.toString());
                      } else
                        return Center(child: CircularProgressIndicator());
                    }),
              ),
              IconButton(
                  onPressed: () => setState(() {}),
                  icon: const Icon(Icons.refresh)),
            ],
          ),
        ));
  }
}
