import 'package:flutter/material.dart';

class HeaderAdd extends StatelessWidget {
  final String month;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;
  final Color backgroundColor;
  final IconData circleIcon;
  final Color circleIconColor;
  final Color circleBackgroundColor;
  final String label;
  final String value;

  const HeaderAdd({
    super.key,
    required this.month,
    required this.onPrevMonth,
    required this.onNextMonth,
    required this.backgroundColor,
    required this.circleIcon,
    required this.circleIconColor,
    required this.circleBackgroundColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 36.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: onPrevMonth,
                  ),
                  const SizedBox(width: 20),
                  Text(
                    month,
                    style: const TextStyle(
                      fontFamily: 'Kumbh Sans',
                      fontWeight: FontWeight.w400,
                      fontSize: 22,
                      color: Color(0xFFFFFFFF),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: onNextMonth,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: circleBackgroundColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Center(
                          child: IconButton(
                            icon: Icon(
                              circleIcon,
                              color: circleIconColor,
                              size: 20,
                            ),
                            onPressed: () {},
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            label,
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            value,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
