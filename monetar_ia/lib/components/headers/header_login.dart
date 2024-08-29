import 'package:flutter/material.dart';

class HeaderLogin extends StatelessWidget {
  const HeaderLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFE4F2E6),
      child: Stack(
        children: [
          Positioned(
            right: -33,
            top: -21,
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: 328,
                height: 452,
                child: Image.asset('lib/assets/efigie.png'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
