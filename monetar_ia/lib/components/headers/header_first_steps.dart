import 'package:flutter/material.dart';

class HeaderFirstSteps extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color backgroundColor;

  const HeaderFirstSteps({
    super.key,
    required this.title,
    required this.subtitle,
    this.backgroundColor = const Color(0xFF738C61),
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          width: double.infinity,
          height: 300,
          color: Colors.white,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: backgroundColor,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 40),
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Kumbh Sans',
                    fontWeight: FontWeight.w400,
                    fontSize: 44,
                    letterSpacing: 0.04,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                ClipOval(
                  child: Image.asset(
                    'lib/assets/logo2.png',
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Kumbh Sans',
                    fontWeight: FontWeight.w400,
                    fontSize: 22,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            height: 20,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
