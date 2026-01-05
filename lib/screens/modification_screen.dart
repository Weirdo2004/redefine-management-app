import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/modification_controller.dart';
import '../controllers/project_controller.dart';
import '../widgets/quick_actions_section.dart';

import '../utils/project_style.dart';

class ModificationScreen extends StatelessWidget {
  final ModificationController _controller = Get.put(ModificationController());

  ModificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: ProjectStyle.backgroundColor,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          ProjectStyle.pagePadding,
          ProjectStyle.pagePadding,
          ProjectStyle.pagePadding,
          ProjectStyle.pagePadding + MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopModifications(screenWidth, screenHeight),
            _buildDescriptionSection(screenWidth, screenHeight),
            _buildHelpDeskSection(screenWidth, screenHeight),
            _buildQuickActionsSection(screenWidth, screenHeight),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: ProjectStyle.appbarbackgroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: ProjectStyle.iconColor),
        onPressed: () => Get.back(),
      ),
      titleSpacing: 0,
      title: Transform.translate(
        offset: const Offset(-8, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Modification', style: ProjectStyle.titleText),
            const SizedBox(height: 2),
            Text(
              'Test Project - 131',
              style: ProjectStyle.smallText.copyWith(fontSize: 12),
            ),
          ],
        ),
      ),
      // centerTitle: true, // Removed centerTitle as we are custom aligning
    );
  }

  Widget _buildTopModifications(double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('TOP MODIFICATIONS', style: ProjectStyle.sectionHeaderText),
        const SizedBox(height: 10),
        SizedBox(
          height: 60, // Fixed height for consistency
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _controller.categories.length,
            itemBuilder:
                (context, index) => _buildCategoryItem(
                  _controller.categories[index],
                  () => _controller.selectedCategoryIndex.value = index,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(Map<String, dynamic> category, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: ProjectStyle.surfaceColor,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(category['icon'], size: 20, color: ProjectStyle.iconColor),
            const SizedBox(width: 8),
            Text(
              category['label'],
              style: ProjectStyle.bodyText.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionSection(double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: ProjectStyle.sectionSpacing * 2),
        const Text('DESCRIPTION', style: ProjectStyle.sectionHeaderText),
        const SizedBox(height: 10),
        TextField(
          controller: _controller.descriptionController,
          maxLines: 5,
          style: ProjectStyle.bodyText,
          decoration: InputDecoration(
            hintText: 'Describe your specification',
            hintStyle: ProjectStyle.bodyText.copyWith(color: Colors.grey),
            filled: true,
            fillColor: ProjectStyle.surfaceColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(ProjectStyle.internalPadding),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            InkWell(
              onTap: _attachReference,
              child: Row(
                children: [
                  const Icon(
                    Icons.attach_file,
                    size: 20,
                    color: ProjectStyle.iconColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Attach reference',
                    style: ProjectStyle.bodyText.copyWith(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _submitModification,
              style: ElevatedButton.styleFrom(
                backgroundColor: ProjectStyle.primaryTextColor, // Black button
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: Text(
                'Submit',
                style: ProjectStyle.bodyText.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHelpDeskSection(double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: ProjectStyle.sectionSpacing * 2),
        const Text('HELP DESK', style: ProjectStyle.sectionHeaderText),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(ProjectStyle.internalPadding),
          decoration: BoxDecoration(
            color: ProjectStyle.surfaceColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage('assets/profile.jpeg'),
              ),
              const SizedBox(width: ProjectStyle.gapMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Rohit', style: ProjectStyle.titleText),
                    const SizedBox(height: 4),
                    Text(
                      'CRM Executive',
                      style: ProjectStyle.smallText.copyWith(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text('+91 91234 56789', style: ProjectStyle.bodyText),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: _contactHelpDesk,
                style: OutlinedButton.styleFrom(
                  foregroundColor: ProjectStyle.primaryTextColor,
                  side: const BorderSide(color: ProjectStyle.primaryTextColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: Text(
                  'Contact',
                  style: ProjectStyle.bodyText.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionsSection(double screenWidth, double screenHeight) {
    // Ensure ProjectController is found (assuming it's alive from previous screen)
    final ProjectController projectController = Get.find<ProjectController>();

    return QuickActionsSection(actions: projectController.quickActions);
  }

  void _attachReference() async {
    // Implement file attachment logic
  }

  void _submitModification() {
    if (_controller.descriptionController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter description',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
      return;
    }
    // Implement submission logic
    Get.dialog(
      AlertDialog(
        backgroundColor: ProjectStyle.surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Success', style: ProjectStyle.titleText),
        content: const Text(
          'Modification request submitted',
          style: ProjectStyle.bodyText,
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text(
              'OK',
              style: TextStyle(
                color: ProjectStyle.primaryTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _contactHelpDesk() async {
    final url = 'tel:+919123456789';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
