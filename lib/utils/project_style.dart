import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProjectStyle {
  // Colors - matching SamplePropertyStyle
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color appbarbackgroundColor = Colors.white;
  static const Color surfaceColor = Colors.white;
  static const Color primaryTextColor = Colors.black;
  static const Color secondaryTextColor = Color(0xFF333333);
  static const Color tertiaryTextColor = Color.fromARGB(255, 15, 15, 15);
  static const Color accentColor = Color(0xFF8B6B43);
  static const Color iconColor = Colors.black;

  // Spacing - matching SamplePropertyStyle
  static const double pagePadding = 20.0;
  static const double sectionSpacing = 10.0;
  static const double internalPadding = 12.0;
  static const double gapSmall = 8.0;
  static const double gapMedium = 12.0;
  static const double gapLarge = 24.0;

  // Typography - matching SamplePropertyStyle
  static const String fontFamily = 'Host Grotesk';

  static const TextStyle headlineText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: primaryTextColor,
  );

  static const TextStyle titleText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: primaryTextColor,
  );

  static const TextStyle subTitleText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: primaryTextColor,
  );

  static const TextStyle bodyText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    color: primaryTextColor,
  );

  static const TextStyle smallText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    color: primaryTextColor,
  );

  static const TextStyle captionText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    color: Colors.grey,
  );

  static const TextStyle sectionHeaderText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 11, 11, 11),
    letterSpacing: 1.2,
  );

  static String formatCurrency(dynamic value) {
    if (value == null) return "0";

    double number;
    if (value is num) {
      number = value.toDouble();
    } else if (value is String) {
      number = double.tryParse(value.replaceAll(',', '')) ?? 0.0;
    } else {
      number = 0.0;
    }

    return NumberFormat.currency(
      locale: 'en_IN',
      symbol: '',
      decimalDigits: 0,
    ).format(number);
  }
}

class DottedUnderlineText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Color underlineColor;

  const DottedUnderlineText({
    super.key,
    required this.text,
    required this.style,
    this.underlineColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DottedLinePainter(color: underlineColor),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 2.0),
        child: Text(
          text,
          style: style.copyWith(decoration: TextDecoration.none),
        ),
      ),
    );
  }
}

class DottedSeparator extends StatelessWidget {
  final Color color;
  final double height;

  const DottedSeparator({
    super.key,
    this.color = Colors.grey,
    this.height = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(painter: DottedLinePainter(color: color)),
    );
  }
}

class DottedLinePainter extends CustomPainter {
  final Color color;

  DottedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = 1
          ..strokeCap = StrokeCap.round;

    double startX = 0;
    final double y = size.height;
    const double dashWidth = 0.8;
    const double gap = 1;

    while (startX < size.width) {
      canvas.drawCircle(Offset(startX, y), 0.5, paint);
      startX += gap + dashWidth;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
