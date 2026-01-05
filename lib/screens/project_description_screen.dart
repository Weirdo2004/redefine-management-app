import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'dart:math';

class ProjectDescriptionScreen extends StatelessWidget {
  const ProjectDescriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  PropertyImageSection(),
                  PropertyHeaderSection(),
                  SizedBox(height: 8),
                  OverviewSection(),
                  SizedBox(height: 16),
                  HighlightsSection(),
                  SizedBox(height: 16),
                  AmenitiesSection(),
                  SizedBox(height: 16),
                  MasterplanSection(),
                  SizedBox(height: 16),
                  LocationSection(),
                  SizedBox(height: 80),
                ],
              ),
            ),
            Positioned(
              top: -2,
              left: -1,
              child: IconButton(
                color: Colors.black,
                icon: Padding(
                  padding: const EdgeInsets.only(right: 2.0),
                  child: const Icon(Icons.arrow_back_outlined),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Positioned(
              top: -6,
              right: -2,
              child: IconButton(
                color: Colors.white,
                icon: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Image.asset(
                    'assets/frame1.png',
                    width: 24,
                    height: 24,
                  ),
                ),
                onPressed: () {},
              ),
            ),

            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: BottomActionBar(),
            ),
          ],
        ),
      ),
    );
  }
}

class PropertyImageSection extends StatelessWidget {
  const PropertyImageSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 240,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bunglow.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 4),
              Container(
                width: 20,
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 4),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
              const SizedBox(width: 4),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PropertyHeaderSection extends StatelessWidget {
  const PropertyHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'WHITEFIELD, BANGALORE',
            style: GoogleFonts.outfit(
              fontSize: 12,
              color: Color(0xff606062),
              letterSpacing: 1.2,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                'Rera',
                style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey),
              ),
              Text(' · ', style: GoogleFonts.outfit(color: Colors.grey)),
              Text(
                'Zero Brokerage',
                style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'NVT Under the Open Sky',
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'An elegant 4 bhk villa offers spacious interiors, modern finishes, and provide comfort and luxury for the whole family',
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: Color(0xff606062),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class OverviewSection extends StatelessWidget {
  const OverviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'OVERVIEW',
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.2,
              color: Color(0xff0E0A1F),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(height: 1, color: Colors.grey.withOpacity(0.3)),
        const SizedBox(height: 12),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Subha 9 Sky Vue offers various housing options for all types of families in Bangalore. Options of 1, 2, 2.5, and 3 BHK apartments are all available. The contemporary style and modern planning of the apartments will give you the premium lifestyle you are looking for. Situated in a prime location in Chandapura, living at Subha 9 Sky Vue means you will always be close to the main hotspots of the city.',
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: Color(0xff606062),
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GestureDetector(
            onTap: () {},
            child: Text(
              'read more',
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class HighlightsSection extends StatelessWidget {
  const HighlightsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'HIGHLIGHTS',
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xff0E0A1F),
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(height: 1, color: Colors.grey.withOpacity(0.3)),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: _buildHighlightItem('Property area', '1 Acre 26 Guntas'),
              ),
              const SizedBox(width: 16),
              Expanded(child: _buildHighlightItem('Type', 'apartment')),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(child: _buildHighlightItem('No of units', '132')),
              const SizedBox(width: 16),
              Expanded(
                child: _buildHighlightItem('Built up area', '1 Acre 26 Guntas'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(child: _buildHighlightItem('Price', 'sold out')),
              const SizedBox(width: 16),
              Expanded(child: _buildHighlightItem('Status', 'ready to move')),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHighlightItem(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDiamondIcon(),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: Color(0xff0E0A1F),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff606062),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDiamondIcon() {
    return Transform.rotate(
      angle: 0.785398, // 45 degrees in radians
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black54, width: 1),
          borderRadius: BorderRadius.zero,
          shape: BoxShape.rectangle,
        ),
      ),
    );
  }
}

final Map<String, String> amenityImages = {
  'park': 'assets/park.png',
  'skating track': 'assets/skating.jpg',
  'basketball': 'assets/basketball.jpg',
  'seating alcove': 'assets/alcove.jpg',
  'table top games': 'assets/tabletop.png',
  'gym': 'assets/gym.png',
};

class AmenitiesSection extends StatelessWidget {
  const AmenitiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'AMENITIES',
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xff0E0A1F),
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(height: 1, color: Colors.grey.withOpacity(0.3)),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              // First row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildAmenityItem('park'),
                  _buildAmenityItem('skating track'),
                  _buildAmenityItem('basketball'),
                ],
              ),
              const SizedBox(height: 16),
              // Second row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildAmenityItem('seating alcove'),
                  _buildAmenityItem('table top games'),
                  _buildAmenityItem('gym'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            width: double.infinity, // Fill (343px with the padding)
            height: 34, // Fixed (34px)
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'View all Amenities',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff0E0A1F),
                    ),
                  ),
                  SizedBox(width: 10), // Gap 10px
                  Icon(Icons.arrow_forward_outlined, size: 16),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAmenityItem(String title) {
    return Column(
      children: [
        Container(
          height: 70,
          width: 100,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(4),
            image: DecorationImage(
              image: AssetImage(
                amenityImages[title] ?? 'assets/images/placeholder.png',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: GoogleFonts.outfit(fontSize: 12, color: Color(0xff606062)),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class MasterplanSection extends StatelessWidget {
  const MasterplanSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'MASTERPLAN',
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xff0E0A1F),
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(height: 1, color: Colors.grey.withOpacity(0.3)),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            width: 343,
            height: 195.94,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
              image: const DecorationImage(
                image: AssetImage('assets/masterplan.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class LocationSection extends StatelessWidget {
  const LocationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'LOCATION',
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xff0E0A1F),
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(height: 1, color: Colors.grey.withOpacity(0.3)),
        const SizedBox(height: 12),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'NVT Under the Open Sky is located 30 km away from you',
            style: GoogleFonts.outfit(
              fontSize: 12,
              color: Color(0xff606062),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            width: 343,
            height: 213.16,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
              image: const DecorationImage(
                image: AssetImage('assets/location.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),
        // Under construction tag
        Row(
          children: [
            Container(
              width: 358,
              height: 23,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.zero,
                color: Color(0xffEDE9FE),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 6),
                    child: Icon(
                      Icons.engineering,
                      size: 14,
                      color: Color(0xff0E0A1F),
                    ),
                  ),
                  SizedBox(width: 4),
                  Text(
                    'under construction-completion on july 2026',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: Color(0xff0E0A1F),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class BottomActionBar extends StatelessWidget {
  const BottomActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      color: Color(0xff000000),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // Property information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '4 BHK Villa',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  '₹ 2.5 Cr | 3G',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          // Call Now button
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Text(
                  'Call Now',
                  style: GoogleFonts.outfit(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.phone_outlined, color: Colors.black, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
