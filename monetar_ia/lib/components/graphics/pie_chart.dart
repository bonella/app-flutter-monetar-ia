import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CustomPieChart extends StatelessWidget {
  final String title;

  const CustomPieChart({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF3D5936),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Color(0xFF21272A),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildLegendCircle(
                  color: const Color(0xFF3D5936), text: 'Receitas'),
              const SizedBox(width: 16),
              _buildLegendCircle(
                  color: const Color(0xFF8C1C03), text: 'Despesas'),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: PieChart(
              PieChartData(
                sectionsSpace: 0,
                centerSpaceRadius: 40,
                sections: [
                  PieChartSectionData(
                    value: 70,
                    color: const Color(0xFF3D5936),
                    title: 'Receitas',
                    radius: 60,
                  ),
                  PieChartSectionData(
                    value: 30,
                    color: const Color(0xFF8C1C03),
                    title: 'Despesas',
                    radius: 60,
                  ),
                ],
                startDegreeOffset: 270,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendCircle({required Color color, required String text}) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xFF21272A),
          ),
        ),
      ],
    );
  }
}
