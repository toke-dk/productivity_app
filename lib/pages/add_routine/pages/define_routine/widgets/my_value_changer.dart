import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../shared/decorations.dart';

class RangeFormatter extends TextInputFormatter {
  final int? minValue;
  final int? maxValue;

  RangeFormatter({required this.minValue, required this.maxValue});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;
    double newValueAsDouble = double.parse(newValue.text);
    if (minValue != null && newValueAsDouble < minValue!) {
      return TextEditingValue().copyWith(text: minValue!.toString());
    } else if (maxValue != null && newValueAsDouble > maxValue!) {
      return TextEditingValue().copyWith(text: maxValue!.toString());
    } else {
      return newValue;
    }
  }
}

class MyValueChanger extends StatefulWidget {
  const MyValueChanger(
      {super.key, required this.handleValueChange, this.maxValue, this.minValue = 1});

  final Function(int newVal) handleValueChange;
  final int? maxValue;
  final int? minValue;

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
        (widget.maxValue != null && intValue! >= widget.maxValue!))
      return;
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

  // make this correct
  bool get isAddEnabled {
    final int? intValue = int.tryParse(_controller.text);
    if (intValue == null || widget.maxValue == null) return true;
    if(intValue+1 <= widget.maxValue!) return true;
    return false;
  }

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
                    if (int.tryParse(newString) == null) return;
                    widget.handleValueChange(int.parse(newString));
                  },
                  controller: _controller,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, RangeFormatter(minValue: 1, maxValue: widget.maxValue)],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          _ChangeValueIcon(
              subtract: false,
              onPressed: isAddEnabled ? () => _handleGoalValueIncrement(_controller.text) : null),
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
