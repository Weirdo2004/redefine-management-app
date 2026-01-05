import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReferScreen extends StatelessWidget {
  final ReferFriendController controller = Get.put(ReferFriendController());

  ReferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Refer a friend',
          style: TextStyle(
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInviteFriendsSection(context),
            SizedBox(height: screenHeight * 0.04),
            _buildReferFriendsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInviteFriendsSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'INVITE FRIENDS',
          style: TextStyle(
            fontSize: screenWidth * 0.035,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: screenWidth * 0.03),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: TextField(
            controller: controller.searchController,
            onChanged: (value) => controller.filterFriends(value),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenWidth * 0.03,
              ),
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              hintText: 'Search for friends',
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReferFriendsSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'REFER US TO YOUR FRIENDS',
          style: TextStyle(
            fontSize: screenWidth * 0.035,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: screenWidth * 0.03),
        Obx(
          () => ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: controller.filteredFriends.length,
            itemBuilder: (context, index) {
              final friend = controller.filteredFriends[index];
              return _FriendListItem(friend: friend, controller: controller);
            },
          ),
        ),
      ],
    );
  }
}

class _FriendListItem extends StatelessWidget {
  final Friend friend;
  final ReferFriendController controller;

  const _FriendListItem({required this.friend, required this.controller});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(screenWidth * 0.03),
      // margin: EdgeInsets.only(bottom: screenWidth * 0.04),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        // border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          ClipOval(
            child: Image.asset(
              'assets/profile.jpeg',
              width: screenWidth * 0.14,
              height: screenWidth * 0.14,
              fit: BoxFit.cover,
            ),
          ),

          SizedBox(width: screenWidth * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  friend.name,
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: screenWidth * 0.01),
                Text(
                  friend.phone,
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => controller.sendInvite(friend),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenWidth * 0.02,
              ),
            ),
            child: Text(
              'Invite',
              style: TextStyle(
                color: Colors.black,
                fontSize: screenWidth * 0.035,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Friend {
  final String name;
  final String phone;
  final String? imageUrl;

  Friend({required this.name, required this.phone, this.imageUrl});
}

class ReferFriendController extends GetxController {
  final searchController = TextEditingController();
  final friends =
      <Friend>[
        Friend(name: 'Steffy', phone: '+91 91234 56789'),
        Friend(name: 'Angel', phone: '+91 92345 67890'),
        Friend(name: 'Mark', phone: '+91 93456 78901'),
        Friend(name: 'John', phone: '+91 94567 89012'),
        Friend(name: 'Sophia', phone: '+91 95678 90123'),
        Friend(name: 'David', phone: '+91 96789 01234'),
        Friend(name: 'Olivia', phone: '+91 97890 12345'),
        Friend(name: 'Liam', phone: '+91 98901 23456'),
        Friend(name: 'Emma', phone: '+91 99012 34567'),
        Friend(name: 'Noah', phone: '+91 90123 45678'),
        Friend(name: 'Ava', phone: '+91 91234 56789'),
        Friend(name: 'James', phone: '+91 92345 67890'),
        Friend(name: 'Isabella', phone: '+91 93456 78901'),
        Friend(name: 'William', phone: '+91 94567 89012'),
        Friend(name: 'Mia', phone: '+91 95678 90123'),
        Friend(name: 'Lucas', phone: '+91 96789 01234'),
        Friend(name: 'Charlotte', phone: '+91 97890 12345'),
        Friend(name: 'Henry', phone: '+91 98901 23456'),
        Friend(name: 'Amelia', phone: '+91 99012 34567'),
      ].obs;

  final filteredFriends = <Friend>[].obs;

  @override
  void onInit() {
    filteredFriends.assignAll(friends);
    super.onInit();
  }

  void filterFriends(String query) {
    if (query.isEmpty) {
      filteredFriends.assignAll(friends);
    } else {
      filteredFriends.assignAll(
        friends.where(
          (friend) =>
              friend.name.toLowerCase().contains(query.toLowerCase()) ||
              friend.phone.contains(query),
        ),
      );
    }
  }

  void sendInvite(Friend friend) {
    Get.snackbar(
      'Invitation Sent',
      'Invitation sent to ${friend.name}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
