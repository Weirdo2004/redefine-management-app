// import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'project_description_screen.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(Icons.arrow_back_outlined, color: Colors.black),
                  SizedBox(width: 16),
                  Text(
                    "Projects",
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff0E0A1F),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // new launch section
                    // NewLaunchSection(),

                    // Project Cards
                    ProjectCards(
                      projectName: "NVT Under the Open Sky",
                      location: "Whitefield, Bangalore-560032",
                      price: "₹ 2.5 Cr",
                      originalPrice: "₹ 3 Cr",
                      status: "under construction",
                      completion: "on july 2026",
                      bhkType: "4 BHK Villa",
                      nearbyPlaces: ["Hello Kids", "Dasegowda Health Center"],
                      imageUrl: "assets/bunglow.png",
                    ),

                    ProjectCards(
                      projectName: "NVT Under the Open Sky",
                      location: "Whitefield, Bangalore-560032",
                      price: "₹ 2.5 Cr",
                      originalPrice: "₹ 3 Cr",
                      status: "under construction",
                      completion: "on july 2026",
                      bhkType: "4 BHK Villa",
                      nearbyPlaces: ["Hello Kids", "Dasegowda Health Center"],
                      imageUrl: "assets/bunglow.png",
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

class ProjectCards extends StatelessWidget {
  final String projectName;
  final String location;
  final String price;
  final String originalPrice;
  final String status;
  final String completion;
  final String bhkType;
  final List<String> nearbyPlaces;
  final String imageUrl;

  const ProjectCards({
    required this.projectName,
    required this.location,
    required this.price,
    required this.originalPrice,
    required this.status,
    required this.completion,
    required this.bhkType,
    required this.nearbyPlaces,
    required this.imageUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to project description page when card is tapped
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProjectDescriptionScreen()),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section with Tags
            Stack(
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ClipRRect(
                    child: Image.asset(
                      imageUrl,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // RERA and Zero Brokerage Tags
                Positioned(
                  top: 20,
                  left: 22,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "Rera",
                          style: GoogleFonts.outfit(
                            color: Color(0xff0E0A1F),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "Zero Brokerage",
                          style: GoogleFonts.outfit(
                            color: Color(0xff0E0A1F),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // New Star Tag
                Positioned(
                  top: 0,
                  right: 0,
                  child: Image.asset('assets/new.png'),
                ),

                // Status and Completion
                Positioned(
                  bottom: 12,
                  left: 12,
                  right: 12,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    color: Colors.grey.shade500.withOpacity(0.7),
                    child: Row(
                      children: [
                        Icon(Icons.circle, size: 10, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          "$status-completion $completion",
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Project Details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    projectName,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    location,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 16),

                  // BHK and Price Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        bhkType,
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            price,
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 6),
                          Text(
                            originalPrice,
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              color: Colors.grey[600],
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 8),

                  // Divider
                  Center(
                    child: Container(
                      width: 300,
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

                  SizedBox(height: 16),

                  // Nearby Places
                  Row(
                    children: [
                      Text(
                        "Near by: ",
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Row(
                          children:
                              nearbyPlaces.map((place) {
                                return Row(
                                  children: [
                                    Text(
                                      place,
                                      style: GoogleFonts.outfit(
                                        fontSize: 12,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    if (place != nearbyPlaces.last)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                        ),
                                        child: Container(
                                          width: 1,
                                          height: 10,
                                          color: Color(0xffE7E7E9),
                                        ),
                                      ),
                                  ],
                                );
                              }).toList(),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Color(0xff0E0A1F)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          child: Text(
                            "Brochure",
                            style: GoogleFonts.outfit(
                              color: Color(0xff0E0A1F),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xffEDE9FE),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Call Now",
                                style: GoogleFonts.outfit(
                                  color: Color(0xff0E0A1F),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.call,
                                color: Color(0xff0E0A1F),
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// removed new launch section(add again if needed)

// class NewLaunchSection extends StatelessWidget {
//   const NewLaunchSection({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             spreadRadius: 1,
//             blurRadius: 3,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           // Top Image section with overlay text
//           Container(
//             height: 180,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(10),
//                 topRight: Radius.circular(10),
//               ),
//               image: DecorationImage(
//                 image: AssetImage('assets/building_dark.png'),
//                 opacity: 0.7,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             child: Stack(
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: [
//                         Colors.black.withOpacity(0.3),
//                         Colors.black.withOpacity(0.6),
//                       ],
//                     ),
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(10),
//                       topRight: Radius.circular(10),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             padding: EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               color: Colors.orange,
//                               shape: BoxShape.circle,
//                             ),
//                             child: Icon(
//                               Icons.star,
//                               color: Colors.white,
//                               size: 20,
//                             ),
//                           ),
//                           SizedBox(width: 10),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "NEW LAUNCH",
//                                 style: GoogleFonts.italiana(
//                                   color: Colors.white,
//                                   fontSize: 24,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                               Text(
//                                 "PROJECTS",
//                                 style: GoogleFonts.italiana(
//                                   color: Colors.white,
//                                   fontSize: 24,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 16),
//                       Center(
//                         child: Text(
//                           "Waiting comes with benefits!",
//                           style: GoogleFonts.outfit(
//                             color: Colors.white,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Middle section
//           Container(
//             padding: const EdgeInsets.all(16),
//             color: Colors.white,
//             width: double.infinity,
//             child: Column(
//               children: [
//                 Text(
//                   "WHY CONSIDER NEW LAUNCH?",
//                   style: GoogleFonts.italiana(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//                 SizedBox(height: 24),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     _buildBenefitItem(
//                       icon: Icons.trending_up,
//                       title: "High Price\nAppreciation",
//                       iconColor: Colors.orange,
//                     ),
//                     _buildBenefitItem(
//                       icon: Icons.favorite,
//                       title: "Units of\nChoice",
//                       iconColor: Colors.orange,
//                     ),
//                     _buildBenefitItem(
//                       icon: Icons.currency_rupee,
//                       title: "Affordable\npayment plans",
//                       iconColor: Colors.orange,
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 24),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: OutlinedButton(
//                         onPressed: () {},
//                         style: OutlinedButton.styleFrom(
//                           side: BorderSide(color: Colors.blue),
//                           padding: EdgeInsets.symmetric(vertical: 6),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                         child: Text(
//                           "Learn more",
//                           style: GoogleFonts.outfit(
//                             color: Colors.blue,
//                             fontSize: 16,
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 12),
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: () {},
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue,
//                           padding: EdgeInsets.symmetric(vertical: 6),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                         child: Text(
//                           "Explore projects",
//                           style: GoogleFonts.outfit(
//                             color: Colors.white,
//                             fontSize: 16,
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBenefitItem({
//     required IconData icon,
//     required String title,
//     required Color iconColor,
//   }) {
//     return Column(
//       children: [
//         Container(
//           padding: EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: iconColor.withOpacity(0.1),
//             shape: BoxShape.circle,
//           ),
//           child: Icon(icon, color: iconColor, size: 24),
//         ),
//         SizedBox(height: 10),
//         Text(
//           title,
//           textAlign: TextAlign.center,
//           style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w400),
//         ),
//       ],
//     );
//   }
// }