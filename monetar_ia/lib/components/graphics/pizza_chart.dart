import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PizzaChart extends StatelessWidget {
  final double currentMonthRevenue;
  final double currentMonthExpense;
  final String title;

  const PizzaChart({
    super.key,
    required this.title,
    required this.currentMonthRevenue,
    required this.currentMonthExpense,
  });

  @override
  Widget build(BuildContext context) {
    double total = currentMonthRevenue + currentMonthExpense;
    double revenuePercentage =
        total > 0 ? (currentMonthRevenue / total) * 100 : 0.0;
    double expensePercentage =
        total > 0 ? (currentMonthExpense / total) * 100 : 0.0;

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
                    value: revenuePercentage,
                    color: const Color(0xFF3D5936),
                    title: '${revenuePercentage.toStringAsFixed(1)}%',
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    value: expensePercentage,
                    color: const Color(0xFF8C1C03),
                    title: '${expensePercentage.toStringAsFixed(1)}%',
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Colors.white,
                    ),
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
