import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/project_style.dart';
import '../utils/responsive.dart';

class NotificationsScreen extends StatelessWidget {
  final RxBool paymentDueSelected = false.obs;
  final RxBool offersAndDiscountsSelected = false.obs;

  NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final screenWidth = MediaQuery.of(context).size.width;
    // ignore: unused_local_variable
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: ProjectStyle.backgroundColor,
      appBar: _buildAppBar(),
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
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPermissionSection(),
                    SizedBox(height: 20),
                    _buildNotificationOption(
                      title: 'Payment Due',
                      description: 'Never miss a payment',
                      isSelected: paymentDueSelected,
                    ),
                    SizedBox(height: 10),
                    _buildNotificationOption(
                      title: 'Offers and Discounts',
                      description:
                          'Save more with special offers and discounts',
                      isSelected: offersAndDiscountsSelected,
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: ProjectStyle.appbarbackgroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_outlined, color: ProjectStyle.iconColor),
        onPressed: () => Get.back(),
      ),
      title: Text(
        'Notifications',
        style: ProjectStyle.headlineText.copyWith(fontSize: 24),
      ),
    );
  }

  Widget _buildPermissionSection() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ProjectStyle.internalPadding,
        vertical: 10,
      ),
      child: Text(
        'PERMISSION',
        style: TextStyle(
          fontFamily: ProjectStyle.fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xff606062),
        ),
      ),
    );
  }

  Widget _buildNotificationOption({
    required String title,
    required String description,
    required RxBool isSelected,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: ProjectStyle.internalPadding),
      padding: EdgeInsets.all(ProjectStyle.internalPadding),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: ProjectStyle.fontFamily,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: ProjectStyle.primaryTextColor,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  description,
                  style: TextStyle(
                    fontFamily: ProjectStyle.fontFamily,
                    fontSize: 16,
                    color: Color(0xff606062),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () => GestureDetector(
              onTap: () {
                isSelected.toggle();
              },
              child: Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child:
                    isSelected.value
                        ? Icon(Icons.check, size: 18, color: Colors.black)
                        : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
