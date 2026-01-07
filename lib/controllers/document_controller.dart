import 'package:customerapp/models/document_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:file_picker/file_picker.dart';

class DocumentsController extends GetxController {
  final recentUploads = <DocumentModel>[].obs;
  final documents = <DocumentModel>[].obs;
  final sortValue = 'Latest'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  void _loadInitialData() {
    recentUploads.assignAll([
      DocumentModel(
        id: '1',
        name: 'Land Agreement',
        url: '',
        category: 'Agreement',
        uploadedBy: 'User',
        uploadedOn: DateTime(2025, 12, 12),
        icon: Icons.description_outlined,
      ),
    ]);

    documents.assignAll([
      DocumentModel(
        id: '2',
        name: 'Main Contract',
        url: '',
        category: 'Contract',
        uploadedBy: 'User',
        uploadedOn: DateTime(2025, 12, 15),
        icon: Icons.article_outlined,
      ),
    ]);
  }

  Future<void> uploadDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        // Handle file upload logic
        Get.snackbar(
          'Success',
          'File uploaded successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to upload document: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void sortDocuments(String value) {
    sortValue.value = value;
    documents.sort(
      (a, b) =>
          value == 'Latest'
              ? b.uploadedOn.compareTo(a.uploadedOn)
              : a.uploadedOn.compareTo(b.uploadedOn),
    );
  }

  void showDocumentOptions(DocumentModel document) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.download),
              title: Text('Download'),
              onTap: () {
                Get.back();
                downloadDocument(document);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Delete'),
              onTap: () {
                Get.back();
                deleteDocument(document);
              },
            ),
          ],
        ),
      ),
    );
  }

  void downloadDocument(DocumentModel document) {
    Get.snackbar(
      'Download',
      'Starting download: ${document.name}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void deleteDocument(DocumentModel document) {
    documents.remove(document);
    Get.snackbar(
      'Deleted',
      'Document removed successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
