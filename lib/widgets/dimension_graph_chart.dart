import 'package:flutter/material.dart';

class DimensionGraph extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const DimensionGraph({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    double rectWidth = screenWidth * 0.6; // Reduced width
    double rectHeight = screenHeight * 0.1; // Reduced height
    double arrowLength = rectWidth * 1.2; // Extended arrows
    double verticalArrowLength = rectHeight * 2.5; // Taller vertical arrows
    double textSize = screenWidth * 0.03; // Responsive text size

    return Stack(
      alignment: Alignment.center,
      children: [
        // Dashed rectangle with extended corners
        CustomPaint(
          size: Size(rectWidth, rectHeight),
          painter: DashedBorderPainter(),
        ),

        // Top Horizontal Arrow
        Positioned(
          top: -40, // Moves the arrow outside the rectangle
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "<",
                style: TextStyle(
                  fontFamily: 'Host Grotesk',
                  fontSize: textSize * 1.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(width: arrowLength, height: 2, color: Colors.black),
              Text(
                ">",
                style: TextStyle(
                  fontFamily: 'Host Grotesk',
                  fontSize: textSize * 1.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: -55,
          child: Text(
            "120 cm",
            style: TextStyle(
              fontFamily: 'Host Grotesk',
              fontSize: textSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Bottom Horizontal Arrow
        Positioned(
          bottom: -40,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "<",
                style: TextStyle(
                  fontFamily: 'Host Grotesk',
                  fontSize: textSize * 1.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(width: arrowLength, height: 2, color: Colors.black),
              Text(
                ">",
                style: TextStyle(
                  fontFamily: 'Host Grotesk',
                  fontSize: textSize * 1.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: -55,
          child: Text(
            "120 cm",
            style: TextStyle(
              fontFamily: 'Host Grotesk',
              fontSize: textSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Left Vertical Arrow
        Positioned(
          left: -40,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "^",
                style: TextStyle(
                  fontFamily: 'Host Grotesk',
                  fontSize: textSize * 1.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                height: verticalArrowLength,
                width: 2,
                color: Colors.black,
              ),
              Text(
                "v",
                style: TextStyle(
                  fontFamily: 'Host Grotesk',
                  fontSize: textSize * 1.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: -55,
          child: Text(
            "80 cm",
            style: TextStyle(
              fontFamily: 'Host Grotesk',
              fontSize: textSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Right Vertical Arrow
        Positioned(
          right: -40,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "^",
                style: TextStyle(
                  fontFamily: 'Host Grotesk',
                  fontSize: textSize * 1.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                height: verticalArrowLength,
                width: 2,
                color: Colors.black,
              ),
              Text(
                "v",
                style: TextStyle(
                  fontFamily: 'Host Grotesk',
                  fontSize: textSize * 1.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: -55,
          child: Text(
            "80 cm",
            style: TextStyle(
              fontFamily: 'Host Grotesk',
              fontSize: textSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // "D=Dimension" Label (Bottom Right)
        Positioned(
          bottom: -rectHeight * 0.5,
          right: -rectWidth * 0.2,
          child: Text(
            "D = Dimension",
            style: TextStyle(
              fontFamily: 'Host Grotesk',
              fontSize: textSize,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }
}

// Custom Painter for Dashed Rectangle with Extended Corners
class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint =
        Paint()
          ..color = Colors.black
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    double dashWidth = 10, dashSpace = 5;
    Path path = Path();

    // Top Border (Dashed)
    double startX = 0;
    while (startX < size.width) {
      path.moveTo(startX, 0);
      path.lineTo(startX + dashWidth, 0);
      startX += dashWidth + dashSpace;
    }

    // Right Border (Dashed)
    double startY = 0;
    while (startY < size.height) {
      path.moveTo(size.width, startY);
      path.lineTo(size.width, startY + dashWidth);
      startY += dashWidth + dashSpace;
    }

    // Bottom Border (Dashed)
    startX = 0;
    while (startX < size.width) {
      path.moveTo(startX, size.height);
      path.lineTo(startX + dashWidth, size.height);
      startX += dashWidth + dashSpace;
    }

    // Left Border (Dashed)
    startY = 0;
    while (startY < size.height) {
      path.moveTo(0, startY);
      path.lineTo(0, startY + dashWidth);
      startY += dashWidth + dashSpace;
    }

    canvas.drawPath(path, paint);

    // Drawing Extended Corners
    Paint cornerPaint =
        Paint()
          ..color = Colors.black
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    double cornerLength = 10;

    // Top Left Corner
    canvas.drawLine(Offset(0, -cornerLength), Offset(0, 0), cornerPaint);
    canvas.drawLine(Offset(-cornerLength, 0), Offset(0, 0), cornerPaint);

    // Top Right Corner
    canvas.drawLine(
      Offset(size.width, -cornerLength),
      Offset(size.width, 0),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(size.width + cornerLength, 0),
      Offset(size.width, 0),
      cornerPaint,
    );

    // Bottom Left Corner
    canvas.drawLine(
      Offset(0, size.height + cornerLength),
      Offset(0, size.height),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(-cornerLength, size.height),
      Offset(0, size.height),
      cornerPaint,
    );

    // Bottom Right Corner
    canvas.drawLine(
      Offset(size.width, size.height + cornerLength),
      Offset(size.width, size.height),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(size.width + cornerLength, size.height),
      Offset(size.width, size.height),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
