import 'package:flutter/material.dart';

class BtnScroll extends StatefulWidget {
  final ScrollController scrollController;

  const BtnScroll({super.key, required this.scrollController});

  @override
  _BtnScrollState createState() => _BtnScrollState();
}

class _BtnScrollState extends State<BtnScroll>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.0, end: 8.0).animate(
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AnimatedBuilder(
          animation: _glowAnimation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.7),
                    blurRadius: _glowAnimation.value,
                    spreadRadius: _glowAnimation.value,
                  ),
                ],
              ),
              child: FloatingActionButton(
                onPressed: () {
                  widget.scrollController.animateTo(
                    widget.scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                backgroundColor: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(
                  Icons.arrow_downward,
                  color: Color(0xFF738C61),
                  size: 40.0,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        const Text(
          'Clique aqui',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
      ],
    );
  }
}
