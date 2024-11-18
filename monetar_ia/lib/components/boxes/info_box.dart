import 'package:flutter/material.dart';

class InfoBox extends StatelessWidget {
  final String title;
  final String description;
  final bool showBadge;
  final String percentage;
  final Color backgroundColor;
  final Color borderColor;
  final Color badgeColor;
  final String creationDate;
  final VoidCallback? onTap;
  final bool isEditable;

  const InfoBox({
    super.key,
    required this.title,
    required this.description,
    this.showBadge = false,
    this.percentage = '',
    this.backgroundColor = const Color(0xFF3D5936),
    this.borderColor = const Color(0xFF3D5936),
    this.badgeColor = const Color(0xFF3D5936),
    required this.creationDate,
    this.onTap,
    this.isEditable = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        onEnter: (_) {},
        onExit: (_) {},
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
            border: Border(
              top: BorderSide.none,
              right: BorderSide.none,
              left: BorderSide(color: borderColor, width: 5),
              bottom: BorderSide(color: borderColor, width: 5),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.9),
                spreadRadius: 3,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and Edit Icon
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color(0xFF697077),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isEditable)
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Color(0xFF3D5936),
                        size: 20,
                      ),
                      onPressed:
                          onTap, // Call onTap when the edit button is pressed
                    ),
                ],
              ),
              // Description and Badge
              Row(
                children: [
                  Expanded(
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
                  if (showBadge)
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      width: 60,
                      height: 24,
                      decoration: BoxDecoration(
                        color: badgeColor,
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
                ],
              ),
              // Creation Date
              Text(
                'Data da criação: $creationDate',
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Color(0xFF697077),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
