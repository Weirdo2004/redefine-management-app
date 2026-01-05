import 'package:flutter/material.dart';
import '../models/quick_action_model.dart';

class QuickActionItem extends StatelessWidget {
  final QuickActionModel action;
  final double screenWidth;

  const QuickActionItem({
    super.key,
    required this.action,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
      child: ListTile(
        leading: Icon(
          Icons.bolt_outlined,
          size: screenWidth * 0.06,
          color: Colors.orange,
        ),
        title: Text(
          action.title,
          style: TextStyle(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          action.description,
          style: TextStyle(fontSize: screenWidth * 0.035),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: screenWidth * 0.05),
      ),
    );
  }
}
