import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class StoryView extends StatelessWidget {
  final String title;
  final String videoUrl; // Placeholder: using image for now as requested
  final String thumbnail;
  final String address;

  const StoryView({
    super.key,
    required this.title,
    required this.videoUrl,
    required this.thumbnail,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    // Determine if we should show a video or just the thumbnail image acting as a "story"
    // Since we don't have actual video integration yet, we'll simulate the "Story" look.

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background (Thumbnail/Video)
          Positioned.fill(
            child: Image.asset(
              thumbnail,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Return a placeholder if image fails
                return Container(color: Colors.grey[900]);
              },
            ),
          ),

          // Overlay Gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                    Colors.black.withOpacity(0.6),
                  ],
                ),
              ),
            ),
          ),

          // Progress Bar (Simulated)
          Positioned(
            top: 50,
            left: 10,
            right: 10,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Close Button
          Positioned(
            top: 60,
            right: 20,
            child: IconButton(
              icon: Icon(Icons.close_outlined, color: Colors.white, size: 30),
              onPressed: () => Get.back(),
            ),
          ),

          // Content Info
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.5)),
                  ),
                  child: Text(
                    "Property Tour",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: Colors.white70,
                      size: 16,
                    ),
                    SizedBox(width: 5),
                    Text(
                      address,
                      style: GoogleFonts.outfit(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                  child: Text(
                    "Enquire Now",
                    style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
