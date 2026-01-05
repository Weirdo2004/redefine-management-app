// import 'package:customerapp/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/project_style.dart';
import '../utils/responsive.dart';
import '../services/auth_service.dart';
import '../controllers/home_controller.dart';

class ProfileController extends GetxController {
  final socialMediaLinks =
      [
        SocialMedia(
          icon: Icons.call_outlined,
          url: 'https://wa.me/919123456780',
        ),
        SocialMedia(
          icon: Icons.camera_alt_outlined,
          url: 'https://instagram.com',
        ),
        SocialMedia(icon: Icons.book_outlined, url: 'https://facebook.com'),
        SocialMedia(
          icon: Icons.one_x_mobiledata_outlined,
          url: 'https://twitter.com',
        ),
      ].obs;
}

class ProfileScreen extends StatelessWidget {
  final ProfileController _controller = Get.put(ProfileController());
  final String address = "#1, HSR Sector 1, Bangalore, Karnataka-560049";

  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: ProjectStyle.backgroundColor,
      appBar: _buildAppBar(screenWidth, screenHeight),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: screenHeight * 0.35,
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.transparent,
                      Colors.grey.shade400,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Main content
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: ProjectStyle.pagePadding,
                vertical: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileSection(screenWidth, screenHeight),
                  SizedBox(height: 20),
                  Center(
                    child: Container(
                      width: double.infinity,
                      height: 1,
                      decoration: BoxDecoration(color: Colors.grey.shade300),
                    ),
                  ),
                  _buildSectionTitle('ACCOUNT', screenHeight),
                  _buildAccountOptions(screenWidth, screenHeight),
                ],
              ),
            ),

            _buildFooterSection(screenWidth),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(double screenWidth, double screenHeight) {
    return AppBar(
      backgroundColor: ProjectStyle.appbarbackgroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_outlined, color: ProjectStyle.iconColor),
        onPressed: () {
          Get.find<HomeController>().changeTabIndex(0);
        },
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Profile',
            style: ProjectStyle.headlineText.copyWith(fontSize: 24),
          ),
          // Text(
          //   'Test Project - 131',
          //   style: TextStyle(
          //     fontFamily: ProjectStyle.fontFamily,
          //     color: Color(0xff606062),
          //     fontSize: 16,
          //     fontWeight: FontWeight.w400,
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildProfileSection(double screenWidth, double screenHeight) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundImage: AssetImage('assets/profile.jpeg'),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'VISHAL KUMAR',
                      style: TextStyle(
                        fontFamily: ProjectStyle.fontFamily,
                        color: ProjectStyle.primaryTextColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Joined on 29, Nov 2050',
                      style: TextStyle(
                        fontFamily: ProjectStyle.fontFamily,
                        fontSize: 14,
                        color: Color(0xff656567),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(Icons.edit_outlined, size: 20),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, double screenHeight) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 4),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: ProjectStyle.fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xff656567),
        ),
      ),
    );
  }

  Widget _buildAccountOptions(double screenWidth, double screenHeight) {
    final options = [
      {'title': 'Notification', 'desc': 'Stay Informed your way'},
      {'title': 'Change Password', 'desc': 'Update your account password'},
      {'title': 'Refer', 'desc': 'Invite friends and earn rewards'},
      {'title': 'Report', 'desc': 'Submit issues or feedback'},
      {'title': 'Logout', 'desc': 'Sign out from your account'},
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: options.length,
      itemBuilder:
          (context, index) => Card(
            color: Colors.white,
            elevation:
                0, // Flat design as per request style (CostSheet etc seems flat)
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.black, width: 0.5),
            ),
            child: ListTile(
              title: Text(
                options[index]['title']!,
                style: TextStyle(
                  fontFamily: ProjectStyle.fontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff191B1C),
                ),
              ),
              subtitle: Text(
                options[index]['desc']!,
                style: TextStyle(
                  fontFamily: ProjectStyle.fontFamily,
                  fontSize: 12,
                  color: Color(0xff9FA0A1),
                  fontWeight: FontWeight.w400,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Color(0xff191B1C),
              ),
              onTap: () => _handleAccountOption(options[index]['title']!),
            ),
          ),
    );
  }

  Widget _buildFooterSection(double screenWidth) {
    double fontSize = Responsive.getFontSize(screenWidth, 16);
    double iconSize = screenWidth * 0.075;
    double titleSize = Responsive.getFontSize(screenWidth, 20);
    double shubaFontSize = Responsive.getFontSize(screenWidth, 28);

    return Container(
      color: Color(0xff191B1C),
      padding: EdgeInsets.symmetric(
        vertical: screenWidth * 0.05,
        horizontal: screenWidth * 0.08,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "Shuba" Logo
          Center(
            child: Image.asset(
              'assets/logo1.png',
              width: shubaFontSize * 6,
              fit: BoxFit.contain,
            ),
          ),

          SizedBox(height: screenWidth * 0.03),
          Text(
            "address",
            style: TextStyle(
              fontFamily: ProjectStyle.fontFamily,
              color: Colors.white,
              fontSize: titleSize,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6),

          // Address
          Text(
            "#1,HSR Sector 1, Bangalore, Karnataka-560049",
            style: TextStyle(
              fontFamily: ProjectStyle.fontFamily,
              color: Color(0xff737576),
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: screenWidth * 0.03),

          // "View in Map" Button
          GestureDetector(
            onTap: () => _openMap(address),
            child: Text(
              "View in Map",
              style: TextStyle(
                fontFamily: ProjectStyle.fontFamily,
                color: Color(0xff737576),
                fontSize: fontSize,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.underline,
              ),
            ),
          ),

          SizedBox(height: screenWidth * 0.06),

          // Contact Info
          Text(
            "Contact Us",
            style: TextStyle(
              fontFamily: ProjectStyle.fontFamily,
              color: Colors.white,
              fontSize: titleSize,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: screenWidth * 0.015),

          Text(
            "+91 1234567890 || www.shubaexample.com",
            style: TextStyle(
              fontFamily: ProjectStyle.fontFamily,
              color: Color(0xff737576),
              fontSize: fontSize,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: screenWidth * 0.07),

          Text(
            "our website",
            style: TextStyle(
              fontFamily: ProjectStyle.fontFamily,
              color: Colors.white,
              fontSize: titleSize,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: screenWidth * 0.07),

          // Report
          Text(
            "Report",
            style: TextStyle(
              fontFamily: ProjectStyle.fontFamily,
              color: Colors.white,
              fontSize: titleSize,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: screenWidth * 0.07),

          Center(
            child: Text(
              "connect with us",
              style: TextStyle(
                fontFamily: ProjectStyle.fontFamily,
                color: Color(0xff737576),
                fontSize: titleSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          SizedBox(height: screenWidth * 0.05),

          // Social Media Icons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialIcon('assets/whatsapp.png', iconSize, () {
                _launchURL('https://wa.me/919123456780');
              }),
              _buildSocialIcon('assets/insta.png', iconSize, () {
                _launchURL('https://instagram.com');
              }),
              _buildSocialIcon('assets/x.png', iconSize, () {
                _launchURL('https://twitter.com');
              }),
              _buildSocialIcon('assets/fb.png', iconSize, () {
                _launchURL('https://facebook.com');
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(String assetPath, double size, VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: onTap,
        child: Image.asset(
          assetPath,
          width: size,
          height: size,
          fit: BoxFit.contain,
          color: Colors.white,
        ),
      ),
    );
  }

  void _handleAccountOption(String option) {
    switch (option) {
      case 'Change Password':
        Get.toNamed('/change-password');
        break;
      case 'Logout':
        _confirmLogout();
        break;
      case 'Notification':
        Get.toNamed('/notification');
        break;
      // Add other cases
    }
  }

  void _confirmLogout() {
    Get.defaultDialog(
      title: 'Logout',
      titleStyle: TextStyle(
        fontFamily: ProjectStyle.fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      middleText: 'Are you sure you want to logout?',
      middleTextStyle: TextStyle(
        fontFamily: ProjectStyle.fontFamily,
        fontSize: 14,
      ),
      confirm: TextButton(
        onPressed: () async {
          await Get.find<AuthService>().signOut();
          Get.offAllNamed('/login');
        },
        child: Text(
          'Yes',
          style: TextStyle(
            fontFamily: ProjectStyle.fontFamily,
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: Text(
          'No',
          style: TextStyle(
            fontFamily: ProjectStyle.fontFamily,
            color: Colors.black,
          ),
        ),
      ),
      radius: 0,
    );
  }

  Future<void> _openMap(String address) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$address';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}

class SocialMedia {
  final IconData icon;
  final String url;

  SocialMedia({required this.icon, required this.url});
}
