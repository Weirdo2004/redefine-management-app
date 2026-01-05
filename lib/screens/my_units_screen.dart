import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../utils/project_style.dart';
import '../widgets/unit_item.dart';

class MyUnitsScreen extends StatelessWidget {
  const MyUnitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const String unitPath = '/spark_units/NQ1GGynwiDg58BD1kKPv';

    // Access HomeController to switch tabs
    final HomeController homeController = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_outlined,
            color: ProjectStyle.iconColor,
          ),
          onPressed: () {
            // Navigate back to Home tab (index 0)
            homeController.changeTabIndex(0);
          },
        ),
        title: Text(
          "My Units",
          style: TextStyle(
            fontFamily: 'Host Grotesk',
            fontSize: 20, // Adjusted to look better in AppBar
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance.doc(unitPath).snapshots(),
                  builder: (context, unitSnapshot) {
                    if (unitSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: Lottie.asset(
                          'assets/Loading Dots Blue.json',
                          height: 200,
                          width: 200,
                        ),
                      );
                    }

                    if (!unitSnapshot.hasData || !unitSnapshot.data!.exists) {
                      return Center(
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text("Unit not found."),
                        ),
                      );
                    }

                    final unitDoc = unitSnapshot.data!;
                    final data = unitDoc.data() as Map<String, dynamic>?;

                    if (data == null) return SizedBox();

                    String? projectId = data['project_id'];

                    return FutureBuilder<DocumentSnapshot?>(
                      future:
                          projectId != null
                              ? FirebaseFirestore.instance
                                  .collection('spark_projects')
                                  .doc(projectId)
                                  .get()
                              : Future.value(null),
                      builder: (context, projectSnapshot) {
                        String projectName = 'Unknown Project';

                        if (projectSnapshot.hasData &&
                            projectSnapshot.data != null &&
                            projectSnapshot.data!.exists) {
                          projectName =
                              projectSnapshot.data!.get('projectName') ??
                              'Unknown Project';
                        }

                        return UnitItem(
                          unit: unitDoc,
                          projectName: projectName,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
