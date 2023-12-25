import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MyThemeButton extends StatefulWidget {
  const MyThemeButton(
      {super.key,
      this.labelText,
      required this.onTap,
      this.leadingIcon,
      this.trailingIcon});

  final String? labelText;
  final GestureTapCallback? onTap;
  final IconData? leadingIcon;
  final IconData? trailingIcon;

  @override
  State<MyThemeButton> createState() => _MyThemeButtonState();
}

class _MyThemeButtonState extends State<MyThemeButton> {
  bool isToggled = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final Color foreGroundColor = widget.onTap != null
        ? theme.colorScheme.onPrimaryContainer
        : theme.colorScheme.onPrimary;

    final Color backGroundColor = widget.onTap != null
        ? theme.colorScheme.primaryContainer
        : theme.disabledColor;

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(boxShadow: [
        !isToggled
            ? BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: Offset(3, 3),
                blurRadius: 4,
                spreadRadius: 1,
              )
            : BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: Offset(3, 3),
                blurRadius: 4,
                spreadRadius: 1,
              ),
      ], borderRadius: BorderRadius.circular(30), color: backGroundColor),
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTapDown: widget.onTap != null ? (TapDownDetails _) {
          setState(() {
            isToggled = true;
          });
        } : null,
        onTapUp: (_) => setState(() {
          isToggled = false;
        }),
        onTap: widget.onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.leadingIcon != null
                ? Padding(
                    padding: EdgeInsets.only(
                        right: widget.labelText != null ||
                                widget.leadingIcon != null
                            ? 8
                            : 0),
                    child: Icon(
                      widget.leadingIcon,
                      color: foreGroundColor,
                    ),
                  )
                : SizedBox(),
            widget.labelText != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Text(
                      widget.labelText!,
                      style: TextStyle(color: foreGroundColor),
                    ),
                  )
                : SizedBox(),
            widget.trailingIcon != null
                ? Padding(
                    padding: EdgeInsets.only(
                        left: widget.labelText != null ||
                                widget.leadingIcon != null
                            ? 8
                            : 0),
                    child: Icon(
                      widget.trailingIcon,
                      color: foreGroundColor,
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    ).animate(target: isToggled ? 1 : 0).scaleXY(end: 0.99, duration: 50.ms);
  }
}
