import 'package:flutter/material.dart';

class TransactionModel {
  final int id;
  final String paidOn; // Display date
  final String mode;
  final String bankRefId;
  final double amount;
  final String status;
  final String accountsName; // Towards
  final String reviewerName; // customerName or verifyBy
  final String downloadUrl;

  final IconData? assignedIcon;

  TransactionModel({
    required this.id,
    required this.paidOn,
    required this.mode,
    required this.bankRefId,
    required this.amount,
    required this.status,
    required this.accountsName,
    required this.reviewerName,
    required this.downloadUrl,
    this.assignedIcon,
  });

  // Getters to match UI expectation
  IconData get icon => assignedIcon ?? _getIconFromMode(mode);
  String get name => accountsName;
  String get details => "$mode ${status.isNotEmpty ? '- $status' : ''}";
  String get date => paidOn;

  IconData _getIconFromMode(String mode) {
    print("Mode: $mode");
    switch (mode.toLowerCase()) {
      case 'upi':
      case 'online':
        return Icons.credit_card_outlined;
      case 'cash':
        return Icons.money_outlined;
      case 'cheque':
        return Icons.branding_watermark_outlined;
      default:
        return Icons.payment_outlined;
    }
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    // Helper to safely parse double
    double safeDouble(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      if (val is String) return double.tryParse(val) ?? 0.0;
      return 0.0;
    }

    String formatDate(dynamic timestamp) {
      if (timestamp == null) return "-";
      try {
        // If it's a millisecond timestamp
        if (timestamp is int) {
          final dt = DateTime.fromMillisecondsSinceEpoch(timestamp);
          // Format: 30-Sep-2025
          return "${dt.day.toString().padLeft(2, '0')}-${_getMonth(dt.month)}-${dt.year}";
        }
        // If it's a string ISO
        if (timestamp is String) {
          final dt = DateTime.parse(timestamp);
          return "${dt.day.toString().padLeft(2, '0')}-${_getMonth(dt.month)}-${dt.year}";
        }
      } catch (e) {
        return timestamp.toString();
      }
      return "-";
    }

    return TransactionModel(
      id:
          json['id'] is int
              ? json['id']
              : int.tryParse(json['id'].toString()) ?? 0,
      paidOn: formatDate(json['txt_dated'] ?? json['created_at']),
      mode: json['mode'] ?? '',
      bankRefId: json['bank_ref']?.toString() ?? '',
      amount: safeDouble(json['totalAmount']),
      status: json['status'] ?? '',
      accountsName:
          "${json['towards'] ?? ''}\n${json['customerName'] ?? ''}".trim(),
      reviewerName: json['verifiedBy'] ?? 'No Data',
      downloadUrl: json['attchUrl'] ?? '',
    );
  }

  static String _getMonth(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}
