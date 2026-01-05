import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ReferAndEarnScreen extends StatelessWidget {
  const ReferAndEarnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),

            // Logo
            SizedBox(height: 40),

            // Heading
            Text(
              "Sign in to refer & earn rewards",
              style: GoogleFonts.outfit(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),

            // Subtitle
            Text(
              "Get your friends on CheckIn and earn rewards",
              style: GoogleFonts.outfit(fontSize: 14, color: Colors.grey[600]),
            ),
            SizedBox(height: 40),

            // Phone Input Container
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.zero, // Sharp corners as per image
              ),
              child: Row(
                children: [
                  // Country Code
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 12.0,
                    ),
                    child: Row(
                      children: [
                        // Flag Placeholder (or use emoji/image if available)
                        // Image.asset('assets/india_flag.png', width: 20),
                        Container(
                          width: 24,
                          height: 16,
                          color: Colors.orange,
                        ), // Fallback flag
                        SizedBox(width: 8),
                        Text(
                          "+91",
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down_outlined,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  Container(width: 1, height: 48, color: Colors.grey[300]),
                  // Phone Number Field
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Enter mobile numb...",
                        hintStyle: GoogleFonts.outfit(color: Colors.grey[400]),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      keyboardType: TextInputType.phone,
                      style: GoogleFonts.outfit(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Continue Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Logic to be implemented
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero, // Sharp corners
                  ),
                ),
                child: Text(
                  "Continue",
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
