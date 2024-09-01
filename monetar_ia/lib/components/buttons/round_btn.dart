import 'package:flutter/material.dart';

class RoundButton extends StatefulWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final VoidCallback onPressed;

  const RoundButton({
    super.key,
    required this.icon,
    required this.backgroundColor,
    required this.borderColor,
    required this.iconColor,
    required this.onPressed,
  });

  @override
  _RoundButtonState createState() => _RoundButtonState();
}

class _RoundButtonState extends State<RoundButton> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
  }

  void _handleTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onPressed,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: _isPressed ? Colors.grey[300] : widget.backgroundColor,
          shape: BoxShape.circle,
          border: Border.all(color: widget.borderColor, width: 2),
        ),
        child: Center(
          child: Icon(
            widget.icon,
            color: widget.iconColor,
            size: 30,
          ),
        ),
      ),
    );
  }
}
