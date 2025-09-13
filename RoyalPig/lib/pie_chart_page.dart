import 'dart:math';

import 'package:flutter/material.dart';
import 'package:goals/main.dart';
import 'stats.dart';
import 'dynamo_stream_listener.dart';
import 'chart.dart';

/// -----------------------
/// Analytics Page
/// - shows a pie chart of spendings by category and a legend
/// -----------------------
class PiChartPage extends StatefulWidget {
  @override
  State<PiChartPage> createState() => _PiChartPageState();
}

class _PiChartPageState extends State<PiChartPage> {
  late Map<String, double> _byCategory;

  @override
  void initState() {
    super.initState();
    _recalc();
  }

  void _recalc() {
    final byCat = <String, double>{};
    for (var m in DemoData.recentMessages()) {
      final cat = m.category ?? 'Other';
      byCat[cat] = (byCat[cat] ?? 0) + (m.amount ?? 0.0);
    }
    setState(() => _byCategory = byCat);
  }

  @override
  Widget build(BuildContext context) {
    final entries = _byCategory.entries.toList();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Analytics'.toUpperCase(),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Simple pie chart
                    SizedBox(
                      height: 220,
                      width: 220,
                      child: PieChart(
                        data: _byCategory.map((k, v) => MapEntry(k, v.abs())),
                      ),
                    ),
                    const SizedBox(height: 18),
                    // legend
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: List.generate(entries.length, (i) {
                        final e = entries[i];
                        return LegendItem(
                          color: pieColors[i % pieColors.length],
                          label: '${e.key} — \$${e.value.toStringAsFixed(2)}',
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// -----------------------
/// Simple pie chart painter (no external dependency)
/// -----------------------
final List<Color> pieColors = [
  Colors.blue,
  Colors.green,
  Colors.orange,
  Colors.purple,
  Colors.teal,
  Colors.red,
];

class PieChart extends StatelessWidget {
  final Map<String, double> data;
  const PieChart({super.key, required this.data});
  @override
  Widget build(BuildContext context) {
    final total = data.values.fold(0.0, (a, b) => a + b);
    return CustomPaint(
      painter: _PiePainter(data, pieColors),
      child: Center(
        child: total == 0 ? const Text('No data') : const SizedBox.shrink(),
      ),
    );
  }
}

class _PiePainter extends CustomPainter {
  final Map<String, double> data;
  final List<Color> colors;
  _PiePainter(this.data, this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()..style = PaintingStyle.fill;
    final radius = min(size.width, size.height) / 2;
    final center = Offset(size.width / 2, size.height / 2);

    final total = data.values.fold(0.0, (a, b) => a + b);
    if (total == 0) {
      // draw empty circle
      paint.color = Colors.grey.shade200;
      canvas.drawCircle(center, radius, paint);
      return;
    }
    double startRads = -pi / 2;
    int i = 0;
    for (final entry in data.entries) {
      final sweep = (entry.value / total) * 2 * pi;
      paint.color = colors[i % colors.length];
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startRads,
        sweep,
        true,
        paint,
      );
      startRads += sweep;
      i++;
    }
    // draw inner white for donut look
    paint.color = Colors.white;
    canvas.drawCircle(center, radius * 0.55, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const LegendItem({super.key, required this.color, required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }
}
