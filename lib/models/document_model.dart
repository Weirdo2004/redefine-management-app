import 'package:flutter/material.dart';

class DocumentModel {
  final String id;
  final String name;
  final String url;
  final String category;
  final String uploadedBy;
  final DateTime uploadedOn;
  final IconData? icon;

  DocumentModel({
    required this.id,
    required this.name,
    required this.url,
    required this.category,
    required this.uploadedBy,
    required this.uploadedOn,
    this.icon,
  });

  factory DocumentModel.fromJson(String id, Map<String, dynamic> json) {
    return DocumentModel(
      id: id,
      name: json['name'] ?? 'Unknown',
      url: json['url'] ?? '',
      category: json['cat'] ?? 'Others',
      uploadedBy: json['by'] ?? 'Unknown',
      uploadedOn:
          json['uploadedOn'] != null
              ? DateTime.fromMillisecondsSinceEpoch(json['uploadedOn'] as int)
              : DateTime.now(),
    );
  }

  String get formattedDate {
    return "${uploadedOn.day}/${uploadedOn.month}/${uploadedOn.year}";
  }
}
