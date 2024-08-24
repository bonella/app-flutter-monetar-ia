import 'package:flutter/material.dart';

class BtnEnter extends StatelessWidget {
  final VoidCallback onPressed;

  const BtnEnter({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      height: 50,
      margin: const EdgeInsets.only(top: 717, left: 85),
      decoration: BoxDecoration(
        color: const Color(0xFF738C61),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: Colors.white,
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
        child: const Center(
          child: Text(
            'Enter',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
