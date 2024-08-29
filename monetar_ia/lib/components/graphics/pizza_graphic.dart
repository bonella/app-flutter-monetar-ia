import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PizzaGraphic extends StatelessWidget {
  const PizzaGraphic({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF3D5936), width: 2),
      ),
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              color: Colors.blue,
              value: 30,
              title: '30%',
              radius: 60,
            ),
            PieChartSectionData(
              color: Colors.red,
              value: 70,
              title: '70%',
              radius: 60,
            ),
          ],
          borderData: FlBorderData(show: false),
          sectionsSpace: 0,
          centerSpaceRadius: 40,
        ),
      ),
    );
  }
}
