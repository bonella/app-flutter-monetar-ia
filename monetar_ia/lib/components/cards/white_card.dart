import 'package:flutter/material.dart';

class WhiteCard extends StatelessWidget {
  final Widget child;

  const WhiteCard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
          // minHeight: 723,
          ),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: child,
      ),
    );
  }
}
