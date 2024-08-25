import 'package:flutter/material.dart';

class InfoBox extends StatelessWidget {
  final String title;
  final String description;
  final bool showBadge;
  final String percentage;

  const InfoBox({
    super.key,
    required this.title,
    required this.description,
    this.showBadge = false,
    this.percentage = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 361,
      height: 80,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF3D5936), width: 2),
      ),
      child: Stack(
        children: [
          // Conteúdo do InfoBox
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showBadge) ...[
                // Badge widget here
              ],
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Kumbh Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  color: Color(0xFF3D5936),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(
                  fontFamily: 'Kumbh Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Color(0xFF3D5936),
                ),
              ),
            ],
          ),
          // Oval com porcentagem
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: const Color(0xFF3D5936),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              alignment: Alignment.center,
              child: Text(
                percentage,
                style: const TextStyle(
                  fontFamily: 'Kumbh Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
