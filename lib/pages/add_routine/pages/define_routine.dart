import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:productivity_app/shared/extensions/date_time_extensions.dart';

enum Frequencies {
  atLeast("Mindst"),
  inTotal("Total"),
  unLimited("Ubegrænset");

  const Frequencies(this.label);

  final String label;
}

class DefineRoutinePage extends StatefulWidget {
  const DefineRoutinePage({super.key, required this.pageTitle});

  final Widget pageTitle;

  @override
  State<DefineRoutinePage> createState() => _DefineRoutinePageState();
}

class _DefineRoutinePageState<Object> extends State<DefineRoutinePage> {
  Frequencies selectedFrequency = Frequencies.atLeast;
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

  void openAddExtraGoalDialog(TimeUnit timeUnit) {
    showDialog(
        context: context,
        builder: (context) {
          return AddExtraGoalDialog(timeUnit: timeUnit,);
        });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.pageTitle,
            TextField(
                textCapitalization: TextCapitalization.words,
                decoration: myInputDecoration.copyWith(
                    labelText: "Rutine*", hintText: "Navn på din rutine...")),
            SizedBox(
              height: 20,
            ),
            TextField(
                textCapitalization: TextCapitalization.sentences,
                maxLines: 3,
                decoration: myInputDecoration.copyWith(
                    hintText: "Med denne rutine skal jeg...",
                    labelText: "Forklaring (valgfri)",
                    alignLabelWithHint: true)),
            SizedBox(
              height: 40,
            ),
            SizedBox(
              height: 50,
              child: Align(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  child: DropdownMenu(
                      initialSelection: Frequencies.atLeast,
                      onSelected: (Frequencies? frequency) {
                        if (frequency != null)
                          setState(() {
                            selectedFrequency = frequency;
                          });
                      },
                      dropdownMenuEntries: Frequencies.values
                          .map((e) =>
                              DropdownMenuEntry(value: e, label: e.label))
                          .toList()),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                    child: TextField(
                        keyboardType: TextInputType.number,
                        enabled: selectedFrequency != Frequencies.unLimited,
                        decoration: myInputDecoration.copyWith(
                          labelText: "Mål*",
                        ))),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: TextField(
                        decoration: myInputDecoration.copyWith(
                            labelText: "Enhed (valgfri)",
                            hintText: "eks. km."))),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "for én dag",
              style: Theme.of(context).textTheme.labelMedium,
            )
                .animate(
                    target: selectedFrequency == Frequencies.atLeast ? 1 : 0)
                .show()
                .then()
                .slide(),
            SizedBox(
              height: 10,
            ),
            _NewGoalButton(
              title: "test",
              onPressed: () => openAddExtraGoalDialog(TimeUnit.week),
            ),
            _NewGoalButton(
              leading: Icon(Icons.emoji_flags_sharp),
              title: "Tilføj et Ekstra-Mål",
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      final double space = 10;
                      return Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 30, horizontal: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Ekstra-Mål",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(
                              "Her kan du vælge at lave et mål ud fra dit daglige mål",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            _ExtraGoalButton(
                              title: "Uge mål",
                              onTap: () {
                                openAddExtraGoalDialog(TimeUnit.week);
                              },
                            ),
                            SizedBox(
                              height: space,
                            ),
                            _ExtraGoalButton(
                              title: "Måned mål",
                              onTap: () {},
                            ),
                            SizedBox(
                              height: space,
                            ),
                            _ExtraGoalButton(
                              title: "År mål",
                              onTap: () {},
                            ),
                            SizedBox(
                              height: space,
                            ),
                            _ExtraGoalButton(
                              title: "Total mål",
                              onTap: () {},
                            ),
                          ],
                        ),
                      );
                    });
              },
            ),
          ],
        ),
      ),
    );
  }
}

enum TimeUnit {
  year('år'),
  month('måned'),
  week("uge");
  const TimeUnit(this.translatedName);
  final String translatedName;
}


class AddExtraGoalDialog extends StatefulWidget {
  final TimeUnit timeUnit;
  const AddExtraGoalDialog({super.key, required this.timeUnit});

  @override
  State<AddExtraGoalDialog> createState() => _AddExtraGoalDialogState();
}

class _AddExtraGoalDialogState extends State<AddExtraGoalDialog> {
  late TextEditingController _goalText;

  @override
  void initState() {
    super.initState();
    _goalText = new TextEditingController(text: '0');
  }

  void handleGoalValueDecrement() {
    setState(() {
      if (int.tryParse(_goalText.text) == null ||
          int.parse(_goalText.text) <= 0)
        _goalText.text = "0";
      else
        _goalText.text = (int.parse(_goalText.text) - 1).toString();
    });
  }

  void handleGoalValueIncrement() {
    setState(() {
      if (int.tryParse(_goalText.text) == null || int.parse(_goalText.text) < 0)
        _goalText.text = "1";
      else
        _goalText.text = (int.parse(_goalText.text) + 1).toString();
    });
  }

  bool _exactEndDateActivated = false;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text("Tilføj et Ekstra-Mål"),
      contentPadding: EdgeInsets.all(30),
      children: [
        Text(
          "Mål for en ${widget.timeUnit.translatedName}",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Spacer(),
            _ChangeValueIcon(
              subtract: true,
              onPressed: () => handleGoalValueDecrement(),
            ),
            Flexible(
              flex: 2,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    decoration: myInputDecoration.copyWith(),
                    controller: _goalText,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            _ChangeValueIcon(
              subtract: false,
              onPressed: () {
                handleGoalValueIncrement();
              },
            ),
            Spacer(),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        _StartDateField(),
        SizedBox(
          height: 20,
        ),
        SwitchListTile(
          value: _exactEndDateActivated,
          onChanged: (newVal) {
            setState(() {
              _exactEndDateActivated = !_exactEndDateActivated;
            });
          },
          title: Text("Afslutning"),
          subtitle:
              Text("Vil du afslutte rutinen når ekstra-målet er fuldført?"),
        ),
        SizedBox(
          height: 18,
        ),
        FilledButton(
            onPressed: () {
              print("finished");
            },
            child: Text("Opret mål"))
      ],
    );
  }
}

const double _kPanelHeaderCollapsedHeight = kMinInteractiveDimension;
const EdgeInsets _kPanelHeaderExpandedDefaultPadding = EdgeInsets.symmetric(
  vertical: 64.0 - _kPanelHeaderCollapsedHeight,
);

class _StartDateField extends StatefulWidget {
  const _StartDateField({super.key});

  @override
  State<_StartDateField> createState() => _StartDateFieldState();
}

class _StartDateFieldState extends State<_StartDateField>
    with SingleTickerProviderStateMixin {
  bool isVisible = false;
  late AnimationController _animationController;
  late Animation<double> _animation;
  late TextEditingController _dateTextController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: 300.milliseconds,
    );

    _dateTextController =
        TextEditingController(text: _themeFormat.format(_selectedDate));

    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
  }

  final DateFormat _themeFormat = DateFormat("EEE. dd. MMM. yyyy");

  DateTime _firstDateOption = DateTime(
      DateTime.now().year - 10, DateTime.now().month, DateTime.now().day);
  DateTime _lastDateOption = DateTime(
      DateTime.now().year + 10, DateTime.now().month, DateTime.now().day);
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          value: isVisible,
          onChanged: (newVal) {
            setState(() {
              isVisible = !isVisible;
              if (isVisible) {
                _animationController.forward();
              } else {
                _animationController.reverse();
              }
            });
          },
          title: Text("Start dato"),
        ),
        SizeTransition(
          sizeFactor: _animation,
          child: GestureDetector(
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                  context: context,
                  firstDate: _firstDateOption,
                  lastDate: _lastDateOption,
                  initialDate: _selectedDate);
              if (pickedDate != null && pickedDate != _selectedDate) {
                setState(() {
                  _selectedDate = pickedDate;
                });
              }
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(color: Colors.grey[900]!)),
              child: Row(
                children: [
                  Icon(Icons.date_range),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    DateFormat("EEE. dd. MMM. yyyy").format(_selectedDate),
                  ),
                  Spacer()
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ChangeValueIcon extends StatelessWidget {
  const _ChangeValueIcon({super.key, this.subtract = false, this.onPressed});

  final bool subtract;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      child: FilledButton(
          style: ButtonStyle(
              padding: MaterialStatePropertyAll(EdgeInsets.all(0)),
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2)))),
          onPressed: onPressed,
          child: subtract ? Icon(Icons.remove) : Icon(Icons.add)),
    );
  }
}

class _ExtraGoalButton extends StatelessWidget {
  const _ExtraGoalButton({super.key, required this.title, this.onTap});

  final String title;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: onTap,
        style: ButtonStyle(
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              textAlign: TextAlign.start,
            ),
            Spacer(),
            Container(
              width: 1,
              height: 50,
              color: Colors.black.withOpacity(0.3),
            ),
            SizedBox(
              width: 12,
            ),
            Icon(Icons.add),
          ],
        ));
  }
}

class _NewGoalButton extends StatelessWidget {
  const _NewGoalButton(
      {super.key,
      this.onPressed,
      required this.title,
      this.description,
      this.trailing = const SizedBox(),
      this.leading = const SizedBox()});

  final Function()? onPressed;
  final Widget leading;
  final String title;
  final String? description;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        child: Row(
          children: [
            leading,
            SizedBox(
              width: 10,
            ),
            Text(
              title,
            ),
            Spacer(),
            trailing,
          ],
        ),
        style: ButtonStyle(
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6)))),
      ),
    );
  }
}

InputDecoration myInputDecoration = InputDecoration(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(9)));
