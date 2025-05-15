

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
// import '../models/unit_model.dart';

class UnitItem extends StatelessWidget {
  final String projectName;
  final  unit;

  const UnitItem({super.key,required this.unit, required this.projectName});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        padding: EdgeInsets.all(screenWidth * 0.04),
        margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
        height: screenHeight * 0.2,
        decoration: BoxDecoration(
          color: Colors.white,
          // borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 6.0,
              spreadRadius: 2.0,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          '${projectName}',
                          style: GoogleFonts.outfit(
                            fontSize: screenWidth * 0.031,
                            fontWeight: FontWeight.w600,
                            color: Colors.black
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.007),
                      Row(
                        children: [
                          Text(
                            'UNIT NO: ',
                            style: GoogleFonts.outfit(fontSize: screenWidth * 0.035),
                          ),
                          Text(
                            unit.unit_no,
                            style: GoogleFonts.outfit(
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.01),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: screenWidth * 0.1,
                        height: screenWidth * 0.1,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black),
                          image: DecorationImage(
                            image: AssetImage('assets/profile.jpeg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        "S.Vishal Kumar",
                        //unit.user,
                        style: GoogleFonts.outfit(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: screenWidth * 0.2),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.003,
                        horizontal: screenWidth * 0.04,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0XFFDFF6E0),
                      ),
                      child: Text(
                        unit['status'],
                        style: GoogleFonts.outfit(
                          color: Color(0xff1B6600),
                          fontWeight: FontWeight.w400,
                          fontSize: screenWidth * 0.035,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.025),
                    Text(
                      'Total Due',
                      style: GoogleFonts.outfit(fontSize: screenWidth * 0.035),
                    ),
                    SizedBox(height: screenHeight * 0.005),
                    Text(
                      '₹${(unit['T_elgible_balance'] as num).toInt()}',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w700,
                        fontSize: screenWidth * 0.05,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    InkWell(
                      onTap: () => Get.toNamed(
                        '/project-detail',
                        arguments: {
                          'projectName': projectName,
                          'unit': unit,
                        },
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Know More',
                            style: GoogleFonts.outfit(
                              color: Color(0xff656567),
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.035),
                          Container(
                            width: screenWidth * 0.06,
                            height: screenWidth * 0.06,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_forward,
                              size: screenWidth * 0.05,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
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
