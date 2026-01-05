import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final TransactionDetailsController controller = Get.put(
    TransactionDetailsController(),
  );

  TransactionDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Transaction Details',
          style: TextStyle(
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[200], // Grey background
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTransactionSummary(context),
            SizedBox(height: screenHeight * 0.02),
            _buildTransactionIds(context),
            SizedBox(height: screenHeight * 0.04),
            _buildSupportSection(context),
          ],
        ),
      ),
    );
  }

  /// Shubha Ecostone, Amount, Details, and SBI Bank grouped in one container
  /// Shubha Ecostone, Amount, Details, and SBI Bank grouped in one container
  Widget _buildTransactionSummary(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.circular(10),
        // border: Border.all(color: Colors.black, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width:
                    screenWidth * 0.14, // Same width & height to make it square
                height: screenWidth * 0.14,
                decoration: BoxDecoration(
                  color: Colors.white, // White background
                  // borderRadius: BorderRadius.circular(8), // Slightly rounded corners (Optional)
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ), // Black border (Optional)
                ),
                alignment: Alignment.center,
                child: Text(
                  'S',
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    color: Colors.black, // Black text
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(width: screenWidth * 0.03),
              Text(
                'Shubha Ecostone',
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: screenWidth * 0.03),
          Divider(color: Colors.black), // Black divider
          SizedBox(height: screenWidth * 0.03),

          /// Amount, Date, and Confirmed status in one row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '₹ 1,32,000',
                    style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.01),
                  Text(
                    '29 Nov, 11 Mar 2025', // Date below amount
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.03,
                  vertical: screenWidth * 0.01,
                ),
                decoration: BoxDecoration(
                  color: Colors.green[100], // Green background
                  // borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'CONFIRMED',
                  style: TextStyle(
                    color: Colors.green[800], // Green text
                    fontSize: screenWidth * 0.035,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: screenWidth * 0.04),

          /// UPI Details
          Row(
            children: [
              Image.asset('assets/sbi.png', width: screenWidth * 0.08),
              SizedBox(width: screenWidth * 0.03),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SBI BANK', // SBI Bank moved below UPI details
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'UPI',
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    'XXXXXXXXXX 0987',
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Transaction ID and Paid from UPI ID grouped together
  Widget _buildTransactionIds(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity, // Makes the container take full width
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.circular(10),
        // border: Border.all(color: Colors.black, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIdItem('TRANSACTION ID', '1234567890ABCDEF', context),
          SizedBox(height: screenWidth * 0.03),
          _buildIdItem('PAID TO UPI ID', 'user@okhdfcbank', context),
          SizedBox(height: screenWidth * 0.03),
          _buildIdItem('PAID FROM UPI ID', 'user@okhdfcbank', context),
        ],
      ),
    );
  }

  /// Reusable ID item widget
  Widget _buildIdItem(String title, String value, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: screenWidth * 0.035,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: screenWidth * 0.01),
        Text(
          value,
          style: TextStyle(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  /// Support section with bold heading and left-aligned button
  Widget _buildSupportSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Still having trouble??',
          style: TextStyle(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.bold, // Bold
          ),
        ),
        SizedBox(height: screenWidth * 0.03),
        Text(
          'Our Support team should be able to help you out at any time...',
          style: TextStyle(
            fontSize: screenWidth * 0.035,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: screenWidth * 0.04),
        Align(
          alignment: Alignment.centerLeft, // Left-aligned button
          child: ElevatedButton(
            onPressed: controller.contactSupport,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white, // Light lavender background
              side: BorderSide(color: Colors.black), // Black border
              shape: RoundedRectangleBorder(
                // borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                // horizontal: screenWidth * 0.1,
                // vertical: screenWidth * 0.025,
              ),
              child: Text(
                'Contact Support',
                style: TextStyle(
                  color: Colors.black, // Black text
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TransactionDetailsController extends GetxController {
  void contactSupport() {
    Get.snackbar(
      'Support',
      'Redirecting to support...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
