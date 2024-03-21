import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:productivity_app/models/category.dart';
import 'package:productivity_app/models/providers/routine_provider.dart';
import 'package:productivity_app/models/routine.dart';
import 'package:productivity_app/pages/add_routine/add_routine.dart';
import 'package:productivity_app/pages/add_routine/pages/define_routine/widgets/add_extra_goal_button.dart';
import 'package:productivity_app/pages/add_routine/pages/define_routine/widgets/frequency_widget.dart';
import 'package:productivity_app/pages/add_routine/pages/define_routine/widgets/my_value_changer.dart';
import 'package:productivity_app/pages/add_routine/pages/define_routine/widgets/with_end_date_widget.dart';
import 'package:productivity_app/widgets/my_date_picker.dart';
import 'package:provider/provider.dart';
import '../../../../shared/decorations.dart';

enum Quantity {
  atLeast("Mindst"),
  inTotal("Total"),
  unLimited("Ubegrænset");

  const Quantity(this.label);

  final String label;
}

class DefineRoutinePage extends StatefulWidget {
  const DefineRoutinePage({
    super.key,
    required this.pageTitle,
    required this.onNextPagePressed,
  });

  final Widget pageTitle;
  final Function() onNextPagePressed;

  @override
  State<DefineRoutinePage> createState() => _DefineRoutinePageState();
}

class _DefineRoutinePageState<Object> extends State<DefineRoutinePage> {
  EvaluationType get evaluationType =>
      Provider.of<RoutineProvider>(context).evaluationType!;

  Quantity selectedFrequency = Quantity.atLeast;
  String? routineName = "";
  String? description;
  int? goal;
  bool _filledRequiredTexts = false;
  bool _canContinue = true;

  Widget get generateRoutineText {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
          text: TextSpan(style: textTheme.bodyMedium, children: [
        TextSpan(text: "[Rutine]\n", style: textTheme.bodyLarge),
        TextSpan(text: "[Rutineforklaring?]\n\n", style: textTheme.labelMedium),
        TextSpan(text: "Mit mål er at jeg vil lave 'mindst' [mål] [enhed?]\n"),
        TextSpan(text: "Mit mål er at jeg vil lave [mål] [enhed?] i alt \n"),
        TextSpan(text: "Jeg vil blive ved med at lave [Rutinenavn]\n\n"),
        TextSpan(
            text:
                "Derudover vil jeg også opnå mit 'ekstra-mål' om at [ekstra mål tekst]"),
      ])),
    );
  }

  void _onStartDateChange(DateTime newDate) {
    Provider.of<RoutineProvider>(context, listen: false).setStartDate = newDate;
  }

  void _onEndDateChange(DateTime newDate) {
    Provider.of<RoutineProvider>(context, listen: false).setEndDate = newDate;
  }

  void _onEnDateOptionChange(bool value) {
    Provider.of<RoutineProvider>(context, listen: false).setHasEndDate = value;
  }

  DateTime get _selectedEndDate =>
      Provider.of<RoutineProvider>(context).endDate;

  bool get _isEndDateOptionSelected =>
      Provider.of<RoutineProvider>(context).hasEndDate;

  DateTime get _startDate => Provider.of<RoutineProvider>(context).startDate;

  final _routineNameKey = GlobalKey<FormState>();

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.pageTitle,
            Form(
              key: _routineNameKey,
              child: TextFormField(
                  validator: (value) {
                    if (value == null || value == "") {
                      return "Giv rutinen et navn";
                    }
                    return null;
                  },
                  onChanged: (String newText) {
                    Provider.of<RoutineProvider>(context, listen: false)
                        .setName = newText;
                  },
                  textCapitalization: TextCapitalization.words,
                  decoration: kMyInputDecoration.copyWith(
                      labelText: "Rutine*", hintText: "Navn på din rutine...")),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
                onChanged: (String newText) {
                  Provider.of<RoutineProvider>(context, listen: false)
                      .setDescription = newText;
                },
                textCapitalization: TextCapitalization.sentences,
                maxLines: 3,
                decoration: kMyInputDecoration.copyWith(
                    hintText: "Med denne rutine skal jeg...",
                    labelText: "Forklaring (valgfri)",
                    alignLabelWithHint: true)),
            evaluationType == EvaluationType.numeric
                ? Column(
                    children: [
                      Divider(
                        height: 40,
                      ),
                      _NumericOptionsWidget(
                          selectedFrequency: selectedFrequency,
                          onFrequencyChange: (Quantity frequency) {
                            setState(() {
                              selectedFrequency = frequency;
                            });
                          }),
                      SizedBox(
                        height: 15,
                      ),
                      AddExtraGoalButton(),
                    ],
                  )
                : SizedBox.shrink(),
            Divider(
              height: 40,
            ),
            ChooseFrequency(),
            Divider(
              height: 30,
            ),
            Text(
              "Startdato",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(
              height: 5,
            ),
            MyDatePicker(
                selectedDate: _startDate, onDateSelected: _onStartDateChange),
            SizedBox(
              height: 10,
            ),
            WithEndDateWidget(
              onDateChange: _onEndDateChange,
              selectedDate: _selectedEndDate,
              switchValue: _isEndDateOptionSelected,
              onSwitchChange: _onEnDateOptionChange,
            ),
            Divider(
              height: 30,
            ),
            SizedBox(
              height: 10,
            ),
            Align(
                alignment: Alignment.center,
                child: FilledButton(
                    onPressed: () {
                      if (!_routineNameKey.currentState!.validate()) {
                        _scrollController.animateTo(0,
                            duration: 300.milliseconds,
                            curve: Curves.easeInOutQuad);
                      } else {
                        widget.onNextPagePressed();
                      }
                    },
                    child: Text("Næste"))),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}

class _NumericOptionsWidget extends StatelessWidget {
  const _NumericOptionsWidget(
      {super.key,
      required this.selectedFrequency,
      required this.onFrequencyChange});

  final Quantity selectedFrequency;
  final Function(Quantity newFrequency) onFrequencyChange;

  @override
  Widget build(BuildContext context) {
    void _handleValueChange(int value) {
      Provider.of<RoutineProvider>(context, listen: false).setAmountForOneDay =
          value;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 150,
          child: TextField(
              onChanged: (String newText) {
                Provider.of<RoutineProvider>(context, listen: false)
                    .setUnitName = newText;
              },
              decoration: kMyInputDecoration.copyWith(
                  labelText: "Enhed (valgfri)", hintText: "eks. km.")),
        ),
        SizedBox(
          height: 12,
        ),
        Row(
          children: [
            Expanded(
              child: DropdownButton<Quantity>(
                  underline: SizedBox.shrink(),
                  value: selectedFrequency,
                  onChanged: (Quantity? frequency) {
                    if (frequency != null) onFrequencyChange(frequency);
                  },
                  items: Quantity.values
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e.label),
                          ))
                      .toList()),
            ),
            Expanded(
                child: MyValueChanger(
              handleValueChange: _handleValueChange,
              hintText: "Antal",
              value: Provider.of<RoutineProvider>(context).amountForOneDay,
            )),
          ],
        ),
        SizedBox(
          height: 12,
        ),
        Row(
          children: [
            Text(
              "Færdiggørelser",
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Text(
              " for én dag",
              style: Theme.of(context).textTheme.labelMedium,
            )
                .animate(target: selectedFrequency == Quantity.atLeast ? 1 : 0)
                .show()
                .then()
                .slide(),
          ],
        ),
      ],
    );
  }
}
