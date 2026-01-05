import 'package:flutter/material.dart';

class DocumentModel {
  final IconData icon_outline;
  final String name;
  final String date;
  final String fileSize;

  DocumentModel({
    required this.icon_outline,
    required this.name,
    required this.date,
    required this.fileSize,
  });
}
