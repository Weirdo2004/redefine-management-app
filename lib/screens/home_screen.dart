import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import '../widgets/project_cards.dart';
import '../widgets/stats_filter_widget.dart';

import '../widgets/custom_bottom_nav_bar.dart';
import 'profile_screen.dart';
// import 'project_sample_screen.dart'; // Will resolve automatically if named correctly

// Mocked Project Sample Screen Path
const String projectSampleRoute = '/project_sample';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isFabExpanded = true;
  int _currentNavIndex = 0;
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedProjectId;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _onDateRangeChanged(DateTime start, DateTime end) {
    setState(() {
      _startDate = start;
      _endDate = end;
    });
  }

  void _onProjectChanged(String? projectId) {
    setState(() {
      _selectedProjectId = projectId;
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels > 50 && _isFabExpanded) {
      setState(() {
        _isFabExpanded = false;
      });
    } else if (_scrollController.position.pixels <= 50 && !_isFabExpanded) {
      setState(() {
        _isFabExpanded = true;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: _currentNavIndex == 0 ? _buildHomeAppBar() : null,
      body: Stack(
        children: [
          // Main Content Area
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 80), // Space for Nav Bar
              child: _buildBody(),
            ),
          ),

          // FLOATING BOTTOM NAV BAR
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomBottomNavBar(
              currentIndex: _currentNavIndex,
              onTap: (index) {
                setState(() {
                  _currentNavIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentNavIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return const Center(
          child: Text("Weekly , Monthly Reports Coming Soon"),
        );
      case 2:
        return const Center(child: Text("Inventory Details Coming Soon"));
      case 3:
        return ProfileScreen();
      default:
        return _buildHomeContent();
    }
  }

  PreferredSizeWidget _buildHomeAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFF7F8FA),
      elevation: 0,
      toolbarHeight: 60, // Increased height
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF134044),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8), // Increased padding
            child: const Icon(
              Icons.bar_chart_outlined,
              color: Colors.white,
              size: 20, // Increased size
            ),
          ),
          const SizedBox(width: 8),
          Text(
            "Analytics",
            style: TextStyle(
              fontSize: 22, // Increased size
              fontWeight: FontWeight.w700,
              color: const Color(0xFF134044),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        // TOP SPACING
        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        // DATE FILTER
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          sliver: SliverToBoxAdapter(
            child: StatsFilterWidget(
              onDateChanged: _onDateRangeChanged,
              onProjectChanged: _onProjectChanged,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        // PROJECT CARDS TITLE
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          sliver: SliverToBoxAdapter(
            child: Text(
              "LEADS",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade500,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),

        // PROJECT CARDS GRID
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate((context, index) {
              return ProjectCardItem(
                index: index,
                startDate: _startDate,
                endDate: _endDate,
                projectId: _selectedProjectId,
              );
            }, childCount: 4),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.7,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        // NEW SITE VISITS CARD (Horizontal)
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          sliver: SliverToBoxAdapter(child: _buildSiteVisitsCard()),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        // INVEST TITLE
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          sliver: SliverToBoxAdapter(
            child: Text(
              "CRM",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade500,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),

        // INVEST GRID
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          sliver: SliverGrid(
            delegate: SliverChildListDelegate([
              _buildLoanCard(
                title: "Projected Collections",
                icon: Icons.account_balance,
                iconColor: Colors.brown,
                subtitleWidget: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade700,
                      height: 1.3,
                    ),
                    children: [
                      TextSpan(
                        text: "₹0L ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      TextSpan(
                        text: "from the units  (Coming soon...)",
                        style: TextStyle(color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
              _buildGoldCard(),
            ]),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.4,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        // MORE TITLE
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          sliver: SliverToBoxAdapter(
            child: Text(
              "MORE",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade500,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),

        // MORE GRID
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          sliver: SliverGrid(
            delegate: SliverChildListDelegate([
              _buildLoanCard(
                title: "Call Hours",
                icon: Icons.qr_code,
                iconColor: Colors.black,
                subtitleWidget: Text(
                  "(Coming soon...)",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade700,
                    height: 1.3,
                  ),
                ),
              ),
              _buildLoanCard(
                title: "Calls Count",
                icon: Icons.shield,
                iconColor: Colors.red.shade300,
                subtitleWidget: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade700,
                      height: 1.3,
                    ),
                    children: [TextSpan(text: "(Coming soon...)")],
                  ),
                ),
              ),
            ]),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.4,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),

        // Credit Tracker Full Width
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 100),
          sliver: SliverToBoxAdapter(
            child: GestureDetector(
              onTap:
                  () => Get.toNamed(
                    projectSampleRoute,
                    arguments: {
                      'projectId': _selectedProjectId,
                      'startDate': _startDate?.millisecondsSinceEpoch,
                      'endDate': _endDate?.millisecondsSinceEpoch,
                    },
                  ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.orange.shade100,
                          radius: 18,
                          child: const Icon(Icons.speed, color: Colors.orange),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Leads Health",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              "Sales report with personalised tips",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: Color(0xFF2C9F6E),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSiteVisitsCard() {
    final AuthService authService = Get.find<AuthService>();

    return Obx(() {
      final String svCollection = authService.siteVisitsCollectionName.value;
      final String leadsCollection = authService.leadsCollectionName.value;

      if (svCollection.isEmpty || leadsCollection.isEmpty) {
        return const SizedBox.shrink();
      }

      Future<Map<String, int>> fetchData() async {
        Query svQuery = FirebaseFirestore.instance.collection(svCollection);
        Query leadsQuery = FirebaseFirestore.instance.collection(
          leadsCollection,
        );

        if (_startDate != null && _endDate != null) {
          int startMillis = _startDate!.millisecondsSinceEpoch;
          int endMillis = _endDate!.millisecondsSinceEpoch;
          svQuery = svQuery
              .where('svHappendOn', isGreaterThanOrEqualTo: startMillis)
              .where('svHappendOn', isLessThan: endMillis);
          leadsQuery = leadsQuery
              .where('Date', isGreaterThanOrEqualTo: startMillis)
              .where('Date', isLessThan: endMillis);
        }

        if (_selectedProjectId != null) {
          // Robust filtering for specific project
          // Try ID first
          try {
            final svIdParams = svQuery.where(
              'projectId',
              isEqualTo: _selectedProjectId,
            );
            final leadsIdParams = leadsQuery.where(
              'ProjectId',
              isEqualTo: _selectedProjectId,
            );

            // Check if ID query works (count > -1 is just a check, we want count)
            // Actually just run it. If it fails, catch and fallback.
            AggregateQuerySnapshot svSnap = await svIdParams.count().get();
            AggregateQuerySnapshot leadsSnap =
                await leadsIdParams.count().get();

            return {
              'siteVisits': svSnap.count ?? 0,
              'totalLeads': leadsSnap.count ?? 0,
            };
          } catch (e) {
            // Fallback to Name
            // Need to get project name from ID
            final project = authService.projects.firstWhere(
              (p) => p['id'] == _selectedProjectId,
              orElse: () => {'name': ''},
            );
            final projectName = project['name'] ?? '';

            if (projectName.isNotEmpty) {
              svQuery = svQuery.where('projectName', isEqualTo: projectName);
              leadsQuery = leadsQuery.where('Project', isEqualTo: projectName);

              AggregateQuerySnapshot svSnap = await svQuery.count().get();
              AggregateQuerySnapshot leadsSnap = await leadsQuery.count().get();

              return {
                'siteVisits': svSnap.count ?? 0,
                'totalLeads': leadsSnap.count ?? 0,
              };
            }
          }
        }

        // Default (All Projects or Fallback failed)
        // If _selectedProjectId is null, we just run the base query (filtered by date)
        if (_selectedProjectId == null) {
          AggregateQuerySnapshot svSnap = await svQuery.count().get();
          AggregateQuerySnapshot leadsSnap = await leadsQuery.count().get();
          return {
            'siteVisits': svSnap.count ?? 0,
            'totalLeads': leadsSnap.count ?? 0,
          };
        }

        return {'siteVisits': 0, 'totalLeads': 0};
      }

      return FutureBuilder<Map<String, int>>(
        future: fetchData(),
        builder: (context, snapshot) {
          int siteVisits = 0;
          int totalLeads = 1; // Avoid div by zero

          if (snapshot.hasData) {
            siteVisits = snapshot.data!['siteVisits'] ?? 0;
            totalLeads = snapshot.data!['totalLeads'] ?? 1;
            if (totalLeads == 0) totalLeads = 1;
          }

          double progress = siteVisits / totalLeads;
          if (progress > 1.0) progress = 1.0;
          if (progress < 0.0) progress = 0.0;

          // Format for display
          String svDisplay = snapshot.hasData ? "$siteVisits" : "...";

          return GestureDetector(
            onTap: () {
              Get.toNamed(
                projectSampleRoute,
                arguments: {
                  'projectId': _selectedProjectId,
                  'startDate': _startDate?.millisecondsSinceEpoch,
                  'endDate': _endDate?.millisecondsSinceEpoch,
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [],
              ),
              child: Row(
                children: [
                  // Icon Box
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6A96B).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.location_on_outlined,
                      color: Color(0xFFE6A96B),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Site Visits",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              svDisplay,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1F1F1F),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Progress Bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.grey[200],
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFFE6A96B),
                            ),
                            minHeight: 8,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${(progress * 100).toStringAsFixed(1)}% of total leads",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildGoldCard() {
    return GestureDetector(
      onTap:
          () => Get.toNamed(
            projectSampleRoute,
            arguments: {
              'projectId': _selectedProjectId,
              'startDate': _startDate?.millisecondsSinceEpoch,
              'endDate': _endDate?.millisecondsSinceEpoch,
            },
          ),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFBEBF9), Color(0xFFFFF6E5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Claimed\nAmount",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D1E2F),
                      height: 1.1,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              "Know the details!",
              style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "(Coming soon...)",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2D1E2F),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward,
                  size: 16,
                  color: Color(0xFF2C9F6E),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoanCard({
    required String title,
    required Widget subtitleWidget,
    required IconData icon,
    required Color iconColor,
  }) {
    return GestureDetector(
      onTap:
          () => Get.toNamed(
            projectSampleRoute,
            arguments: {
              'projectId': _selectedProjectId,
              'startDate': _startDate?.millisecondsSinceEpoch,
              'endDate': _endDate?.millisecondsSinceEpoch,
            },
          ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Icon(icon, color: iconColor, size: 28),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(child: subtitleWidget),
                const Icon(
                  Icons.arrow_forward,
                  size: 20,
                  color: Color(0xFF2C9F6E),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalLoanCard() {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          projectSampleRoute,
          arguments: {
            'projectId': _selectedProjectId,
            'startDate': _startDate?.millisecondsSinceEpoch,
            'endDate': _endDate?.millisecondsSinceEpoch,
          },
        );
      },
      child: Container(
        height: 320, // Approximate height
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF134044), // Dark Green
          borderRadius: BorderRadius.circular(5),
        ),
        child: Stack(
          children: [
            // Right Image Mockup
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 160,
                height: 240,
                // Make a placeholder image of a person
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: NetworkImage(
                      "https://media.istockphoto.com/id/1358997053/photo/young-man-stock-phooto.webp?s=612x612&w=is&k=20&c=xls3atNouxLbNj6w0UW26uYT_kXCueIYh8zslIzBfKo=",
                    ), // Placeholder
                    fit: BoxFit.cover,
                    // colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.1), BlendMode.darken),
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(20),
                  ),
                ),
                alignment: Alignment.bottomCenter,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFE8D5B5),
                        ),
                        child: Icon(
                          Icons.currency_rupee,
                          size: 12,
                          color: Colors.brown,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Personal Loan",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Get a loan up to",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "₹10,00,000",
                    style: TextStyle(
                      color: const Color(0xFFC5E8CF), // Light Green text
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                    ),
                  ),
                  Text(
                    "in 10 mins",
                    style: TextStyle(
                      color: const Color(0xFFC5E8CF),
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Icon(
                        Icons.assignment_outlined,
                        color: Colors.white70,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Zero documentation",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(color: Colors.transparent),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Apply for loan",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_forward,
                            size: 16,
                            color: Color(0xFF134044),
                          ),
                        ),
                      ],
                    ),
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
