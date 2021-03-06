// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class RuzgarButton extends StatelessWidget {
  final String buttonText;
  final Color buttonColor;
  final Color borderColor;
  final Color textColor;
  final double radius;
  final double height;
  final double width;
  final Widget? buttonIcon;
  final VoidCallback? onPressed;
  final Color color;
  final FontWeight fontWeight;
  final double fontSize;

  const RuzgarButton(
      {
      required this.buttonText,
      this.buttonColor = Colors.blue,
      this.textColor = Colors.white,
      this.borderColor = Colors.blue,
      this.radius = 10,
      this.height = 40,
      this.width = 100,
      this.buttonIcon,
      this.onPressed,
      this.color = Colors.blue,
      this.fontWeight = FontWeight.w500,
      this.fontSize = 12});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        height: height,
        width: width,
        child: RawMaterialButton(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: borderColor,
            ),
            borderRadius: BorderRadius.circular(radius),
          ),
          fillColor: buttonColor,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buttonIcon != null ? Expanded(child: Container()) : SizedBox(),
              Expanded(
                child: Center(
                  child: Text(
                    buttonText,
                    style: TextStyle(
                        fontSize: fontSize,
                        color: textColor,
                        fontWeight: fontWeight),
                  ),
                ),
              ),
            ],
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
