import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/about_controller.dart';

class AboutScreen extends StatelessWidget {
  final AboutController _controller = Get.put(AboutController());

  AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: _buildAppBar(screenWidth, screenHeight),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Form(
          key: _controller.formKey,
          child: Column(
            children: [
              _buildProfileSection(screenWidth, screenHeight),
              _buildFormSection(screenWidth, screenHeight),
              SizedBox(height: screenHeight * 0.03),
              _buildSaveButton(screenWidth, screenHeight),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(screenWidth, screenHeight),
    );
  }

  PreferredSizeWidget _buildAppBar(double screenWidth, double screenHeight) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_outlined, size: screenHeight * 0.025),
        onPressed: () => Get.back(),
      ),
      title: Column(
        children: [
          Text(
            'My Profile',
            style: TextStyle(
              fontSize: screenHeight * 0.022,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection(double screenWidth, double screenHeight) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Rounded corners
      ),
      child: Padding(
        padding: EdgeInsets.all(screenHeight * 0.02),
        child: Row(
          children: [
            CircleAvatar(
              radius: screenHeight * 0.06,
              backgroundImage: AssetImage('assets/profile.jpeg'),
            ),
            SizedBox(width: screenWidth * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'VISHAL KUMAR',
                    style: TextStyle(
                      fontSize: screenHeight * 0.02,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Joined on 29, Nov 2050',
                    style: TextStyle(
                      fontSize: screenHeight * 0.016,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit_outlined, size: screenHeight * 0.025),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormSection(double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFormField('First Name', _controller.firstNameController),
        _buildFormField('Last Name', _controller.lastNameController),
        _buildEmailField(screenHeight),
        _buildFormField('Phone No', _controller.phoneController),
      ],
    );
  }

  Widget _buildFormField(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8), // Sharp corners
          ),
          filled: true,
          fillColor: Colors.white, // White background for fields
        ),
        validator: (value) => value!.isEmpty ? '$label is required' : null,
      ),
    );
  }

  Widget _buildEmailField(double screenHeight) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _controller.emailController,
        decoration: InputDecoration(
          labelText: 'Email',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8), // Sharp corners
          ),
          filled: true,
          fillColor: Colors.white, // White background for fields
        ),
        keyboardType: TextInputType.emailAddress,
        validator: _controller.validateEmail,
      ),
    );
  }

  Widget _buildSaveButton(double screenWidth, double screenHeight) {
    return SizedBox(
      width: screenWidth * 0.9,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFD8BFD8), // Light Lavender
          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Sharp corners
          ),
        ),
        onPressed: _controller.saveProfile,
        child: Text(
          'Save Changes',
          style: TextStyle(
            fontSize: screenHeight * 0.02,
            fontWeight: FontWeight.bold, // Bold text
            color: Colors.black, // Black text
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(double screenWidth, double screenHeight) {
    return Obx(
      () => BottomNavigationBar(
        currentIndex: _controller.currentNavIndex.value,
        onTap: _controller.changeNavIndex,
        selectedItemColor: Colors.black, // Black icons
        unselectedItemColor: Colors.black, // Black text
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: screenHeight * 0.03),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apartment_outlined, size: screenHeight * 0.03),
            label: 'Units',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined, size: screenHeight * 0.03),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
