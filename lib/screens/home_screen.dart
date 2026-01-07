import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:carousel_slider/carousel_slider.dart'; // Added dependency
import 'package:lottie/lottie.dart';
import '../controllers/home_controller.dart';

import '../widgets/stat_tile.dart'; // New widget
import '../widgets/unit_item.dart';
import '../widgets/story_view.dart'; // New widget
import '../utils/responsive.dart';
import 'my_units_screen.dart';
import 'profile_screen.dart';
import 'refer_and_earn_screen.dart';
import 'projects_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController _controller = Get.put(HomeController());

  final List<Widget> _pages = [
    HomeContent(),
    MyUnitsScreen(),
    // ReferAndEarnScreen(),
    ProjectsScreen(),
    ProfileScreen(), // This is now "Account"
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: Color(0xfff5f5f5),
        body: _pages[_controller.selectedIndex.value],
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top hairline divider
            Container(
              height: 0.5, // key difference
              color: Colors.black.withOpacity(0.12),
            ),

            // Actual bottom nav
            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(top: 6),
              child: Theme(
                data: Theme.of(context).copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: BottomNavigationBar(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  currentIndex: _controller.selectedIndex.value,
                  onTap: _controller.changeTabIndex,
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: Colors.black,
                  unselectedItemColor: Colors.grey,
                  selectedLabelStyle: TextStyle(
                    fontFamily: 'Host Grotesk',
                    fontSize: 14,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontFamily: 'Host Grotesk',
                    fontSize: 14,
                  ),
                  items: [
                    BottomNavigationBarItem(
                      icon: Image.asset(
                        'assets/icons/Icon Sets.png',
                        width: 22,
                        color:
                            _controller.selectedIndex.value == 0
                                ? Colors.black
                                : Colors.grey,
                      ),
                      label: "Home",
                    ),
                    BottomNavigationBarItem(
                      icon: Image.asset(
                        'assets/icons/units.png',
                        width: 22,
                        color:
                            _controller.selectedIndex.value == 1
                                ? Colors.black
                                : Colors.grey,
                      ),
                      label: "My Units",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.card_giftcard_outlined),
                      label: "Refer & Earn",
                    ),
                    BottomNavigationBarItem(
                      icon: Image.asset(
                        'assets/icons/Icon Sets 3.png',
                        width: 22,
                        color:
                            _controller.selectedIndex.value == 3
                                ? Colors.black
                                : Colors.grey,
                      ),
                      label: "Account",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final HomeController _controller = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Column(
        children: [
          // 1. Top Carousel Section
          HomeCarousel(), // Replaced _buildCarouselSection usage

          SizedBox(height: 20),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 2. Discover the World / Summary Section
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "DISCOVER THE LUXURY WITH ",
                      style: TextStyle(
                        fontFamily: 'Host Grotesk',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                        letterSpacing: 1.2,
                      ),
                    ),
                    Image.asset(
                      'assets/logo1.png',
                      height: 14, // Match font size
                      fit: BoxFit.contain,
                      color: Colors.grey[600],
                    ),
                  ],
                ),
                SizedBox(height: 3),
                Text(
                  "Summary", // Matching reference text style
                  style: TextStyle(
                    fontFamily: 'Host Grotesk',
                    fontSize: 18,
                    //fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                _buildSummarySection(screenWidth),

                SizedBox(height: 20),

                // 3. My Units Section
                Text(
                  "MADE FOR EFFORTLESS STAYS",
                  style: TextStyle(
                    fontFamily: 'Host Grotesk',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "My Units", // Matching reference header style
                      style: TextStyle(
                        fontFamily: 'Host Grotesk',
                        fontSize: 18,
                        //fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                _buildMyUnitsSection(screenWidth, screenHeight),

                SizedBox(height: 20),

                // 4. Other Properties (Stories)
                Text(
                  "EXPLORE MORE",
                  style: TextStyle(
                    fontFamily: 'Host Grotesk',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  "Our other Properties",
                  style: TextStyle(
                    fontFamily: 'Host Grotesk',
                    fontSize: 18,
                    //fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                _buildStoriesSection(screenWidth, screenHeight),

                SizedBox(height: 20),
              ],
            ),
          ),
          // Footer
          _buildFooterSection(screenWidth),
        ],
      ),
    );
  }

  Widget _buildSummarySection(double screenWidth) {
    // Futuristic minimal tiles
    return SizedBox(
      height: 85,
      child: Obx(
        () => ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _controller.summaryData.length,
          itemBuilder: (context, index) {
            final item = _controller.summaryData[index];
            return Padding(
              padding: const EdgeInsets.only(right: 10.0),

              child: SizedBox(
                width: screenWidth * 0.36, // Card width
                child: StatTile(
                  label: item['label']!,
                  value: item['value']!,
                  screenWidth: screenWidth,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMyUnitsSection(double screenWidth, double screenHeight) {
    const String unitPath = '/spark_units/NQ1GGynwiDg58BD1kKPv';
    //NQ1GGynwiDg58BD1kKPv
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.doc(unitPath).snapshots(),
      builder: (context, unitSnapshot) {
        if (unitSnapshot.connectionState == ConnectionState.waiting) {
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
                  projectSnapshot.data!.get('projectName') ?? 'Unknown Project';
            }

            return Column(
              children: [UnitItem(unit: unitDoc, projectName: projectName)],
            );
          },
        );
      },
    );
  }

  Widget _buildStoriesSection(double screenWidth, double screenHeight) {
    return SizedBox(
      height: screenHeight * 0.5,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _controller.stories.length,
        itemBuilder: (context, index) {
          final story = _controller.stories[index];
          return GestureDetector(
            onTap: () {
              // Open Story View
              Get.to(
                () => StoryView(
                  title: story['title'] as String,
                  videoUrl: story['videoUrl'] as String,
                  thumbnail: story['thumbnail'] as String,
                  address: story['address'] as String,
                ),
              );
            },
            child: Container(
              width: screenWidth * 0.77,
              margin: EdgeInsets.only(right: 7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8), // Rounded corners
                image: DecorationImage(
                  image: AssetImage(story['thumbnail'] as String),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.1),
                    BlendMode.darken,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 10,
                    left: 10,
                    right: 10,
                    child: Text(
                      story['title'] as String,
                      style: TextStyle(
                        fontFamily: 'Host Grotesk',
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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
              fontFamily: 'Host Grotesk',
              color: Colors.white,
              fontSize: titleSize,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6),
          Text(
            "#1,HSR Sector 1, Bangalore, Karnataka-560049",
            style: TextStyle(
              fontFamily: 'Host Grotesk',
              color: Color(0xff737576),
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: screenWidth * 0.03),
          GestureDetector(
            onTap: () {},
            child: Text(
              "View in Map",
              style: TextStyle(
                fontFamily: 'Host Grotesk',
                color: Color(0xff737576),
                fontSize: fontSize,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          SizedBox(height: screenWidth * 0.06),
          Text(
            "Contact Us",
            style: TextStyle(
              fontFamily: 'Host Grotesk',
              color: Colors.white,
              fontSize: titleSize,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: screenWidth * 0.015),
          Text(
            "+91 1234567890 || www.maahomes.in",
            style: TextStyle(
              fontFamily: 'Host Grotesk',
              color: Color(0xff737576),
              fontSize: fontSize,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: screenWidth * 0.05),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialIcon('assets/whatsapp.png', iconSize, () {}),
              _buildSocialIcon('assets/insta.png', iconSize, () {}),
              _buildSocialIcon('assets/x.png', iconSize, () {}),
              _buildSocialIcon('assets/fb.png', iconSize, () {}),
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
}

class HomeCarousel extends StatefulWidget {
  const HomeCarousel({super.key});

  @override
  _HomeCarouselState createState() => _HomeCarouselState();
}

class _HomeCarouselState extends State<HomeCarousel> {
  int _current = 0;
  final List<String> carouselImages = [
    'https://maahomes.in/media/LANDING-PAGE-landscape_yCQHN7l.png',
    'https://maahomes.in/media/bel-3_QElfrCg.jpg',
    'https://maahomes.in/media/WhatsApp_Image_2024-06-01_at_6.32.47_PM.jpeg',
    'https://maahomes.in/media/1383X446px_Panchajanyaa_Maahomes-web-banner.png',
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      // Removed ClipRRect for sharp corners
      child: Stack(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: screenHeight * 0.4,
              viewportFraction: 1.0,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 4),
              enableInfiniteScroll: true,
              scrollPhysics: BouncingScrollPhysics(),
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
            ),
            items:
                carouselImages.map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: screenWidth,
                        decoration: BoxDecoration(color: Colors.grey[200]),
                        child:
                            i.startsWith('http')
                                ? Image.network(
                                  i,
                                  fit: BoxFit.fitHeight,
                                  errorBuilder:
                                      (context, error, stackTrace) => Center(
                                        child: Icon(
                                          Icons.broken_image_outlined,
                                          size: 50,
                                          color: Colors.grey,
                                        ),
                                      ),
                                )
                                : Image.asset(
                                  i,
                                  fit: BoxFit.fitHeight,
                                  errorBuilder:
                                      (context, error, stackTrace) => Center(
                                        child: Icon(
                                          Icons.image_not_supported_outlined,
                                          size: 50,
                                          color: Colors.grey,
                                        ),
                                      ),
                                ),
                      );
                    },
                  );
                }).toList(),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  carouselImages.asMap().entries.map((entry) {
                    return Container(
                      width: 20.0,
                      height: 3.0,
                      margin: EdgeInsets.symmetric(horizontal: 2.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color:
                            _current == entry.key
                                ? Colors.white
                                : Colors.white.withOpacity(0.4),
                      ),
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
