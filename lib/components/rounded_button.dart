import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton({ required this.widgetText, required this.color, required this.onPressed, required this.width, required this.height});

  final Color color;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final Widget widgetText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: width,
          height: height,
          child: widgetText,
        ),
      ),
    );
  }
}

//min width 200.0
//height 42