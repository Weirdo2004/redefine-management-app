import 'package:flutter/material.dart';
import '../models/document_model.dart';

class DocumentItem extends StatelessWidget {
  final DocumentModel document;
  final double screenWidth;

  const DocumentItem({
    super.key,
    required this.document,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ), // Sharp Corners

      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.001),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.025),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Column 1: Icon
            Icon(
              document.icon ?? Icons.description_outlined,
              size: screenWidth * 0.06,
              color: Colors.black,
            ),
            SizedBox(width: screenWidth * 0.06),

            // Column 2: Name, Date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    document.name,
                    style: TextStyle(
                      fontFamily: 'Host Grotesk',
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.005),
                  Text(
                    document.formattedDate,
                    style: TextStyle(
                      fontFamily: 'Host Grotesk',
                      fontSize: screenWidth * 0.03,
                      color: Colors.grey[600],
                    ),
                  ),
                  // Removed fileSize as it's not in the model
                ],
              ),
            ),
            // Column 3: 3-Dot Menu
            PopupMenuButton<String>(
              onSelected: (value) {
                // Handle actions
              },
              itemBuilder:
                  (context) => [
                    PopupMenuItem(value: "Open", child: Text("Open")),
                    PopupMenuItem(value: "Download", child: Text("Download")),
                    PopupMenuItem(value: "Delete", child: Text("Delete")),
                  ],
              child: Icon(Icons.more_vert),
            ),
          ],
        ),
      ),
    );
  }
}
