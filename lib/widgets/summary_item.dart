import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

class SummaryItem extends StatelessWidget {
  final String value;
  final String label;
  final double screenWidth;

  const SummaryItem({
    super.key,
    required this.value,
    required this.label,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      padding: EdgeInsets.all(screenWidth * 0.03),
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: screenWidth * 0.039,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: screenWidth * 0.03,
              color: Color(0xff656567),
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 8),
          // Icon(Icons.arrow_forward, size: screenWidth * 0.05),
        ],
      ),
    );
  }
}
