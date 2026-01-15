import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/unit_model.dart';
import '../controllers/project_controller.dart';
import '../utils/project_style.dart';
import 'needs_attention_sheet.dart';

class NeedsAttentionDetailSheet extends StatelessWidget {
  final UnitModel unit;

  const NeedsAttentionDetailSheet({super.key, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        24 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'NEEDS ATTENTION',
                style: TextStyle(
                  fontFamily: 'Host Grotesk',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: Colors.grey[600],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Get.back(),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Legal Charges', // Hardcoded description for now based on context, can be dynamic later if needed
            style: TextStyle(
              fontFamily: 'Host Grotesk',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Unit No: ${unit.unit_no}',
            style: TextStyle(
              fontFamily: 'Host Grotesk',
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          _buildDetailRow(
            'Due Amount',
            "₹ ${ProjectStyle.formatCurrency(double.tryParse(unit.amount?.replaceAll(',', '') ?? '0') ?? 0)}",
          ),
          const Divider(height: 32),
          _buildDetailRow(
            'Status',
            'Due in ${unit.daysLeft} days',
            valColor: Colors.red[700],
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final ProjectController projectController =
                    Get.find<ProjectController>();
                Get.back();
                Get.bottomSheet(
                  NeedsAttentionSheet(
                    items: projectController.attentionItems.toList(),
                  ),
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Pay Now',
                style: TextStyle(
                  fontFamily: 'Host Grotesk',
                  color: Colors.black,
                  fontSize: 16,
                  //fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Host Grotesk',
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Host Grotesk',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: valColor ?? Colors.black,
          ),
        ),
      ],
    );
  }
}
