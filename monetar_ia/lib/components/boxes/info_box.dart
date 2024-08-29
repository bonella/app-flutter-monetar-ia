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
      height: 90,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF3D5936), width: 2),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xFF697077),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 8),
              Flexible(
                child: Text(
                  description,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Color(0xFF21272A),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (showBadge)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 60,
                // height: 20,
                margin: const EdgeInsets.symmetric(horizontal: 6.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF3D5936),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                alignment: Alignment.center,
                child: Text(
                  percentage,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
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
