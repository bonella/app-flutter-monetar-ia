import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LineGraphic extends StatelessWidget {
  final String title;

  const LineGraphic({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 361,
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
          // Título
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
          // Círculos de legenda
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
          // Gráfico de linha
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  drawVerticalLine: false,
                  horizontalInterval: 100,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: const Color(0xFF3D5936).withOpacity(0.1),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(
                          color: Color(0xFF697077),
                          fontWeight: FontWeight.w400,
                          fontSize: 10,
                        );
                        switch (value.toInt()) {
                          case 0:
                            return const Text('18/08', style: style);
                          case 1:
                            return const Text('19/08', style: style);
                          case 2:
                            return const Text('19/08', style: style);
                          case 3:
                            return const Text('20/08', style: style);
                          case 4:
                            return const Text('Mai', style: style);
                          case 5:
                            return const Text('21/08', style: style);
                          case 6:
                            return const Text('21/08', style: style);
                          case 7:
                            return const Text('21/08', style: style);
                          case 8:
                            return const Text('21/08', style: style);
                          case 9:
                            return const Text('21/08', style: style);
                          case 10:
                            return const Text('21/08', style: style);
                          case 11:
                            return const Text('21/08', style: style);
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 100,
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
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: const Color(0xFF3D5936),
                    width: 1,
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 200),
                      const FlSpot(1, 500),
                      const FlSpot(2, 800),
                      const FlSpot(3, 300),
                      const FlSpot(4, 700),
                      const FlSpot(5, 1000),
                      const FlSpot(6, 600),
                      const FlSpot(7, 900),
                      const FlSpot(8, 400),
                      const FlSpot(9, 800),
                      const FlSpot(10, 200),
                    ],
                    isCurved: true,
                    color: const Color(0xFF3D5936),
                    barWidth: 2,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 300),
                      const FlSpot(1, 400),
                      const FlSpot(2, 500),
                      const FlSpot(3, 600),
                      const FlSpot(4, 700),
                      const FlSpot(5, 800),
                      const FlSpot(6, 400),
                      const FlSpot(7, 200),
                      const FlSpot(8, 600),
                      const FlSpot(9, 900),
                      const FlSpot(10, 700),
                    ],
                    isCurved: true,
                    color: const Color(0xFF8C1C03),
                    barWidth: 2,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
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
