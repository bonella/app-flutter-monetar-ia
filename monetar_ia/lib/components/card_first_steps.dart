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
                top: 16.0, left: 16.0, right: 16.0, bottom: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                if (title != null) ...[
                  Text(
                    title!,
                    style: const TextStyle(
                      fontFamily: 'Kumbh Sans',
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
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
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                        side: const BorderSide(color: Color(0xFF3D5936)),
                      ),
                    ),
                    child: Text(label),
                  ),
                  const SizedBox(height: 10),
                ],
              ],
            ),
          ),
          Positioned(
            bottom: -25,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 260,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: const Color(0xFF738C61),
                    width: 2,
                  ),
                ),
                child: TextButton(
                  onPressed: onNextPressed,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Próximo',
                      style: TextStyle(
                        color: Color(0xFF738C61),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
