import 'package:flutter/material.dart';

import '../models/transaction_model.dart';
import '../utils/project_style.dart';

class TransactionItem extends StatefulWidget {
  final TransactionModel transaction;
  final int index;

  const TransactionItem({super.key, required this.transaction, this.index = 0});

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ProjectStyle.surfaceColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade100, // Grey background as requested
                ),
                child: Icon(
                  widget.transaction.icon,
                  size: 20,
                  color: ProjectStyle.iconColor,
                ),
              ),
              const SizedBox(width: 12),

              // Main Info: Paid On & Amount
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Paid On: ${widget.transaction.paidOn}",
                      style: ProjectStyle.bodyText.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "₹ ${ProjectStyle.formatCurrency(widget.transaction.amount)}",
                      style: ProjectStyle.headlineText.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromARGB(255, 68, 68, 68),
                      ),
                    ),
                  ],
                ),
              ),

              // Toggle Button
              IconButton(
                icon: Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: ProjectStyle.iconColor,
                ),
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
              ),
            ],
          ),

          // Expanded Details
          if (isExpanded) ...[
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            _buildDetailRow("Mode", widget.transaction.mode),
            _buildDetailRow("Bank Ref", widget.transaction.bankRefId),

            // Status with color chip
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Status", style: ProjectStyle.captionText),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0XFFDFF6E0).withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.transaction.status,
                      style: TextStyle(
                        fontFamily: ProjectStyle.fontFamily,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff1B6600),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            _buildDetailRow("Accounts", widget.transaction.accountsName),
            _buildDetailRow("Reviewer", widget.transaction.reviewerName),

            if (widget.transaction.downloadUrl.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Attachment", style: ProjectStyle.captionText),
                    InkWell(
                      onTap: () {
                        // Handle download
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.download_outlined,
                            size: 16,
                            color: ProjectStyle.accentColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Download",
                            style: TextStyle(
                              fontFamily: ProjectStyle.fontFamily,
                              color: ProjectStyle.accentColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: ProjectStyle.captionText),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: ProjectStyle.bodyText.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
