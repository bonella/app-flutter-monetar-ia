import 'package:flutter/material.dart';

class BtnOutlineGreen extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color textColor;
  final Color borderColor;

  const BtnOutlineGreen({
    super.key,
    required this.onPressed,
    required this.text,
    this.textColor = const Color(0xFF738C61),
    this.borderColor = const Color(0xFF738C61),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
