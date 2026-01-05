import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/project_controller.dart';
import '../widgets/quick_actions_section.dart';
import '../utils/project_style.dart';
import '../widgets/payment_card.dart';

class PaymentScheduleScreen extends StatelessWidget {
  PaymentScheduleScreen({super.key});

  final ProjectController projectController = Get.find<ProjectController>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: ProjectStyle.backgroundColor,
      appBar: _buildAppBar(screenHeight),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          ProjectStyle.pagePadding,
          ProjectStyle.pagePadding,
          ProjectStyle.pagePadding,
          ProjectStyle.pagePadding + MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTotalBalance(screenHeight),
            SizedBox(height: screenHeight * 0.02),
            //const DottedSeparator(color: Colors.grey),
            //SizedBox(height: screenHeight * 0.02),
            _buildPaymentPreview(screenWidth, screenHeight),
            //SizedBox(height: screenHeight * 0.02),
            const DottedSeparator(color: Colors.grey),
            SizedBox(height: screenHeight * 0.02),
            _buildQuickActionsSection(screenWidth, screenHeight),
          ],
        ),
      ),
    );
  }

  // ---------------- APP BAR ----------------

  AppBar _buildAppBar(double screenHeight) {
    return AppBar(
      backgroundColor: ProjectStyle.appbarbackgroundColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_outlined,
          size: screenHeight * 0.025,
          color: ProjectStyle.iconColor,
        ),
        onPressed: Get.back,
      ),
      titleSpacing: 0,
      title: Transform.translate(
        offset: const Offset(-8, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Schedule',
              style: ProjectStyle.titleText.copyWith(
                fontSize: screenHeight * 0.021,
              ),
            ),
            Text(
              'Test Project - 131',
              style: ProjectStyle.captionText.copyWith(
                fontSize: screenHeight * 0.015,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- TOTAL BALANCE ----------------

  Widget _buildTotalBalance(double screenHeight) {
    return InkWell(
      onTap: () => _showBalanceDetails(screenHeight),
      child: Container(
        padding: const EdgeInsets.all(0),
        margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.hardEdge,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 20,
                color: Colors.black,
                alignment: Alignment.center,
                child: const RotatedBox(
                  quarterTurns: 3,
                  child: Text(
                    "SUMMARY",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      letterSpacing: 1.1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 2),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            "Total Balance",
                            style: ProjectStyle.smallText.copyWith(
                              fontSize: 18,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.account_balance_wallet_outlined,
                            color: Colors.blue,
                            size: 20,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Obx(
                        () => Text(
                          "₹ ${ProjectStyle.formatCurrency(projectController.totalAmount.value)}",
                          style: ProjectStyle.headlineText.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const DottedSeparator(color: Colors.grey),
                      const SizedBox(height: 3),
                      Text(
                        "Tap to view payment details",
                        style: ProjectStyle.smallText.copyWith(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(width: 1, color: Colors.grey[300]),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Row(
                  children: [
                    Text(
                      "View details",
                      style: TextStyle(
                        fontFamily: ProjectStyle.fontFamily,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(Icons.chevron_right, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBalanceDetails(double screenHeight) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(ProjectStyle.pagePadding),
        decoration: const BoxDecoration(
          color: ProjectStyle.surfaceColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Payment Summary",
              style: ProjectStyle.headlineText.copyWith(fontSize: 20),
            ),
            const SizedBox(height: ProjectStyle.gapLarge),
            Obx(
              () => _buildDetailRow(
                "Total Balance",
                "₹ ${ProjectStyle.formatCurrency(projectController.totalAmount.value)}",
                isBold: true,
              ),
            ),
            const SizedBox(height: ProjectStyle.gapLarge),
          ],
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: ProjectStyle.bodyText.copyWith(
            color:
                isBold
                    ? ProjectStyle.primaryTextColor
                    : ProjectStyle.secondaryTextColor,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: ProjectStyle.bodyText.copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            fontSize: isBold ? 16 : 14,
          ),
        ),
      ],
    );
  }

  // ---------------- PAYMENT PREVIEW (3 CARDS) ----------------

  Widget _buildPaymentPreview(double screenWidth, double screenHeight) {
    return Obx(() {
      final payments = projectController.payments;
      final previewCount = payments.length > 3 ? 3 : payments.length;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: previewCount,
            separatorBuilder: (context, index) => const SizedBox(height: 4),

            itemBuilder:
                (context, index) => PaymentCard(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  payment: payments[index],
                  showBorder: false,
                ),
          ),
          const SizedBox(height: 16),
          if (payments.length > 3)
            Column(
              children: [
                GestureDetector(
                  onTap:
                      () => _openAllPaymentsBottomSheet(
                        screenWidth,
                        screenHeight,
                      ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'View all payments',
                      style: TextStyle(
                        fontFamily: ProjectStyle.fontFamily,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: ProjectStyle.primaryTextColor,
                      ),
                    ),
                  ),
                ),
                // Adjust spacing below the button here
                SizedBox(height: screenHeight * 0.02),
              ],
            ),
        ],
      );
    });
  }

  // ---------------- BOTTOM SHEET ----------------

  void _openAllPaymentsBottomSheet(double screenWidth, double screenHeight) {
    Get.bottomSheet(
      Container(
        height: screenHeight * 0.65,
        color: ProjectStyle.surfaceColor,
        child: Column(
          children: [
            SizedBox(height: 8),
            // Drag Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: ProjectStyle.pagePadding,
                vertical: 8.0,
              ),
              child: Center(
                child: const Text(
                  'All Payments',
                  style: ProjectStyle.titleText,
                ),
              ),
            ),
            const Divider(height: 1, thickness: 0),
            SizedBox(height: 4),
            Expanded(
              child: Obx(
                () => ListView.separated(
                  padding: const EdgeInsets.only(
                    left: ProjectStyle.pagePadding,
                    right: ProjectStyle.pagePadding,
                    bottom: ProjectStyle.pagePadding,
                  ),
                  itemCount: projectController.payments.length,
                  separatorBuilder:
                      (context, index) => const SizedBox(height: 4),
                  itemBuilder:
                      (context, index) => PaymentCard(
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                        payment: projectController.payments[index],
                        //isFlat: true,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  // ---------------- QUICK ACTIONS ----------------

  Widget _buildQuickActionsSection(double screenWidth, double screenHeight) {
    return QuickActionsSection(actions: projectController.quickActions);
  }
}
