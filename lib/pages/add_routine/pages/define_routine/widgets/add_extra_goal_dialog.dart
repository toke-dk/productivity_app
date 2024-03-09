import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/decorations.dart';
import '../define_routine.dart';

enum TimeUnit {
  year('for et år'),
  month('for en måned'),
  total("i alt"),
  week("for en uge");

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

  bool _exactEndDateActivated = false;

  int goalValue = 0;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text("Tilføj et Ekstra-Mål"),
      contentPadding: EdgeInsets.all(30),
      children: [
        Text(
          "Mål ${widget.timeUnit.translatedName}",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        SizedBox(
          height: 10,
        ),
        MyValueChanger(
          handleValueChange: (int newVal) {
            setState(() {
              goalValue = newVal;
            });
          },
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

class MyValueChanger extends StatefulWidget {
  const MyValueChanger(
      {super.key, required this.handleValueChange, this.maxValue});

  final Function(int newVal) handleValueChange;
  final int? maxValue;

  @override
  State<MyValueChanger> createState() => _MyValueChangerState();
}

class _MyValueChangerState extends State<MyValueChanger> {
  void _handleGoalValueDecrement(String textValue) {
    if (int.tryParse(textValue) == null || int.parse(textValue) <= 0) {
      setState(() {
        _controller.text = "0";
      });
      widget.handleValueChange(0);
    } else {
      setState(() {
        _controller.text = (int.parse(textValue) - 1).toString();
      });
      widget.handleValueChange((int.parse(textValue) - 1));
    }
  }

  void _handleGoalValueIncrement(String textValue) {
    final int? intValue = int.tryParse(textValue);

    if (int.tryParse(textValue) == null ||
        (widget.maxValue != null && intValue! >= widget.maxValue!)) return;

    else if (intValue! < 0) {
      setState(() {
        _controller.text = "1";
      });
      widget.handleValueChange(1);
    } else {
      setState(() {
        _controller.text = (intValue + 1).toString();
      });
      widget.handleValueChange((intValue + 1));
    }
  }

  late TextEditingController _controller = TextEditingController(text: "0");

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ChangeValueIcon(
            subtract: true,
            onPressed: () => _handleGoalValueDecrement(_controller.text),
          ),
          Flexible(
            flex: 2,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  decoration: kMyInputDecoration.copyWith(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                      isDense: true),
                  onChanged: (String newString) {
                    widget.handleValueChange(int.parse(newString));
                  },
                  controller: _controller,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          _ChangeValueIcon(
              subtract: false,
              onPressed: () => _handleGoalValueIncrement(_controller.text)),
        ],
      ),
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
