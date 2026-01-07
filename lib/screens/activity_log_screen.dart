import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/activity_log_controller.dart';
import '../controllers/project_controller.dart';
import '../models/activity_entry_model.dart';
import '../utils/app_colors.dart';
import '../widgets/quick_actions_section.dart';
import '../utils/project_style.dart';

class ActivityLogScreen extends StatelessWidget {
  final ActivityLogController _controller = Get.put(ActivityLogController());

  ActivityLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: _buildAppBar(context, screenWidth, screenHeight),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          ProjectStyle.pagePadding,
          ProjectStyle.pagePadding,
          ProjectStyle.pagePadding,
          ProjectStyle.pagePadding + MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          children: [
            _buildActivityList(screenWidth, screenHeight),
            SizedBox(height: 18),
            DottedSeparator(color: ProjectStyle.secondaryTextColor),
            SizedBox(height: ProjectStyle.sectionSpacing),
            _buildQuickActionsSection(screenWidth, screenHeight),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(
    BuildContext context,
    double screenWidth,
    double screenHeight,
  ) {
    return AppBar(
      backgroundColor: ProjectStyle.appbarbackgroundColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_outlined,
          size: screenHeight * 0.025,
          color: ProjectStyle.iconColor,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      titleSpacing: 0,
      title: Transform.translate(
        offset: const Offset(-8, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Activity Log',
              style: TextStyle(
                fontFamily: ProjectStyle.fontFamily,
                fontSize: screenHeight * 0.022,
                fontWeight: FontWeight.bold,
                color: ProjectStyle.primaryTextColor,
              ),
            ),
            Text(
              'Test Project - 131',
              style: TextStyle(
                fontFamily: ProjectStyle.fontFamily,
                fontSize: screenHeight * 0.016,
                color: ProjectStyle.secondaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityList(double screenWidth, double screenHeight) {
    return Obx(() {
      if (_controller.isLoading.value) {
        return Container(
          height: screenHeight * 0.5,
          alignment: Alignment.center,
          child: CircularProgressIndicator(color: AppColors.primaryColor),
        );
      }

      if (_controller.activities.isEmpty) {
        return Container(
          height: screenHeight * 0.5,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.history, size: 48, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                "No activity logs validation found",
                style: TextStyle(
                  color: ProjectStyle.secondaryTextColor,
                  fontSize: 16,
                  fontFamily: ProjectStyle.fontFamily,
                ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: _controller.activities.length,
        itemBuilder:
            (context, index) => _buildActivityItem(
              screenWidth,
              screenHeight,
              _controller.activities[index],
              index == _controller.activities.length - 1,
            ),
      );
    });
  }

  Widget _buildActivityItem(
    double screenWidth,
    double screenHeight,
    ActivityEntry activity,
    bool isLast,
  ) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTimeline(screenHeight, isLast),
          SizedBox(width: screenWidth * 0.04),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: isLast ? 0 : screenHeight * 0.02),
              decoration: BoxDecoration(color: Colors.white),
              padding: EdgeInsets.all(screenHeight * 0.015),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        activity.title,
                        style: TextStyle(
                          fontSize: screenHeight * 0.018,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.03,
                          vertical: screenHeight * 0.005,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(
                            activity.status,
                          ).withOpacity(0.2),
                          border: Border.all(
                            color: _getStatusColor(activity.status),
                          ),
                        ),
                        child: Text(
                          activity.status,
                          style: TextStyle(
                            fontSize: screenHeight * 0.014,
                            fontWeight: FontWeight.w900,
                            color: _getStatusColor(activity.status),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.008),
                  Text(
                    'By: ${activity.author}',
                    style: TextStyle(
                      fontSize: screenHeight * 0.015,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    'On: ${activity.date}',
                    style: TextStyle(
                      fontSize: screenHeight * 0.015,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(double screenHeight, bool isLast) {
    return Column(
      children: [
        Container(
          width: screenHeight * 0.015,
          height: screenHeight * 0.015,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            shape: BoxShape.circle,
          ),
        ),
        if (!isLast)
          Expanded(child: Container(width: 2, color: AppColors.primaryColor)),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'CONFIRMED':
        return Colors.green;
      case 'IN PROGRESS':
        return Colors.orange;
      case 'REJECTED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildQuickActionsSection(double screenWidth, double screenHeight) {
    // Ensure ProjectController is found
    final ProjectController projectController = Get.find<ProjectController>();

    return QuickActionsSection(actions: projectController.quickActions);
  }
}
