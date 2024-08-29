import 'package:flutter/material.dart';

class HeaderHome extends StatelessWidget {
  final String month;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;

  const HeaderHome({
    super.key,
    required this.month,
    required this.onPrevMonth,
    required this.onNextMonth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 430,
      height: 180,
      decoration: const BoxDecoration(
        color: Color(0xFF738C61),
        borderRadius: BorderRadius.only(
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
                        color: const Color(0xFF3D5936),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Center(
                        child: IconButton(
                          icon: const Icon(
                            Icons.keyboard_arrow_up,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {},
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Receitas',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'R\$ 1.000,00',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
                // Despesas
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8C1C03),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Center(
                        child: IconButton(
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {},
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Despesas',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'R\$ 800,00',
                          style: TextStyle(color: Colors.white, fontSize: 14),
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
    );
  }
}
