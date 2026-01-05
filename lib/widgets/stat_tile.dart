import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatTile extends StatelessWidget {
  final String label;
  final String value;
  final double screenWidth;

  const StatTile({
    super.key,
    required this.label,
    required this.value,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: screenWidth * 0.05, // Slightly reduced font size
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: screenWidth * 0.035,
              fontWeight: FontWeight.w500,
              color: Colors.black54, // Softer color
            ),
          ),
        ],
      ),
    );
  }
}
