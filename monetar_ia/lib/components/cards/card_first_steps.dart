import 'package:flutter/material.dart';

class CardFirstSteps extends StatelessWidget {
  final List<String> buttonLabels;
  final void Function(String)? onButtonPressed;
  final String? title;
  final VoidCallback? onNextPressed;

  const CardFirstSteps({
    super.key,
    required this.buttonLabels,
    this.onButtonPressed,
    this.title,
    this.onNextPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
                top: 8, left: 16.0, right: 16.0, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                if (title != null) ...[
                  Text(
                    title!,
                    style: const TextStyle(
                      fontFamily: 'Kumbh Sans',
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                      color: Color(0xFF3D5936),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                ],
                for (var label in buttonLabels) ...[
                  ElevatedButton(
                    onPressed: () => onButtonPressed?.call(label),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color(0xFF3D5936),
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                        side: const BorderSide(color: Color(0xFF3D5936)),
                      ),
                    ),
                    child: Text(
                      label,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
