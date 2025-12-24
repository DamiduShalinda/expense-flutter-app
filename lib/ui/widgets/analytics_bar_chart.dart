import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AnalyticsBarChart extends StatelessWidget {
  const AnalyticsBarChart({
    super.key,
    required this.values,
    this.labels,
    this.height = 140,
    this.barWidth = 14,
    this.cornerRadius = 4,
    this.positiveColor,
    this.negativeColor,
    this.zeroColor,
  });

  final List<double> values;
  final List<String>? labels;
  final double height;
  final double barWidth;
  final double cornerRadius;
  final Color? positiveColor;
  final Color? negativeColor;
  final Color? zeroColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final posColor = positiveColor ?? theme.colorScheme.primary;
    final negColor = negativeColor ?? theme.colorScheme.error;
    final zero = zeroColor ?? theme.colorScheme.onSurfaceVariant;

    if (values.isEmpty) {
      return SizedBox(height: height, child: const SizedBox());
    }

    var minY = values.reduce((a, b) => a < b ? a : b);
    var maxY = values.reduce((a, b) => a > b ? a : b);
    minY = minY > 0 ? 0 : minY;
    maxY = maxY < 0 ? 0 : maxY;
    if (minY == maxY) {
      minY -= 1;
      maxY += 1;
    }

    return SizedBox(
      height: height,
      child: BarChart(
        BarChartData(
          minY: minY,
          maxY: maxY,
          baselineY: 0,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: labels != null,
                reservedSize: labels == null ? 0 : 20,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (labels == null ||
                      index < 0 ||
                      index >= labels!.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      labels![index],
                      style: theme.textTheme.labelSmall,
                    ),
                  );
                },
              ),
            ),
          ),
          barGroups: [
            for (var i = 0; i < values.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: values[i],
                    width: barWidth,
                    borderRadius: BorderRadius.circular(cornerRadius),
                    color:
                        values[i] > 0
                            ? posColor
                            : values[i] < 0
                            ? negColor
                            : zero,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
