import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/quick_action_model.dart';

class QuickActionsSection extends StatelessWidget {
  final List<QuickActionModel> actions;

  const QuickActionsSection({super.key, required this.actions});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
          child: const Text(
            'QUICK ACTIONS',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: actions.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder:
              (context, index) => _buildQuickActionItem(actions[index]),
        ),
      ],
    );
  }

  Widget _buildQuickActionItem(QuickActionModel action) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        title: Text(
          action.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            action.description,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ),
        trailing: const Icon(Icons.keyboard_arrow_right, size: 28),
        onTap: () => _handleQuickAction(action.title),
      ),
    );
  }

  void _handleQuickAction(String action) {
    switch (action) {
      case 'Cost Sheet':
        Get.toNamed('/cost-sheet');
        break;
      case 'Payment Schedule':
        Get.toNamed('/payment-schedule');
        break;
      case 'Modifications':
        Get.toNamed('/modification');
        break;
      case 'Activity Log':
      case 'Activity log':
        Get.toNamed('/activity-log');
        break;
      case 'Make Payment':
        // Dummy actions, no navigation
        print('Dummy action tapped: $action');
        break;
      default:
        // Handle unknown action or do nothing
        print('Unknown action: $action');
        break;
    }
  }
}
