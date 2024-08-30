import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const RoundButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF3D5936), width: 2),
        ),
        child: Center(
          child: Icon(
            icon,
            color: const Color(0xFF3D5936),
            size: 30,
          ),
        ),
      ),
    );
  }
}
