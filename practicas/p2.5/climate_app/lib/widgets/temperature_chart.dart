import 'package:flutter/material.dart';
import '../models/forecast.dart';

class TemperatureChart extends StatelessWidget {
  final List<ForecastItem> items;
  final String Function(num) formatTemp;
  final bool isFahrenheit;

  const TemperatureChart({
    super.key,
    required this.items,
    required this.formatTemp,
    required this.isFahrenheit,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: CustomPaint(
        size: Size.infinite,
        painter: _ChartPainter(
          items: items,
          formatTemp: formatTemp,
          isFahrenheit: isFahrenheit,
        ),
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  final List<ForecastItem> items;
  final String Function(num) formatTemp;
  final bool isFahrenheit;

  _ChartPainter({
    required this.items,
    required this.formatTemp,
    required this.isFahrenheit,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (items.isEmpty) return;

    final w = size.width;
    final h = size.height;
    final padLeft = 44.0;
    final padRight = 16.0;
    final padTop = 24.0;
    final padBottom = 28.0;
    final chartW = w - padLeft - padRight;
    final chartH = h - padTop - padBottom;

    final temps = items.map((e) => e.temperature).toList();
    final minT = temps.reduce((a, b) => a < b ? a : b);
    final maxT = temps.reduce((a, b) => a > b ? a : b);
    final range = (maxT - minT).clamp(1, 100).toDouble();
    final tempRange = range + 2;
    final minDisplay = minT - 1;

    double xOf(int i) =>
        padLeft + (chartW * i / (items.length - 1));
    double yOf(int temp) =>
        padTop + chartH - (chartH * (temp - minDisplay) / tempRange);

    // Grid horizontal (3 lineas)
    final gridPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 0.5;
    final gridLabels = <int>[];
    for (var i = 0; i <= 2; i++) {
      final t = (minDisplay + (tempRange * i / 2)).round();
      gridLabels.add(t);
      final y = yOf(t);
      canvas.drawLine(Offset(padLeft, y), Offset(w - padRight, y), gridPaint);
    }

    // Etiquetas eje Y
    final labelStyle = TextStyle(fontSize: 10, color: Colors.grey.shade600);
    for (final t in gridLabels) {
      final tp = TextPainter(
        text: TextSpan(text: formatTemp(t), style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(4, yOf(t) - tp.height / 2));
    }

    // Etiquetas eje X (horas)
    final hourStyle = TextStyle(fontSize: 9, color: Colors.grey.shade600);
    for (var i = 0; i < items.length; i++) {
      final tp = TextPainter(
        text: TextSpan(text: items[i].hourLabel, style: hourStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      final x = xOf(i) - tp.width / 2;
      tp.paint(canvas, Offset(x, h - padBottom + 6));
    }

    // Linea de temperatura
    final linePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final path = Path();
    for (var i = 0; i < items.length; i++) {
      final x = xOf(i);
      final y = yOf(items[i].temperature);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, linePaint);

    // Area bajo la curva
    final areaPath = Path()
      ..moveTo(xOf(0), padTop + chartH)
      ..addPath(path, Offset.zero)
      ..lineTo(xOf(items.length - 1), padTop + chartH)
      ..close();
    final areaPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.blue.withValues(alpha: 0.25), Colors.blue.withValues(alpha: 0.02)],
      ).createShader(Rect.fromLTWH(padLeft, padTop, chartW, chartH));
    canvas.drawPath(areaPath, areaPaint);

    // Puntos y etiquetas de temperatura
    final dotPaint = Paint()..color = Colors.blue;
    final tempStyle = TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.bold,
      color: Colors.blue.shade700,
    );
    for (var i = 0; i < items.length; i++) {
      final x = xOf(i);
      final y = yOf(items[i].temperature);
      canvas.drawCircle(Offset(x, y), 3, dotPaint);

      final tp = TextPainter(
        text: TextSpan(
          text: formatTemp(items[i].temperature),
          style: tempStyle,
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, y - tp.height - 6));
    }
  }

  @override
  bool shouldRepaint(covariant _ChartPainter old) =>
      old.isFahrenheit != isFahrenheit || old.items.length != items.length;
}
