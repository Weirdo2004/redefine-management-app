// UNUSED AS OF NOW!!!!!

import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectStatsCard extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final String? projectId;

  const ProjectStatsCard({
    super.key,
    this.startDate,
    this.endDate,
    this.projectId,
  });

  @override
  Widget build(BuildContext context) {
    // Get AuthService to access dynamic collection name
    final AuthService authService = Get.find<AuthService>();

    return Obx(() {
      final String collectionName = authService.leadsCollectionName.value;

      // If collection name is not yet fetched, show loading or empty state
      if (collectionName.isEmpty) {
        return _buildCardContent(countText: "...");
      }

      Query collection = FirebaseFirestore.instance.collection(collectionName);

      if (startDate != null && endDate != null) {
        int startMillis = startDate!.millisecondsSinceEpoch;
        int endMillis = endDate!.millisecondsSinceEpoch;
        collection = collection
            .where('Date', isGreaterThanOrEqualTo: startMillis)
            .where('Date', isLessThan: endMillis);
      }

      if (projectId != null) {
        collection = collection.where('ProjectId', isEqualTo: projectId);
      }

      return FutureBuilder<AggregateQuerySnapshot>(
        future: collection.count().get(),
        builder: (context, snapshot) {
          String countText = "...";
          if (snapshot.hasData) {
            countText = snapshot.data!.count.toString();
          }
          return _buildCardContent(countText: countText);
        },
      );
    });
  }

  Widget _buildCardContent({required String countText}) {
    return Container(
      padding: const EdgeInsets.all(10), // Reduced from 20
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF2C9F6E).withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total Projects Header
          Row(
            children: [
              Text(
                'Total Leads',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF6B6B6B),
                ),
              ),
              const Spacer(), // Use Spacer instead of fixed width
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C9F6E).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  countText,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2C9F6E),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 1),

          // Stats Grid
        ],
      ),
    );
  }
}
