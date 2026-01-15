import 'dart:math' as math;
import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
import '../utils/project_style.dart';

class DonutChart extends StatelessWidget {
  final double paid;
  final double total;
  final double size;
  final Color paidColor;
  final Color eligibleColor;

  const DonutChart({
    super.key,
    required this.paid,
    required this.total,
    required this.size,
    required this.paidColor,
    required this.eligibleColor,
  });

  @override
  Widget build(BuildContext context) {
    int remainingBalance =
        (total - paid).round(); // Convert to int (remove decimals)

    return SizedBox(
      width: size * 1.1, // Increase the total size of the donut
      height: size * 1.2, // Increase the total size of the donut
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _DonutChartPainter(
              paid: paid,
              total: total,
              paidColor: paidColor,
              eligibleColor: eligibleColor,
            ),
          ),

          // Centered Balance Text
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Balance",
                style: TextStyle(
                  fontSize: size * 0.1,
                  fontFamily: 'Host Grotesk',
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: size * 0.02),
              Text(
                ProjectStyle.formatCurrency(remainingBalance),
                style: TextStyle(
                  fontSize: size * 0.12, // Increased balance font size
                  fontFamily: 'Host Grotesk',
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  final double paid;
  final double total;
  final Color paidColor;
  final Color eligibleColor;

  _DonutChartPainter({
    required this.paid,
    required this.total,
    required this.paidColor,
    required this.eligibleColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double strokeWidth = size.width * 0.25;
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = (size.width - strokeWidth) * 1.15;

    final Paint paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.butt;

    final double paidPercentage = (paid / total).clamp(
      0.0,
      1.0,
    ); // Ensures it's between 0 and 1
    final double paidAngle = paidPercentage * 2 * math.pi;

    // Base grey circle (background)
    paint.color = Colors.grey[300]!;
    canvas.drawCircle(center, radius, paint);

    // Full eligible arc (Lavender) — the total eligible amount
    paint.color = eligibleColor; // typically Colors.purple[200]
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi,
      false,
      paint,
    );

    // Paid arc (Overlay)
    if (paid > 0) {
      paint.color = paidColor;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        paidAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
