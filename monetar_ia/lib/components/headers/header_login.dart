import 'package:flutter/material.dart';

class HeaderLogin extends StatefulWidget {
  const HeaderLogin({super.key});

  @override
  _HeaderLoginState createState() => _HeaderLoginState();
}

class _HeaderLoginState extends State<HeaderLogin>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        color: const Color(0xFFE4F2E6),
        constraints: const BoxConstraints(
          maxHeight: 200,
        ),
        child: Stack(
          children: [
            Positioned(
              right: 5,
              left: 5,
              bottom: 5,
              top: 5,
              child: SizedBox(
                width: 300,
                height: 250,
                child: AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: Image.asset('lib/assets/logo.png'),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
