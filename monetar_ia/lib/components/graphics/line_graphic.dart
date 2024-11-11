import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:monetar_ia/models/transaction.dart';
import 'package:intl/intl.dart';

class LineGraphic extends StatelessWidget {
  final String title;
  final List<Transaction> transactions;

  const LineGraphic({
    super.key,
    required this.title,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    List<Transaction> sortedTransactions = List.from(transactions)
      ..sort((a, b) => a.transactionDate.compareTo(b.transactionDate));

    List<Transaction> lastTransactions = sortedTransactions.take(10).toList();

    List<FlSpot> revenueSpots = [];
    List<FlSpot> expenseSpots = [];

    double maxAmount = 0;

    for (int i = 0; i < lastTransactions.length; i++) {
      var transaction = lastTransactions[i];
      double amount = transaction.amount;

      if (transaction.type == 'INCOME') {
        revenueSpots.add(FlSpot(i.toDouble(), amount));
      } else if (transaction.type == 'EXPENSE') {
        expenseSpots.add(FlSpot(i.toDouble(), amount));
      }

      maxAmount = amount > maxAmount ? amount : maxAmount;
    }

    maxAmount = maxAmount == 0 ? 100 : maxAmount;

    bool hasRevenue = revenueSpots.isNotEmpty;
    bool hasExpense = expenseSpots.isNotEmpty;

    const int yLabelsCount = 8;

    double yInterval = maxAmount / (yLabelsCount - 1);
    yInterval = yInterval < 10 ? 10 : yInterval;

    yInterval = yInterval < 1 ? 1 : yInterval;

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
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  drawVerticalLine: false,
                  horizontalInterval: yInterval,
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
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(
                          color: Color(0xFF697077),
                          fontWeight: FontWeight.w400,
                          fontSize: 10,
                        );
                        if (value.toInt() < lastTransactions.length) {
                          var date =
                              lastTransactions[value.toInt()].transactionDate;
                          String formattedDate = DateFormat('dd').format(date);
                          return Text(formattedDate, style: style);
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      interval: yInterval,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            value >= 1000
                                ? '${(value / 1000).toStringAsFixed(1)}k'
                                : value.toStringAsFixed(0),
                            style: const TextStyle(
                              color: Color(0xFF697077),
                              fontWeight: FontWeight.w400,
                              fontSize: 10,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: const Border(
                    top: BorderSide(color: Color(0xFF3D5936), width: 2),
                    left: BorderSide(color: Color(0xFF3D5936), width: 2),
                    right: BorderSide(color: Color(0xFF3D5936), width: 2),
                    bottom: BorderSide(color: Color(0xFF3D5936), width: 2),
                  ),
                ),
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: const Color(0xFFEBEBEB),
                    tooltipRoundedRadius: 8,
                    tooltipPadding: const EdgeInsets.all(8),
                  ),
                ),
                lineBarsData: [
                  if (hasRevenue)
                    LineChartBarData(
                      spots: revenueSpots,
                      isCurved: true,
                      color: const Color(0xFF3D5936),
                      barWidth: 5,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                  if (hasExpense)
                    LineChartBarData(
                      spots: expenseSpots,
                      isCurved: true,
                      color: const Color(0xFF8C1C03),
                      barWidth: 5,
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
