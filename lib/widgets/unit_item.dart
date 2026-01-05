import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/project_detail_screen.dart'; // Added import
import '../utils/project_style.dart';
// import '../models/unit_model.dart';

class UnitItem extends StatelessWidget {
  final String projectName;
  final dynamic unit;

  const UnitItem({super.key, required this.unit, required this.projectName});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 0.0,
        vertical: 8.0,
      ), // Full width look
      child: Container(
        padding: EdgeInsets.all(screenWidth * 0.05),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              spreadRadius: 0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Project Name Chip
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          projectName.toUpperCase(),
                          style: GoogleFonts.outfit(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Text(
                            'Unit ',
                            style: GoogleFonts.outfit(
                              fontSize: screenWidth * 0.04,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            (unit.data() as Map<String, dynamic>).containsKey(
                                  'oldUnitDetailsObj',
                                )
                                ? unit['oldUnitDetailsObj']['unit_no'] ?? 'N/A'
                                : unit['unit_no'] ?? 'N/A',
                            style: GoogleFonts.outfit(
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Status Chip
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Color(0XFFDFF6E0).withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    (unit.data() as Map<String, dynamic>).containsKey('status')
                        ? unit['status']
                        : 'Active',
                    style: GoogleFonts.outfit(
                      color: Color(0xff1B6600),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Divider(color: Colors.black12),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Due',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '₹${ProjectStyle.formatCurrency((unit.data() as Map<String, dynamic>)['T_elgible_balance'] ?? 0)}',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w700,
                        fontSize: screenWidth * 0.05,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap:
                      () => Get.to(
                        () => ProjectDetailScreen(),
                        transition: Transition.rightToLeft,
                        duration: Duration(milliseconds: 500),
                        arguments: {'projectName': projectName, 'unit': unit},
                      ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black12),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'View Details',
                          style: GoogleFonts.outfit(
                            color: Colors.black87,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward_outlined,
                          size: 16,
                          color: Colors.black87,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
