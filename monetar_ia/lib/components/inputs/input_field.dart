import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String label;
  final bool isPassword;
  final TextInputType inputType;
  final TextEditingController controller;

  const InputField({
    super.key,
    required this.label,
    this.isPassword = false,
    required this.inputType,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
