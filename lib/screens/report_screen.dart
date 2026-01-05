import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportScreen extends StatelessWidget {
  final ReportController controller = Get.put(ReportController());

  ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Report',
          style: TextStyle(
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Column(
                children: [
                  _buildBotMessage(context),
                  SizedBox(height: screenHeight * 0.03),
                  _buildCategoryButtons(context),
                  SizedBox(height: screenHeight * 0.03),
                  _buildUserMessage(context),
                  Obx(
                    () => ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: controller.messages.length,
                      itemBuilder:
                          (context, index) => _buildMessageBubble(
                            context,
                            controller.messages[index],
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildInputField(context),
        ],
      ),
    );
  }

  Widget _buildBotMessage(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipOval(
          child: Container(
            width: screenWidth * 0.10,
            height: screenWidth * 0.10,
            color: Colors.blue[100],
            child: Icon(
              Icons.android,
              size: screenWidth * 0.06,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(width: screenWidth * 0.03),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(screenWidth * 0.04),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Hello! I see you\'d like to report an issue. How can we help you today?',
              style: TextStyle(
                fontSize: screenWidth * 0.038,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryButtons(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            controller.categories.map((category) {
              return Padding(
                padding: EdgeInsets.only(right: screenWidth * 0.03),
                child: ElevatedButton(
                  onPressed: () => controller.selectCategory(category),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                      vertical: screenWidth * 0.02,
                    ),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: screenWidth * 0.035,
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildUserMessage(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(screenWidth * 0.04),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Transactions are not being updated',
              style: TextStyle(
                fontSize: screenWidth * 0.038,
                color: Colors.black87,
              ),
            ),
          ),
        ),
        SizedBox(width: screenWidth * 0.03),
        ClipOval(
          child: Image.asset(
            'assets/profile.jpeg',
            width: screenWidth * 0.10,
            height: screenWidth * 0.10,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }

  Widget _buildMessageBubble(BuildContext context, Message message) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isBot = message.isBot;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
      child: Row(
        mainAxisAlignment:
            isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isBot) ...[
            ClipOval(
              child: Container(
                width: screenWidth * 0.10,
                height: screenWidth * 0.10,
                color: Colors.blue[100],
                child: Icon(
                  Icons.android,
                  size: screenWidth * 0.06,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(width: screenWidth * 0.03),
          ],
          Expanded(
            child: Container(
              padding: EdgeInsets.all(screenWidth * 0.04),
              decoration: BoxDecoration(
                color: isBot ? Colors.grey[200] : Colors.blue[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  fontSize: screenWidth * 0.038,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          if (!isBot) ...[
            SizedBox(width: screenWidth * 0.03),
            ClipOval(
              child: Image.asset(
                'assets/profile.jpeg',
                width: screenWidth * 0.10,
                height: screenWidth * 0.10,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputField(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.attach_file, size: screenWidth * 0.06),
            onPressed: controller.attachFile,
          ),
          Expanded(
            child: TextField(
              controller: controller.messageController,
              decoration: InputDecoration(
                hintText: 'Express your problem...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: screenWidth * 0.03,
                ),
              ),
              onSubmitted: (value) => controller.sendMessage(),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send_outlined, size: screenWidth * 0.06),
            onPressed: controller.sendMessage,
          ),
        ],
      ),
    );
  }
}

class Message {
  final String text;
  final bool isBot;
  final DateTime timestamp;

  Message({required this.text, required this.isBot, required this.timestamp});
}

class ReportController extends GetxController {
  final messageController = TextEditingController();
  final messages = <Message>[].obs;
  final categories =
      [
        'Cost Sheet',
        'Transactions',
        'Activity Log',
        'Payments',
        'Profile',
        'Other',
      ].obs;

  void selectCategory(String category) {
    messageController.text = 'Issue with $category: ';
  }

  void sendMessage() {
    if (messageController.text.trim().isEmpty) return;
    messages.add(
      Message(
        text: messageController.text,
        isBot: false,
        timestamp: DateTime.now(),
      ),
    );
    messageController.clear();
    Future.delayed(Duration(seconds: 1), () {
      messages.add(
        Message(
          text: 'Thank you for your report. We will look into this issue.',
          isBot: true,
          timestamp: DateTime.now(),
        ),
      );
    });
  }

  void attachFile() {
    Get.snackbar(
      'Attachment',
      'File attachment feature coming soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
