import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final Color? colorBorder;
  final Color? textColor;
  final bool isFilled;
  final Color? filledColor;
  final double? height;
  const ButtonWidget(
      {super.key,
      required this.onTap,
      required this.title,
      this.colorBorder,
      this.textColor,
      required this.isFilled,
      this.filledColor,
      this.height});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? 50,
        width: 200,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: isFilled ? filledColor : Colors.transparent,
            border: Border.all(width: 2, color: colorBorder ?? Colors.white)),
        child: Center(
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              color: textColor ?? Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }
}
