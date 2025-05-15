import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customerapp/screens/projects_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/home_controller.dart';
import '../widgets/need_attention_item.dart';
import '../widgets/summary_item.dart';
import '../widgets/unit_item.dart';
import '../widgets/project_card.dart';
import '../utils/responsive.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController _controller = Get.put(HomeController());
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeContent(),
    ProjectsScreen(),

    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Shows selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black, // Active tab color
        unselectedItemColor: Colors.grey, // Inactive tab color
        selectedLabelStyle: GoogleFonts.outfit(color: Color(0xff646768)),
        unselectedLabelStyle: GoogleFonts.outfit(color: Color(0xff646768)),
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/home.png', // Replace with your custom icon path
              width: 24,
              height: 24,
              color:
                  _selectedIndex == 0
                      ? Colors.black
                      : Colors.grey, // Dynamic color change
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.apartment_sharp,
              color: _selectedIndex == 1 ? Colors.black : Colors.grey,
            ),
            // icon: Image.asset(
            //   'assets/icons/units.png', // Replace with your custom icon path
            //   width: 24,
            //   height: 24,
            // ),
            label: "Projects",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_rounded,
              color: _selectedIndex == 2 ? Colors.black : Colors.grey,
            ),
            // icon: Image.asset(
            //   'assets/icons/profile.png', // Replace with your custom icon path
            //   width: 24,
            //   height: 24,
            //   color: _selectedIndex == 2 ? Colors.black : Colors.grey,
            // ),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

// Separate Widget for Home Page Content
class HomeContent extends StatelessWidget {
  final HomeController _controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: EdgeInsets.all(screenWidth * 0.02), // Dynamic padding
          child: ClipOval(
            child: Image.asset(
              'assets/home_profile.png', // Replace with your actual image path
              width: screenWidth * 0.1, // Dynamic width
              height:
                  screenWidth *
                  0.1, // Ensuring a square aspect ratio for a perfect circle
              fit:
                  BoxFit
                      .cover, // Ensures the image fully covers the circular shape
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Morning...!',
              style: GoogleFonts.outfit(
                color: Colors.black,
                fontSize: Responsive.getFontSize(screenWidth, 20),
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              'Nithesh',
              style: GoogleFonts.outfit(
                color: Colors.black,
                fontSize: Responsive.getFontSize(screenWidth, 28),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),

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

            Container(
              color: Colors.grey[100],
              child: SingleChildScrollView(
                padding: EdgeInsets.all(
                  Responsive.getPadding(screenWidth).horizontal * 0.35,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummarySection(screenWidth),
                    SizedBox(height: screenHeight * 0.03),
                    _buildNeedsAttentionSection(screenWidth, screenHeight),
                    _buildMyUnitsSection(screenWidth, screenHeight),
                    SizedBox(height: screenHeight * 0.03),
                    _buildUpcomingProjectsSection(screenWidth, screenHeight),
                  ],
                ),
              ),
            ),

            // ✅ Footer now outside the padding
            _buildFooterSection(screenWidth),
          ],
        ),
      ),
    );
  }

  Widget _buildSummarySection(double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 6.0),
          child: Text(
            'SUMMARY ACROSS UNIT',
            style: GoogleFonts.outfit(
              fontSize: Responsive.getFontSize(screenWidth, 14),
              fontWeight: FontWeight.w500,
              color: Color(0xff656567),
            ),
          ),
        ),
        SizedBox(height: screenWidth * 0.05),
        Row(
          children:
              _controller.summaryData
                  .map(
                    (item) => Expanded(
                      child: SummaryItem(
                        value: item['value']!,
                        label: item['label']!,
                        screenWidth: screenWidth,
                      ),
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }

  Widget _buildNeedsAttentionSection(double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 6.0),
          child: Text(
            'NEEDS ATTENTION',
            style: GoogleFonts.outfit(
              fontSize: Responsive.getFontSize(screenWidth, 14),
              color: Color(0xff656567),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _controller.attentionItems.length,
          itemBuilder:
              (context, index) => NeedsAttentionItem(
                unit: _controller.attentionItems[index],
                index: index,
              ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
                //Get.toNamed('/needs-attention'),
            child: Text(
              'View all',
              style: GoogleFonts.outfit(
                color: Color(0xff585A5C),
                fontSize: Responsive.getFontSize(screenWidth, 13),
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildMyUnitsSection(double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 6.0),
          child: Text(
            'MY UNITS',
            style: GoogleFonts.outfit(
              fontSize: Responsive.getFontSize(screenWidth, 14),
              fontWeight: FontWeight.w500,
              color: Color(0xff656567),
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('spark_customers')
              .where('id', isEqualTo: 'DVJOJBnpv8bCDI4b0AWjpRL21gI3')
              .snapshots(),
          builder: (context, customerSnapshot) {
            if (customerSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!customerSnapshot.hasData || customerSnapshot.data!.docs.isEmpty) {
              return Center(child: Text("No customer data found"));
            }

// Get customer document

            final customerDoc = customerSnapshot.data!.docs.first;

            final List<String> unitIds = List<String>.from(customerDoc['my_assets']);
            final List<String> projectIds=List<String>.from(customerDoc['projects']);

            if (unitIds.isEmpty) {
              return Center(child: Text("No units found in assets"));
            }

            return FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchUnitsWithProjects(unitIds, projectIds),
              builder: (context, unitSnapshot) {
                if (unitSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!unitSnapshot.hasData || unitSnapshot.data!.isEmpty) {
                  return Center(child: Text("No matching units found"));
                }

                final unitsWithProjects = unitSnapshot.data!;

                return Column(
                  children: unitsWithProjects.map((entry) {
                    DocumentSnapshot unitDoc = entry['unit'];
                    String projectName = entry['projectName'];

                    return UnitItem(
                      unit: unitDoc,
                      projectName: projectName,
                    );
                  }).toList(),
                );
              },
            );

          },
        ),





/* ListView.builder(
shrinkWrap: true,
physics: NeverScrollableScrollPhysics(),
itemCount: _controller.myUnits.length,
itemBuilder:
(context, index) => UnitItem(unit: _controller.myUnits[index]),
),*/
// Align(
// alignment: Alignment.centerRight,
// child: TextButton(
// onPressed: () => Get.toNamed('/my-units'),
// child: Text(
// 'View all',
// style: GoogleFonts.outfit(
// color: Color(0xff585A5C),
// fontSize: Responsive.getFontSize(screenWidth, 13),
// fontWeight: FontWeight.w600,
// decoration: TextDecoration.underline,
// ),
// ),
// ),
// ),
      ],
    );
  }

  Widget _buildUpcomingProjectsSection(
    double screenWidth,
    double screenHeight,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 6.0, top: 16),
          child: Text(
            'UPCOMING PROJECTS',
            style: GoogleFonts.outfit(
              fontSize: Responsive.getFontSize(screenWidth, 13),
              fontWeight: FontWeight.w500,
              color: Color(0xff656567),
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.02),

        // 🔥 Ensuring proper height for scrolling
        SizedBox(
          height:
              screenHeight *
              0.45, // Adjust height dynamically to prevent overflow
          child: PageView.builder(
            controller: PageController(
              initialPage: 0,
              viewportFraction: 0.48, // Ensures 2 items fit properly
            ),
            itemCount: _controller.projects.length,
            physics: BouncingScrollPhysics(), // Smooth scrolling
            padEnds: false, // 🔥 THIS REMOVES SPACE AT THE START/END 🔥
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.01,
                ), // Adjust spacing between items
                child: ProjectCard(project: _controller.projects[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFooterSection(double screenWidth) {
    double fontSize = Responsive.getFontSize(screenWidth, 16);
    double iconSize = screenWidth * 0.075; // Icons scale with screen width
    double titleSize = Responsive.getFontSize(screenWidth, 20);
    double shubaFontSize = Responsive.getFontSize(screenWidth, 28);
    double shubaHFontSize = Responsive.getFontSize(screenWidth, 36);

    return Container(
      color: Color(0xff191B1C),
      padding: EdgeInsets.symmetric(
        vertical: screenWidth * 0.05, // Dynamic vertical padding
        horizontal: screenWidth * 0.08, // Adjusted for different screens
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "Shuba" with Artistic Styled "H"
          Center(
            child: Image.asset(
              'assets/shubha.png', // Replace with your actual image path
              width:
                  shubaFontSize *
                  6, // Adjust size dynamically based on font size
              fit: BoxFit.contain, // Ensures the image scales properly
            ),
          ),

          SizedBox(height: screenWidth * 0.03),
          Text(
            "address",
            style: GoogleFonts.outfit(
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
            style: GoogleFonts.outfit(
              color: Color(0xff737576),
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: screenWidth * 0.03),

          // "View in Map" Button
          GestureDetector(
            onTap: () {
              // Handle map opening
            },
            child: Text(
              "View in Map",
              style: GoogleFonts.outfit(
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
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: titleSize,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: screenWidth * 0.015),

          Text(
            "+91 1234567890 || www.shubaexample.com",
            style: GoogleFonts.outfit(
              color: Color(0xff737576),
              fontSize: fontSize,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: screenWidth * 0.07),

          Text(
            "our website",
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: titleSize,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: screenWidth * 0.07),

          // Report
          Text(
            "Report",
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: titleSize,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: screenWidth * 0.07),

          Center(
            child: Text(
              "connect with us",
              style: GoogleFonts.outfit(
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
                // Handle WhatsApp click
              }),

              _buildSocialIcon('assets/insta.png', iconSize, () {
                // Handle Instagram click
              }),
              _buildSocialIcon('assets/x.png', iconSize, () {
                // Handle X (Twitter) click
              }),
              _buildSocialIcon('assets/fb.png', iconSize, () {
                // Handle Facebook click
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(String assetPath, double size, VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16), // Even spacing
      child: GestureDetector(
        onTap: onTap,
        child: Image.asset(
          assetPath,
          width: size,
          height: size,
          fit: BoxFit.contain, // Ensures proper scaling
          color: Colors.white,
        ),
      ),
    );
  }
}
Future<List<Map<String, dynamic>>> _fetchUnitsWithProjects(
    List<String> unitIds,
    List<String> projectIds,
    ) async {
  final firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> result = [];

  for (int i = 0; i < unitIds.length; i++) {
    String unitId = unitIds[i];
    String projectId = projectIds.length > i ? projectIds[i] : '';

    DocumentSnapshot unitDoc =
    await firestore.collection('spark_units').doc(unitId).get();

    DocumentSnapshot? projectDoc;
    if (projectId.isNotEmpty) {
      projectDoc =
      await firestore.collection('spark_projects').doc(projectId).get();
    }

    if (unitDoc.exists) {
      result.add({
        'unit': unitDoc,
        'projectName': projectDoc != null && projectDoc.exists
            ? projectDoc['projectName'] ?? 'Unnamed Project'
            : 'Unknown Project',
      });
    }
  }

  return result;
}
