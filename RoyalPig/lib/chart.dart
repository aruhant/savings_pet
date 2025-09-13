import 'package:fl_chart/fl_chart.dart';
import 'app_resources.dart';
import 'package:flutter/material.dart';

class LineChartTotals extends StatelessWidget {
  LineChartTotals({
    super.key,
    Color? line1Color,
    Color? line2Color,
    Color? lineColor,
    Color? betweenColor,
  }) : line1Color = line1Color ?? AppColors.contentColorGreen.withAlpha(80),
       line2Color = line2Color ?? AppColors.contentColorRed.withAlpha(80),
       lineColor = lineColor ?? AppColors.contentColorBlack.withAlpha(80),
       betweenColor = betweenColor ?? Colors.blueGrey.withAlpha(30);

  final Color line1Color;
  final Color line2Color;
  final Color lineColor;
  final Color betweenColor;

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10, fontWeight: FontWeight.bold);
    String text;
    switch ((value.toInt()) % 12) {
      case 1:
        text = 'Jan';
        break;
      case 2:
        text = 'Feb';
        break;
      case 3:
        text = 'Mar';
        break;
      case 4:
        text = 'Apr';
        break;
      case 5:
        text = 'May';
        break;
      case 6:
        text = 'Jun';
        break;
      case 7:
        text = 'Jul';
        break;
      case 8:
        text = 'Aug';
        break;
      case 9:
        text = 'Sep';
        break;
      case 10:
        text = 'Oct';
        break;
      case 11:
        text = 'Nov';
        break;
      case 0:
        text = 'Dec';
        break;
      default:
        return Container();
    }

    return SideTitleWidget(
      meta: meta,
      space: 4,
      child: Text(text, style: style),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);

    return SideTitleWidget(
      meta: meta,
      child: Text('\$ ${value + 0.5}', style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 18, top: 10, bottom: 4),
        child: LineChart(
          LineChartData(
            lineTouchData: const LineTouchData(enabled: false),
            lineBarsData: [
              LineChartBarData(
                spots: const [
                  FlSpot(9, 6),
                  FlSpot(10, 6),
                  FlSpot(11, 7),
                  FlSpot(12, 4),
                  FlSpot(13, 3.5),
                  FlSpot(14, 4.5),
                  FlSpot(15, 3),
                  FlSpot(16, 4),
                  FlSpot(17, 6),
                  FlSpot(18, 6.5),
                  FlSpot(19, 6),
                  FlSpot(20, 4),
                ],
                isCurved: true,
                barWidth: 8,
                color: line1Color,
                dotData: const FlDotData(show: true),
              ),
              LineChartBarData(
                spots: const [
                  FlSpot(9, 2),
                  FlSpot(10, 5),
                  FlSpot(11, 4),
                  FlSpot(12, 2),
                  FlSpot(13, 2),
                  FlSpot(14, 3),
                  FlSpot(15, 2),
                  FlSpot(16, 3),
                  FlSpot(17, 4),
                  FlSpot(18, 5),
                  FlSpot(19, 3),
                  FlSpot(20, 1),
                ],
                isCurved: true,
                barWidth: 8,
                color: line2Color,
                dotData: const FlDotData(show: true),
              ),
              LineChartBarData(
                spots: const [
                  FlSpot(9, 3),
                  FlSpot(10, 5.3),
                  FlSpot(11, 4.5),
                  FlSpot(12, 2.2),
                  FlSpot(13, 2.5),
                  FlSpot(14, 3.3),
                  FlSpot(15, 2.1),
                  FlSpot(16, 3.8),
                  FlSpot(17, 5),
                  FlSpot(18, 5.4),
                  FlSpot(19, 3.56),
                  FlSpot(20, 2),
                ],
                isCurved: true,
                barWidth: 12,
                color: lineColor,
                dotData: const FlDotData(show: true),
              ),
            ],
            betweenBarsData: [
              BetweenBarsData(fromIndex: 0, toIndex: 1, color: betweenColor),
            ],
            minY: 0,
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: bottomTitleWidgets,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: leftTitleWidgets,
                  interval: 1,
                  reservedSize: 36,
                ),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 1,
              checkToShowHorizontalLine: (double value) {
                return value == 1 || value == 6 || value == 4 || value == 5;
              },
            ),
          ),
        ),
      ),
    );
  }
}
