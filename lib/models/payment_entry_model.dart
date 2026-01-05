// Models
import 'package:flutter/material.dart';

class PaymentEntry {
  final String number;
  final String date;
  final String description;
  final String amount;
  final String received;
  final String balance;
  final String status;
  final Color statusColor;

  PaymentEntry({
    required this.number,
    required this.date,
    required this.description,
    required this.amount,
    required this.received,
    required this.balance,
    required this.status,
    required this.statusColor,
  });

  factory PaymentEntry.fromJson(Map<String, dynamic> json) {
    return PaymentEntry(
      number: json['number'] ?? '',
      date: json['date'] ?? '',
      description: json['description'] ?? '',
      amount: json['amount'] ?? '',
      received: json['received'] ?? '',
      balance: json['balance'] ?? '',
      status: json['status'] ?? '',
      statusColor: json['statusColor'] ?? Colors.grey,
    );
  }
}
