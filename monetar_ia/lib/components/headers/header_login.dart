import 'package:flutter/material.dart';

class HeaderLogin extends StatelessWidget {
  const HeaderLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFE4F2E6),
      constraints: const BoxConstraints(
        maxHeight: 260,
      ),
      child: Stack(
        children: [
          Positioned(
            right: -33,
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: 300,
                child: Image.asset('lib/assets/efigie.png'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
