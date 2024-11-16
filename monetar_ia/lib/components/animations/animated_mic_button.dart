import 'package:flutter/material.dart';
import 'dart:math';

class AnimatedMicButton extends StatefulWidget {
  final bool listening;
  final VoidCallback onPressed;

  const AnimatedMicButton({
    super.key,
    required this.listening,
    required this.onPressed,
  });

  @override
  _AnimatedMicButtonState createState() => _AnimatedMicButtonState();
}

class _AnimatedMicButtonState extends State<AnimatedMicButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Animação de Pulso
          if (widget.listening)
            AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Container(
                  width: 80 * _scaleAnimation.value,
                  height: 80 * _scaleAnimation.value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.withOpacity(0.3),
                  ),
                );
              },
            ),
          // Botão de Microfone
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF3D5936), width: 2),
            ),
            child: Icon(
              widget.listening ? Icons.stop : Icons.mic,
              color: widget.listening
                  ? const Color(0xFF8C1C03)
                  : const Color(0xFF3D5936),
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
