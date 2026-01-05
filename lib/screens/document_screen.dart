import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../controllers/document_controller.dart';
import '../models/document_model.dart';

class DocumentsScreen extends StatelessWidget {
  final DocumentsController controller = Get.put(DocumentsController());

  DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Column(
          children: [
            Text(
              'Documents',
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Test Project - 131',
              style: TextStyle(
                fontSize: screenWidth * 0.03,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUploadSection(context),
            SizedBox(height: screenHeight * 0.04),
            _buildRecentUploadsSection(context),
            SizedBox(height: screenHeight * 0.04),
            _buildDocumentsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.06,
        vertical: screenWidth * 0.05,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left Section: Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upload your Documents Effortlessly',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenWidth * 0.03),
                Text(
                  'Secure, fast, and hassle-free document uploads to keep everything organized and accessible anytime.',
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: screenWidth * 0.05),

          // Right Section: Upload Button
          SizedBox(
            width: screenWidth * 0.3,
            height: screenWidth * 0.12,
            child: ElevatedButton(
              onPressed: controller.uploadDocument,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFDBD3FD),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Upload',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: screenWidth * 0.035,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentUploadsSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'RECENT UPLOADS',
          style: TextStyle(
            fontSize: screenWidth * 0.035,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: screenWidth * 0.03),
        SizedBox(
          height: screenWidth * 0.5,
          child: Obx(() {
            if (controller.recentUploads.isEmpty) {
              return Center(child: Text('No recent uploads'));
            }
            return ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: controller.recentUploads.length,
              separatorBuilder: (_, __) => SizedBox(width: screenWidth * 0.04),
              itemBuilder: (context, index) {
                final upload = controller.recentUploads[index];
                return _buildRecentUploadItem(upload, screenWidth);
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildRecentUploadItem(DocumentModel upload, double screenWidth) {
    final itemWidth = screenWidth * 0.35;
    return Container(
      width: itemWidth,
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              "assets/land_agreement.png",
              width: itemWidth,
              height: itemWidth * 0.6,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    height: itemWidth * 0.6,
                    child: Icon(Icons.error_outline, color: Colors.grey),
                  ),
            ),
          ),
          SizedBox(height: screenWidth * 0.02),
          Text(
            upload.name,
            style: TextStyle(
              fontSize: screenWidth * 0.038,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: screenWidth * 0.01),
          Text(
            '${upload.date} • ${upload.fileSize}',
            style: TextStyle(
              fontSize: screenWidth * 0.03,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'DOCUMENTS',
              style: TextStyle(
                fontSize: screenWidth * 0.035,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            Obx(
              () => DropdownButton<String>(
                value: controller.sortValue.value,
                items:
                    ['Latest', 'Oldest'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                onChanged: (value) => controller.sortDocuments(value!),
              ),
            ),
          ],
        ),
        SizedBox(height: screenWidth * 0.03),
        Obx(() {
          if (controller.documents.isEmpty) {
            return Center(child: Text('No documents available'));
          }
          return ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: controller.documents.length,
            separatorBuilder: (_, __) => SizedBox(height: screenWidth * 0.04),
            itemBuilder: (context, index) {
              final document = controller.documents[index];
              return _buildDocumentItem(document);
            },
          );
        }),
      ],
    );
  }

  Widget _buildDocumentItem(DocumentModel document) {
    return Builder(
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Row(
            children: [
              SvgPicture.asset(
                "assets/document_icon.svg",
                width: screenWidth * 0.08,
                height: screenWidth * 0.08,
                placeholderBuilder: (_) => Icon(Icons.insert_drive_file),
              ),
              SizedBox(width: screenWidth * 0.04),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      document.name,
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.01),
                    Text(
                      '${document.date} • ${document.fileSize}',
                      style: TextStyle(
                        fontSize: screenWidth * 0.035,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.more_vert, size: screenWidth * 0.06),
                onPressed: () => controller.showDocumentOptions(document),
              ),
            ],
          ),
        );
      },
    );
  }
}
