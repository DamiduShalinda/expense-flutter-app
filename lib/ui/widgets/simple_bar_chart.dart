import 'dart:math' as math;

import 'package:flutter/material.dart';

class SimpleBarChart extends StatelessWidget {
  const SimpleBarChart({
    super.key,
    required this.values,
    this.positiveColor,
    this.negativeColor,
    this.axisColor,
    this.barRadius = 3,
    this.height = 96,
    this.showZeroLine = true,
  });

  final List<double> values;
  final Color? positiveColor;
  final Color? negativeColor;
  final Color? axisColor;
  final double barRadius;
  final double height;
  final bool showZeroLine;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _SimpleBarChartPainter(
          values: values,
          positiveColor: positiveColor ?? scheme.primary,
          negativeColor: negativeColor ?? scheme.error,
          axisColor: axisColor ?? scheme.outlineVariant,
          barRadius: barRadius,
          showZeroLine: showZeroLine,
        ),
      ),
    );
  }
}

class _SimpleBarChartPainter extends CustomPainter {
  _SimpleBarChartPainter({
    required this.values,
    required this.positiveColor,
    required this.negativeColor,
    required this.axisColor,
    required this.barRadius,
    required this.showZeroLine,
  });

  final List<double> values;
  final Color positiveColor;
  final Color negativeColor;
  final Color axisColor;
  final double barRadius;
  final bool showZeroLine;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    final maxAbs = values
        .map((v) => v.abs())
        .fold<double>(0, (m, v) => math.max(m, v));
    if (maxAbs <= 0) return;

    final paint = Paint()..style = PaintingStyle.fill;
    final axisPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = axisColor;

    final padding = 4.0;
    final chartRect = Rect.fromLTWH(
      0,
      padding,
      size.width,
      math.max(0, size.height - padding * 2),
    );

    final zeroY = chartRect.top + chartRect.height / 2;

    if (showZeroLine) {
      canvas.drawLine(
        Offset(chartRect.left, zeroY),
        Offset(chartRect.right, zeroY),
        axisPaint,
      );
    }

    final n = values.length;
    final gap = 3.0;
    final barWidth = (chartRect.width - gap * (n - 1)) / n;

    for (var i = 0; i < n; i++) {
      final v = values[i];
      final normalized = v / maxAbs;
      final barHeight = (chartRect.height / 2) * normalized.abs();

      final x = chartRect.left + i * (barWidth + gap);
      final top = v >= 0 ? zeroY - barHeight : zeroY;
      final rect = Rect.fromLTWH(x, top, barWidth, barHeight);

      paint.color = v >= 0 ? positiveColor : negativeColor;
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(barRadius)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SimpleBarChartPainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.positiveColor != positiveColor ||
        oldDelegate.negativeColor != negativeColor ||
        oldDelegate.axisColor != axisColor ||
        oldDelegate.barRadius != barRadius ||
        oldDelegate.showZeroLine != showZeroLine;
  }
}
