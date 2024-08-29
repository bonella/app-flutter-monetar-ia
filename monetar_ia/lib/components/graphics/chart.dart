import 'package:flutter/material.dart';
import 'pizza_graphic.dart';
import 'line_graphic.dart';

class Chart extends StatelessWidget {
  const Chart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.circular(10),
        // border: Border.all(color: const Color(0xFF3D5936), width: 2),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Text(
          //   'Gráfico de Pizza',
          //   style: TextStyle(
          //     fontFamily: 'Roboto',
          //     fontWeight: FontWeight.w700,
          //     fontSize: 18,
          //     color: Color(0xFF21272A),
          //   ),
          // ),
          // SizedBox(height: 16),
          // PizzaGraphic(),
          // SizedBox(height: 16),
          Text(
            'Gráfico de Linha',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Color(0xFF21272A),
            ),
          ),
          SizedBox(height: 16),
          LineGraphic(),
        ],
      ),
    );
  }
}
