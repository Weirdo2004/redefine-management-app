import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

const String projectSampleRoute = '/project_sample';

class HomeCards extends StatelessWidget {
  const HomeCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildUpiCard()),
        const SizedBox(width: 12),
        Expanded(child: _buildGoldCard()),
      ],
    );
  }

  Widget _buildUpiCard() {
    return GestureDetector(
      onTap: () {
        Get.toNamed(projectSampleRoute);
      },
      child: Container(
        height: 230, // Increased height to fit content
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Main Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Icon(Icons.qr_code, size: 16, color: Colors.brown),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Moneyview UPI",
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Divider(height: 1, color: Colors.orange.shade100),
                    const SizedBox(height: 12),

                    // Offer Text
                    Text(
                      "Chance to Win",
                      style: GoogleFonts.outfit(
                        color: const Color(0xFF134044),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "up to ₹100",
                      style: GoogleFonts.outfit(
                        color: const Color(0xFF134044),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "on all payments*",
                      style: GoogleFonts.outfit(
                        color: const Color(0xFF134044),
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 16),
                    // Small Divider
                    Container(
                      width: 40,
                      height: 2,
                      color: Colors.orange.shade200,
                    ),
                    const SizedBox(height: 8),

                    // Powered By
                    Row(
                      children: [
                        Text(
                          "POWERED BY",
                          style: GoogleFonts.outfit(
                            fontSize: 8,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.payment,
                          size: 12,
                          color: Colors.grey.shade600,
                        ), // Placeholder for UPI
                        const SizedBox(width: 4),
                        Icon(
                          Icons.account_balance,
                          size: 12,
                          color: Colors.blue.shade800,
                        ), // Placeholder for HDFC
                        const SizedBox(width: 2),
                        Text(
                          "HDFC BANK",
                          style: GoogleFonts.outfit(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),

            // Footer
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFF7D50), // Orange
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(5),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    "Claim Offer",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_forward,
                      color: const Color(0xFFFF7D50),
                      size: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoldCard() {
    return GestureDetector(
      onTap: () {
        Get.toNamed(projectSampleRoute);
      },
      child: Container(
        height: 230, // Match Height
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFBE8F8), Color(0xFFFFF6E5)], // Pink to Gold
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Main Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          size: 16,
                          color: Colors.purple,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Moneyview Gold",
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple.shade900,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Divider(height: 1, color: Colors.purple.shade100),
                    const SizedBox(height: 12),

                    // Offer Text
                    Text(
                      "Win from Mega Jackpot",
                      style: GoogleFonts.outfit(
                        color: Colors.purple.shade900,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "₹4,00,000",
                      style: GoogleFonts.outfit(
                        color: const Color(0xFF134044),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "FREE GOLD*",
                      style: GoogleFonts.outfit(
                        color: const Color(0xFF134044),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const Spacer(),

                    // Small Divider
                    Container(
                      width: 40,
                      height: 2,
                      color: const Color(0xFF134044),
                    ),
                    const SizedBox(height: 8),

                    // Partner Details
                    Row(
                      children: [
                        Text(
                          "Powered by",
                          style: GoogleFonts.outfit(
                            fontSize: 8,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            "CARATLANE A TATA PRODUCT",
                            style: GoogleFonts.outfit(
                              fontSize: 7, // Reduced slightly
                              fontWeight: FontWeight.bold,
                              color: Colors.purple.shade900,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),

            // Footer (Transparent/Integrated look for Gold Card)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Text(
                    "Claim Offer",
                    style: GoogleFonts.outfit(
                      color: const Color(0xFF134044),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF134044),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
