import 'package:flutter/material.dart';

class BtnSignUp extends StatelessWidget {
  final VoidCallback onPressed;

  const BtnSignUp({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: const Color(0xFF738C61),
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
            'Cadastrar',
            style: TextStyle(
              color: Color(0xFF738C61),
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
