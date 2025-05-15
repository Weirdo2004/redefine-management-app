import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/unit_model.dart';

class NeedsAttentionItem extends StatelessWidget {
  final UnitModel unit;
  final int index;

  const NeedsAttentionItem({
    super.key,
    required this.unit,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.19,
      width: screenWidth,
      child: Padding(
        padding: const EdgeInsets.only(left: 6.0, right: 6.0),
        child: Card(
          color: Colors.white, // Set background color to white
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ), // Sharp edges
          margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // First row: Unit number and digit in one row
                Row(
                  children: [
                    Container(
                      width: screenWidth * 0.06,
                      height: screenWidth * 0.06,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black, // Background black
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black),
                      ),
                      child: Text(
                        '${index + 1}'.padLeft(2, '0'),
                        style: GoogleFonts.outfit(
                          fontSize: screenWidth * 0.03,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Text white
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    Text(
                      'UNIT NO: ${unit.unit_no}',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w500,
                        fontSize: screenWidth * 0.03,
                        color: Color(0xff191B1C),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.01),

                // Second row: Description
                Text(
                  'Clear your Outstanding amount for Legal charges of',
                  style: GoogleFonts.outfit(
                    fontSize: screenWidth * 0.035,
                    color: Color(0xff656567),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: screenHeight * 0.008),

                // Third row: Price on left, Due date & Pay Now button on right
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          '₹${unit.amount}',
                          style: GoogleFonts.outfit(
                            color: Color(0xff191B1C),
                            fontWeight: FontWeight.w600,
                            fontSize: screenWidth * 0.045,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Text(
                          'Due in ${unit.daysLeft} days',
                          style: GoogleFonts.outfit(
                            color: Color(0xff960000),
                            fontSize: screenWidth * 0.025,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: screenHeight * 0.045,
                      width: screenHeight * 0.14,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(
                              0xFFEDE9FE,
                            ), // Lavender background
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ), // Sharp corners
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04,
                            ),
                          ),
                          onPressed: ()
                          {

                          },
                        //  => Get.toNamed('/payment-schedule'),
                          child: Text(
                            'Pay Now',
                            style: GoogleFonts.outfit(
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff191B1C), // Text black
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
