import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/project_model.dart';

class ProjectCard extends StatelessWidget {
  final ProjectModel project;

  const ProjectCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      color: Colors.grey[100],
      width:
          screenWidth * 0.45, // Each card takes about half of the screen width
      height: screenHeight * 0.55, // Increased height for better spacing
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image with increased height
          Container(
            width: screenWidth * 0.45,
            height:
                screenHeight * 0.3, // Increased height for better visibility
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            child: Image.asset('assets/project_new.png', fit: BoxFit.cover),
          ),

          SizedBox(
            height: screenHeight * 0.008,
          ), // Space between image and text
          // Use Expanded to prevent overflow
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Project Name
                Text(
                  project.name,
                  style: GoogleFonts.outfit(
                    color: Colors.black,
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: screenHeight * 0.007),

                // Location with Icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.grey,
                      size: screenWidth * 0.04,
                    ),
                    SizedBox(width: screenWidth * 0.005),
                    Text(
                      project.location,
                      style: GoogleFonts.outfit(
                        color: Color(0xff656567),
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.015),

                // Price inside a button with black border
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 6.0),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.008,
                          horizontal: screenWidth * 0.035,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                          ), // Black border
                          // borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "₹${project.price}", // Extracting price amount
                              style: GoogleFonts.outfit(
                                color: Color(0xff191B1C),
                                fontWeight: FontWeight.w600,
                                fontSize:
                                    screenWidth *
                                    0.048, // Larger font for price amount
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.01),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                // project.price.split(" ")[1], // Extracting "onwards"
                                " Onwards",
                                style: GoogleFonts.outfit(
                                  color: Color(0xff191B1C),
                                  fontSize:
                                      screenWidth *
                                      0.03, // Smaller font for "onwards"
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
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
        ],
      ),
    );
  }
}
