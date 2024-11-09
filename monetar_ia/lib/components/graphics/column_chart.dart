import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ColumnChart extends StatelessWidget {
  final Map<String, double> data;

  final String title;
  final double currentYearRevenue;
  final double currentYearExpense;
  final double previousYearRevenue;
  final double previousYearExpense;

  const ColumnChart({
    super.key,
    required this.title,
    required this.currentYearRevenue,
    required this.currentYearExpense,
    required this.previousYearRevenue,
    required this.previousYearExpense,
    required this.data,
  });

  double _calculateInterval() {
    double maxValue = [
      currentYearRevenue,
      currentYearExpense,
      previousYearRevenue,
      previousYearExpense
    ].reduce((a, b) => a > b ? a : b);

    double interval = maxValue / 10;

    if (interval < 1) return 1;
    return interval.ceilToDouble();
  }

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
          const SizedBox(height: 16),
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
            child: BarChart(
              BarChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        int currentYear = DateTime.now().year;
                        final titles = [
                          (currentYear - 1).toString(),
                          currentYear.toString(),
                        ];

                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            titles[value.toInt()],
                            style: const TextStyle(
                              color: Color(0xFF697077),
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: _calculateInterval(),
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            color: Color(0xFF697077),
                            fontWeight: FontWeight.w400,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: const Color(0xFF3D5936),
                    width: 1,
                  ),
                ),
                barGroups: _buildBarGroups(),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: const Color(0xFFEBEBEB),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    return [
      // Ano Anterior
      BarChartGroupData(
        x: 0,
        barRods: [
          BarChartRodData(
            toY: previousYearRevenue,
            color: const Color(0xFF3D5936),
            width: 20,
            borderRadius: BorderRadius.zero,
          ),
          BarChartRodData(
            toY: previousYearExpense,
            color: const Color(0xFF8C1C03),
            width: 20,
            borderRadius: BorderRadius.zero,
          ),
        ],
        barsSpace: 12,
      ),
      // Ano Atual
      BarChartGroupData(
        x: 1,
        barRods: [
          BarChartRodData(
            toY: currentYearRevenue,
            color: const Color(0xFF3D5936),
            width: 20,
            borderRadius: BorderRadius.zero,
          ),
          BarChartRodData(
            toY: currentYearExpense,
            color: const Color(0xFF8C1C03),
            width: 20,
            borderRadius: BorderRadius.zero,
          ),
        ],
        barsSpace: 12,
      ),
    ];
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
