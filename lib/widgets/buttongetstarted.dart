import 'package:flutter/material.dart';

class buttonGetstarted extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? textColor;
  final Color? colorT;
  final double? sizeW;
  final double? sizeH;
  final double? fontSize;
  final double? borderRs;
  final VoidCallback onPressed;
  final FontWeight? fontWeight;
  final bool isEnabled;

  buttonGetstarted({
    required this.text,
    this.color,
    this.textColor,
    this.colorT,
    this.sizeH,
    this.sizeW,
    this.fontSize,
    this.borderRs,
    this.fontWeight,
    this.isEnabled = true, // Default is enabled
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: sizeW,
      height: sizeH, // You can adjust the height proportionally
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled ? color : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                borderRs ?? 10), // Adjust the border radius
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: fontWeight,
            color: textColor,
            fontSize: fontSize,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }
}
