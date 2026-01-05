import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/project_style.dart';
import '../utils/responsive.dart';
import '../controllers/password_controller.dart';

class PasswordChangeScreen extends StatelessWidget {
  final PasswordController controller = Get.put(PasswordController());

  PasswordChangeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: ProjectStyle.backgroundColor,
      appBar: _buildAppBar(screenWidth, screenHeight),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: ProjectStyle.pagePadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              // Main content
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(ProjectStyle.internalPadding),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfileSection(screenWidth, screenHeight),
                      SizedBox(height: 20),
                      Center(
                        child: Container(
                          width: double.infinity,
                          height: 1,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      _buildPasswordField(
                        context: context,
                        hintText: 'Old Password',
                        controller: controller,
                        textController: controller.oldPasswordController,
                        isHidden: controller.isOldPasswordHidden,
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                      ),
                      SizedBox(height: 20),
                      _buildPasswordField(
                        context: context,
                        hintText: 'New Password',
                        controller: controller,
                        textController: controller.newPasswordController,
                        isHidden: controller.isNewPasswordHidden,
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                      ),
                      SizedBox(height: 20),
                      _buildPasswordField(
                        context: context,
                        hintText: 'Confirm Password',
                        controller: controller,
                        textController: controller.confirmPasswordController,
                        isHidden: controller.isConfirmPasswordHidden,
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                        validator: (value) {
                          if (value != controller.newPasswordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Get.toNamed('/forgot-password'),
                          child: Text(
                            'FORGOT PASSWORD?',
                            style: TextStyle(
                              fontFamily: ProjectStyle.fontFamily,
                              color: ProjectStyle.primaryTextColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      Center(
                        child: ElevatedButton(
                          onPressed: controller.saveChanges,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            minimumSize: Size(double.infinity, 50),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(color: Colors.black, width: 0.5),
                            ),
                          ),
                          child: Text(
                            'Save Changes',
                            style: TextStyle(
                              fontFamily: ProjectStyle.fontFamily,
                              color: ProjectStyle.primaryTextColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
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
        onPressed: () => Get.back(),
      ),
      title: Text(
        'Password',
        style: ProjectStyle.headlineText.copyWith(fontSize: 24),
      ),
    );
  }

  Widget _buildProfileSection(double screenWidth, double screenHeight) {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
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
                  icon: Icon(
                    Icons.edit_outlined,
                    size: 20,
                    color: ProjectStyle.iconColor,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required BuildContext context,
    required String hintText,
    required PasswordController controller,
    required TextEditingController textController,
    required RxBool isHidden,
    required double screenWidth,
    required double screenHeight,
    FormFieldValidator<String>? validator,
  }) {
    return Container(
      color: Colors.white,
      child: Obx(
        () => TextFormField(
          controller: textController,
          obscureText: isHidden.value,
          style: TextStyle(
            fontFamily: ProjectStyle.fontFamily,
            fontSize: 16,
            color: Color(0xff616162),
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontFamily: ProjectStyle.fontFamily,
              fontSize: 16,
              color: Color(0xff616162),
              fontWeight: FontWeight.w400,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.black, width: 0.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.black, width: 0.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.black, width: 0.5),
            ),
            contentPadding: EdgeInsets.all(12),
            suffixIcon: IconButton(
              icon: Icon(
                isHidden.value ? Icons.visibility_off : Icons.visibility,
                color: ProjectStyle.iconColor,
                size: 20,
              ),
              onPressed: () {
                isHidden.toggle();
              },
            ),
          ),
          validator:
              validator ??
              (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
                return null;
              },
        ),
      ),
    );
  }
}
