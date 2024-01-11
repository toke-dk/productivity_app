import 'package:flutter/material.dart';
import 'package:productivity_app/models/activity.dart';
import 'package:productivity_app/models/task.dart';
import 'package:productivity_app/pages/add_activity_amount/add_activity_amount.dart';
import 'package:productivity_app/shared/widgets/activity_card.dart';
import 'package:productivity_app/pages/choose_activity/widgets/search_appbar.dart';
import 'package:productivity_app/pages/complete_task_page.dart';
import 'package:productivity_app/shared/allActionTypes.dart';
import 'package:provider/provider.dart';

class ChooseActivityScreen extends StatelessWidget {
  const ChooseActivityScreen(
      {super.key, required this.isTask, required this.onActivityComplete});

  final Function({Activity? activity, Task? task}) onActivityComplete;

  final bool isTask;
  final double horizontalPadding = 15;

  void setCurrentActionType(ActionType actionType, BuildContext context) {
    Provider.of<ActivityProvider>(context, listen: false)
        .setCurrentActivity(actionType);
  }

  Future onActionTypeTap(
      {required ActionType actionType, required BuildContext context}) {
    setCurrentActionType(actionType, context);

    return Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => isTask
                ? CompleteTaskPage(
                    onActivityComplete: onActivityComplete,
                  )
                : AddActivityAmount(
                    onActivityComplete: onActivityComplete,
                  )));
  }

  @override
  Widget build(BuildContext context) {
    final List<ActionType> allActionTypes = kAllActionTypes;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const MySearchAppBar(),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Padding(
                  //   padding:
                  //       EdgeInsets.symmetric(horizontal: horizontalPadding),
                  //   child: const Text("Anbefalet"),
                  // ),
                  // ActionTypesGridView(
                  //     maxRows: 1,
                  //     actionTypes: allActionTypes,
                  //     onTap: (ActionType actionType) => onActionTypeTap(
                  //         actionType: actionType, context: context)),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: const Text("Alle"),
                  ),
                  ActionTypesGridView(
                      actionTypes: isTask
                          ? allActionTypes
                              .where((element) => element.asTask)
                              .toList()
                          : allActionTypes
                              .where((element) => element.asActivity)
                              .toList(),
                      onTap: (ActionType actionType) => onActionTypeTap(
                          actionType: actionType, context: context)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ActionTypesGridView extends StatelessWidget {
  const ActionTypesGridView(
      {super.key,
      required this.actionTypes,
      this.maxRows,
      required this.onTap});

  final List<ActionType> actionTypes;
  final int? maxRows;
  final Function(ActionType actionType) onTap;

  @override
  Widget build(BuildContext context) {
    int crossCount = 3;
    int listLength = actionTypes.length;
    int amountOfGenerates =
        maxRows == null || (listLength / crossCount).ceil() < maxRows!
            ? listLength
            : 3 * maxRows!;

    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 30,
      mainAxisSpacing: 30,
      children: List.generate(
          amountOfGenerates,
          (index) => ActivityCard(
                actionType: actionTypes[index],
                onTap: (ActionType actionType) =>
                    onTap(actionTypes[index]),
              )),
    );
  }
}
