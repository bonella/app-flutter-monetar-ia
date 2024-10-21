import 'package:flutter/material.dart';

class PdfButton extends StatelessWidget {
  final VoidCallback onPressed;

  const PdfButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: IconButton(
        icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        onPressed: onPressed,
      ),
    );
  }
}
