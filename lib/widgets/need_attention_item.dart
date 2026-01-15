import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../models/unit_model.dart';
import '../utils/project_style.dart';
import 'needs_attention_detail_sheet.dart';

class NeedsAttentionItem extends StatelessWidget {
  final UnitModel unit;
  final int index;
  final VoidCallback? onPayNow;

  const NeedsAttentionItem({
    super.key,
    required this.unit,
    required this.index,
    this.onPayNow,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      clipBehavior: Clip.hardEdge,
      child: Row(
        children: [
          // Left Strip
          Container(
            width: 30,
            height: 120, // Approx height to match content
            color: Colors.black,
            alignment: Alignment.center,
            child: const RotatedBox(
              quarterTurns: 3,
              child: Text(
                "DUE",
                style: TextStyle(
                  fontFamily: 'Host Grotesk',
                  color: Colors.white,
                  fontSize: 10,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Middle Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'UNIT NO: ${unit.unit_no}',
                        style: TextStyle(
                          fontFamily: 'Host Grotesk',
                          fontWeight: FontWeight.w600,
                          fontSize: screenWidth * 0.035,
                          color: Color(0xff191B1C),
                        ),
                      ),
                      // Icon(Icons.info_outline, size: 16, color: Colors.grey),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Clear your Outstanding amount for Legal charges',
                    style: TextStyle(
                      fontFamily: 'Host Grotesk',
                      fontSize: screenWidth * 0.032,
                      color: Color(0xff656567),
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 12),
                  const Divider(height: 1),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      Get.bottomSheet(
                        NeedsAttentionDetailSheet(unit: unit),
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                      );
                    },
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            "₹ ${ProjectStyle.formatCurrency(unit.amount)}",
                            style: TextStyle(
                              fontFamily: 'Host Grotesk',
                              color: Color(0xff191B1C),
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.04,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Text(
                            'Due in ${unit.daysLeft} days',
                            style: TextStyle(
                              fontFamily: 'Host Grotesk',
                              color: Colors.red[700],
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Vertical Divider
          Container(width: 1, height: 120, color: Colors.grey[300]),

          // Right Action Panel
          GestureDetector(
            onTap: onPayNow,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: Colors.transparent, // Ensure clickable area
              child: Row(
                children: [
                  Text(
                    "Pay Now",
                    style: TextStyle(
                      fontFamily: "Host Grotesk",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8B6B43), // Accent color
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.chevron_right, size: 18, color: Color(0xFF8B6B43)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
