import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
import '../widgets/leads_table_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../utils/project_style.dart';

class ProjectSampleScreen extends StatefulWidget {
  const ProjectSampleScreen({super.key});

  @override
  State<ProjectSampleScreen> createState() => _ProjectSampleScreenState();
}

class _ProjectSampleScreenState extends State<ProjectSampleScreen> {
  // New State for Dynamic Filtering
  String? _selectedProjectId;
  String _selectedProjectName = "All Projects"; // Display name
  DateTime? _startDate;
  DateTime? _endDate;
  String _selectedFilter = 'Today'; // Default filter name

  Map<String, dynamic> _chartData = {'labels': [], 'data': [], 'max': 100.0};
  bool _isLoadingChart = true;

  // Summary Stats State
  int _sTotalLeads = 0;
  int _sQualifiedLeads = 0;
  int _sUnqualifiedLeads = 0;
  bool _isLoadingSummary = true;

  // Robust Filter Cache
  Map<String, dynamic>? _cachedRobustParams;

  // Project Stats State
  List<ProjectStats> _projectStats = [];
  bool _isLoadingStats = true;

  @override
  void initState() {
    super.initState();
    _handleArguments();
    // Defer fetching to allow access to context/providers if needed, though Get.find works immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  void _handleArguments() {
    final args = Get.arguments;
    if (args != null && args is Map) {
      if (args['projectId'] != null) {
        _selectedProjectId = args['projectId'];
        final AuthService authService = Get.find<AuthService>();
        final project = authService.projects.firstWhere(
          (p) => p['id'] == _selectedProjectId,
          orElse: () => {'name': 'All Projects'},
        );
        _selectedProjectName = project['name'] ?? 'All Projects';
      }

      if (args['startDate'] != null) {
        _startDate = DateTime.fromMillisecondsSinceEpoch(args['startDate']);
      }
      if (args['endDate'] != null) {
        _endDate = DateTime.fromMillisecondsSinceEpoch(args['endDate']);
      }

      // If dates are still null (e.g. passed as null), default to Today
      if (_startDate == null || _endDate == null) {
        _applyFilter('Today');
      } else {
        _deduceFilterLabel();
      }
    } else {
      // Default initialization if no args
      _applyFilter('Today');
    }
  }

  void _deduceFilterLabel() {
    // logic to guess label if needed, or just set to Custom
    // or we could have passed the label.
    // For now let's assume if dates are set, we respect them.
    if (_startDate != null) {
      // If perfectly matches Today, etc?
      // Let's just say "Date Range" or similar if we can't be sure
      _selectedFilter = "Custom";
      // Improvement: Pass filter name from Home Screen would be cleaner.
      // But let's check standard ranges.
      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      if (_startDate == todayStart) {
        _selectedFilter = 'Today';
      } else if (_startDate == todayStart.subtract(Duration(days: 1)) &&
          _endDate!.difference(_startDate!).inDays == 1) {
        _selectedFilter = 'Previous Day';
      }
      // ... etc.
    }
  }

  void _applyFilter(String filter) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);

    if (filter == 'Today') {
      _startDate = todayStart;
      _endDate = todayStart.add(const Duration(days: 1));
    } else if (filter == 'Previous Day') {
      _startDate = todayStart.subtract(const Duration(days: 1));
      _endDate = _startDate!.add(const Duration(days: 1));
    } else if (filter == 'Last 7 Days') {
      _startDate = todayStart.subtract(const Duration(days: 6));
      _endDate = todayStart.add(const Duration(days: 1));
    } else if (filter == 'Last 30 Days') {
      _startDate = todayStart.subtract(const Duration(days: 29));
      _endDate = todayStart.add(const Duration(days: 1));
    } else if (filter == 'Last Month') {
      _startDate = DateTime(now.year, now.month - 1, 1);
      _endDate = DateTime(now.year, now.month, 1);
    } else if (filter == 'All Dates') {
      _startDate = DateTime(1970);
      _endDate = DateTime(2100);
    }

    _selectedFilter = filter;
  }

  void _fetchData() {
    _fetchProjectStats();
    _fetchChartData();
    _fetchSummaryStats();
  }

  Future<int> _fetchRobustCount({
    required String collectionName,
    required String dateField,
    required String idField,
    required String nameField,
    required String? projectId,
    required String? projectName,
    List<String>? statusList,
    String? statusField,
  }) async {
    // Base Query Builder
    Query buildQuery(String field, String value) {
      Query query = FirebaseFirestore.instance.collection(collectionName);

      if (_startDate != null && _endDate != null) {
        int startMillis = _startDate!.millisecondsSinceEpoch;
        int endMillis = _endDate!.millisecondsSinceEpoch;
        query = query
            .where(dateField, isGreaterThanOrEqualTo: startMillis)
            .where(dateField, isLessThan: endMillis);
      }

      query = query.where(field, isEqualTo: value);

      if (statusList != null && statusList.isNotEmpty && statusField != null) {
        query = query.where(statusField, whereIn: statusList);
      }
      return query;
    }

    if (projectId != null) {
      try {
        final idQuery = buildQuery(idField, projectId);
        final idSnapshot = await idQuery.count().get();
        final idCount = idSnapshot.count ?? 0;
        if (idCount > 0) return idCount;
      } catch (e) {
        // Fallback
      }
    }

    if (projectName != null && projectName.isNotEmpty) {
      try {
        final nameQuery = buildQuery(nameField, projectName);
        final nameSnapshot = await nameQuery.count().get();
        return nameSnapshot.count ?? 0;
      } catch (e) {
        // Ignore
      }
    }

    return 0;
  }

  Future<void> _fetchSummaryStats() async {
    if (!mounted) return;
    setState(() => _isLoadingSummary = true);

    try {
      final authService = Get.find<AuthService>();
      String collectionName = authService.leadsCollectionName.value;

      if (collectionName.isEmpty) {
        if (mounted) setState(() => _isLoadingSummary = false);
        return;
      }

      final qualifiedStatus = [
        'new',
        'followup',
        'visitfixed',
        'visitdone',
        'negotiation',
        'prospect',
      ];

      int total = 0;
      int qualified = 0;

      if (_selectedProjectId != null) {
        // Project Specific - Use Robust Logic
        total = await _fetchRobustCount(
          collectionName: collectionName,
          dateField: 'Date',
          idField: 'ProjectId',
          nameField: 'Project',
          projectId: _selectedProjectId,
          projectName: _selectedProjectName,
        );

        qualified = await _fetchRobustCount(
          collectionName: collectionName,
          dateField: 'Date',
          idField: 'ProjectId',
          nameField: 'Project',
          projectId: _selectedProjectId,
          projectName: _selectedProjectName,
          statusField: 'Status',
          statusList: qualifiedStatus,
        );
      } else {
        // All Projects
        Query baseQuery = FirebaseFirestore.instance.collection(collectionName);
        if (_startDate != null && _endDate != null) {
          baseQuery = baseQuery
              .where(
                'Date',
                isGreaterThanOrEqualTo: _startDate!.millisecondsSinceEpoch,
              )
              .where('Date', isLessThan: _endDate!.millisecondsSinceEpoch);
        }

        AggregateQuerySnapshot totalSnap = await baseQuery.count().get();
        total = totalSnap.count ?? 0;

        AggregateQuerySnapshot qualifiedSnap =
            await baseQuery
                .where('Status', whereIn: qualifiedStatus)
                .count()
                .get();
        qualified = qualifiedSnap.count ?? 0;
      }

      if (mounted) {
        setState(() {
          _sTotalLeads = total;
          _sQualifiedLeads = qualified;
          _sUnqualifiedLeads = total - qualified;
          _isLoadingSummary = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching summary stats: $e");
      if (mounted) setState(() => _isLoadingSummary = false);
    }
  }

  Future<void> _fetchProjectStats() async {
    if (!mounted) return;
    setState(() => _isLoadingStats = true);

    try {
      final authService = Get.find<AuthService>();
      final projects = authService.projects;
      String collectionName = authService.leadsCollectionName.value;

      if (collectionName.isEmpty) {
        if (mounted) setState(() => _isLoadingStats = false);
        return;
      }

      List<ProjectStats> stats = [];
      final qualifiedStatus = [
        'new',
        'followup',
        'visitfixed',
        'visitdone',
        'negotiation',
        'prospect',
      ];

      // Run queries concurrently for ALL projects (no filtering)
      final futures = projects.map((p) async {
        final pid = p['id'];
        final pName = p['name'];
        final name =
            (pName != null && pName.toString().isNotEmpty)
                ? pName.toString()
                : 'Unknown';

        final baseQuery = FirebaseFirestore.instance
            .collection(collectionName)
            .where('ProjectId', isEqualTo: pid);

        // Total
        AggregateQuerySnapshot totalSnap = await baseQuery.count().get();
        final total = totalSnap.count ?? 0;

        // Qualified
        AggregateQuerySnapshot qualifiedSnap =
            await baseQuery
                .where('Status', whereIn: qualifiedStatus)
                .count()
                .get();
        final qualified = qualifiedSnap.count ?? 0;

        return ProjectStats(
          name: name,
          totalLeads: total,
          qualifiedLeads: qualified,
          unqualifiedLeads: total - qualified,
        );
      });

      stats = await Future.wait(futures);

      // Sort by total leads descending
      stats.sort((a, b) => b.totalLeads.compareTo(a.totalLeads));

      if (mounted) {
        setState(() {
          _projectStats = stats;
          _isLoadingStats = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching project stats: $e");
      if (mounted) setState(() => _isLoadingStats = false);
    }
  }

  Future<Map<String, dynamic>> _getRobustFilterParams(
    String collectionName,
    DateTime? start,
    DateTime? end,
  ) async {
    // We do not cache this result because the best strategy (ID vs Name) might depend on
    // data quality for the specific date range, and we want to align with ProjectCard behavior.

    try {
      // Test ID Query WITH DATE
      // The failure usually happens when checking ID + Date range if index missing.
      Query q = FirebaseFirestore.instance
          .collection(collectionName)
          .where('ProjectId', isEqualTo: _selectedProjectId);

      if (start != null && end != null) {
        q = q
            .where('Date', isGreaterThanOrEqualTo: start.millisecondsSinceEpoch)
            .where('Date', isLessThan: end.millisecondsSinceEpoch);
      }

      final snap = await q.limit(1).get();

      // If we find data with ID, stick with ID.
      if (snap.docs.isNotEmpty) {
        return {'field': 'ProjectId', 'value': _selectedProjectId};
      }

      // If ID found nothing, we fall back to Name (just like ProjectCardItem does),
      // in case the data is stored with Name but not ID or inconsistent.
    } catch (e) {
      debugPrint("⚠️ ID Query failed (likely index), falling back to Name: $e");
    }

    // Fallback default
    return {'field': 'Project', 'value': _selectedProjectName};
  }

  Future<void> _fetchChartData() async {
    if (!mounted) return;
    setState(() => _isLoadingChart = true);
    // Also fetch summary when core parameters change (time, project)
    // We can call it here or in the caller. Caller is better for separation inside _fetchData,
    // but dropdown changes call only _fetchChartData currently.
    // Let's ensure _fetchSummaryStats is called whenever this is called if we want them synced.
    // Actually, let's keep them separate but call both on user actions.

    try {
      final authService = Get.find<AuthService>();
      String collectionName = authService.leadsCollectionName.value;

      if (collectionName.isEmpty) {
        _setEmptyChartData();
        return;
      }

      List<String> labels = [];
      List<double> dataPoints = [];
      double maxCount = 0;

      DateTime start =
          _startDate ?? DateTime.now().subtract(const Duration(days: 7));
      DateTime end = _endDate ?? DateTime.now().add(const Duration(days: 1));
      Duration duration = end.difference(start);

      // Prepare Buckets
      List<Map<String, dynamic>> buckets = [];

      if (duration.inHours <= 48) {
        // Hourly buckets (4-hour blocks if > 24h, or 1h if < 24h? - Stick to 4h for density or 1h for precision)
        // Original logic was 4-hour blocks for 'Today'. Let's do 4-hour blocks or 3-hour.
        // If it's a single day, 4-hour blocks = 6 points. Nice.
        int stepHours = 4;
        if (duration.inHours <= 24) stepHours = 3;

        DateTime current = start;
        while (current.isBefore(end)) {
          DateTime bucketEnd = current.add(Duration(hours: stepHours));
          if (bucketEnd.isAfter(end)) bucketEnd = end;

          String label = "${current.hour.toString().padLeft(2, '0')}:00";
          buckets.add({
            'start': current.millisecondsSinceEpoch,
            'end': bucketEnd.millisecondsSinceEpoch,
            'label': label,
          });
          current = bucketEnd;
        }
      } else if (duration.inDays <= 8) {
        // Daily Buckets (For "Last 7 Days" or shorter)
        DateTime current = DateTime(start.year, start.month, start.day);
        DateTime targetEnd = DateTime(end.year, end.month, end.day);
        if (end.hour > 0 || end.minute > 0) {
          targetEnd = targetEnd.add(Duration(days: 1));
        }

        while (current.isBefore(targetEnd) && current.isBefore(end)) {
          DateTime bucketEnd = current.add(const Duration(days: 1));
          // If we overshoot actual end, that's fine for query, but logic usually aligns to day boundaries.

          String label = _getWeekday(
            current.weekday,
          ); // Or format date? date is better for longer periods.
          if (duration.inDays > 7) {
            label = "${current.day}/${current.month}";
          }

          buckets.add({
            'start': current.millisecondsSinceEpoch,
            'end': bucketEnd.millisecondsSinceEpoch,
            'label': label,
          });
          current = bucketEnd;
        }
      } else {
        // Weekly or Monthly
        // Let's do Weekly for now roughly
        // Weekly or Monthly
        // Let's do Weekly for now roughly
        DateTime current = start;
        int safetyBreak = 0;
        while (current.isBefore(end)) {
          safetyBreak++;
          if (safetyBreak > 100) {
            debugPrint("⚠️ Max buckets reached. Truncating chart data.");
            break;
          }
          DateTime bucketEnd = current.add(const Duration(days: 7));
          buckets.add({
            'start': current.millisecondsSinceEpoch,
            'end': bucketEnd.millisecondsSinceEpoch,
            'label': "${current.day}/${current.month}",
          });
          current = bucketEnd;
        }
      }

      // Execute Queries for each bucket
      List<Future<int>> futures = [];

      String? filterField;
      dynamic filterValue;

      if (_selectedProjectId != null) {
        Map<String, dynamic> filterParams = await _getRobustFilterParams(
          collectionName,
          _startDate,
          _endDate,
        );
        filterField = filterParams['field'];
        filterValue = filterParams['value'];
      }

      for (var bucket in buckets) {
        int s = bucket['start'];
        int e = bucket['end'];

        Query q = FirebaseFirestore.instance.collection(collectionName);
        if (filterField != null) {
          q = q.where(filterField, isEqualTo: filterValue);
        }

        futures.add(
          q
              .where('Date', isGreaterThanOrEqualTo: s)
              .where('Date', isLessThan: e)
              .count()
              .get()
              .then((snap) => snap.count ?? 0),
        );
      }

      final results = await Future.wait(futures);

      // Map results to chart data
      int resultIndex = 0;
      for (var bucket in buckets) {
        labels.add(bucket['label']);
        double count = results[resultIndex].toDouble();
        dataPoints.add(count);
        if (count > maxCount) maxCount = count;
        resultIndex++;
      }

      // Adjust max for aesthetics
      if (maxCount == 0) {
        maxCount = 10;
      } else {
        maxCount = maxCount * 1.2;
      }

      if (mounted) {
        setState(() {
          _chartData = {'labels': labels, 'data': dataPoints, 'max': maxCount};
          _isLoadingChart = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching chart data: $e");
      _setEmptyChartData();
    }
  }

  String _getWeekday(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  void _setEmptyChartData() {
    if (mounted) {
      setState(() {
        _chartData = {'labels': [], 'data': [], 'max': 100.0};
        _isLoadingChart = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeaderSection()),
          SliverToBoxAdapter(child: _buildFeaturesBar()),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          SliverToBoxAdapter(child: _buildTableSection()),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          // SliverToBoxAdapter(child: _buildExploreHeader()),
          // SliverPadding(
          //   padding: const EdgeInsets.symmetric(horizontal: 20),
          //   sliver: SliverGrid(
          //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //       crossAxisCount: 2,
          //       childAspectRatio: 0.90,
          //       mainAxisSpacing: 16,
          //       crossAxisSpacing: 16,
          //     ),
          //     delegate: SliverChildListDelegate([
          //       _buildFDCard(
          //         bankName: "Utkarsh SF Bank",
          //         rate: "8.0%",
          //         tag: "Insured upto ₹5L",
          //         tagIcon: Icons.shield_moon_outlined,
          //         colorTheme: "green",
          //       ),
          //       _buildFDCard(
          //         bankName: "Suryoday SF Bank",
          //         rate: "8.0%",
          //         tag: "Maximum return",
          //         tagIcon: Icons.star_border,
          //         colorTheme: "blue",
          //       ),
          //       _buildFDCard(
          //         bankName: "Shriram Finance",
          //         rate: "7.81%",
          //         tag: "Insured upto ₹5L",
          //         tagIcon: Icons.shield_moon_outlined,
          //         tagColor: Color(0xFF134044),
          //         colorTheme: "blue_light",
          //       ),
          //       _buildFDCard(
          //         bankName: "Shivalik SF Bank",
          //         rate: "7.8%",
          //         tag: "Insured upto ₹5L",
          //         tagIcon: Icons.shield_moon_outlined,
          //         colorTheme: "blue_light",
          //       ),
          //     ]),
          //   ),
          // ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      color: const Color(0xFF134044),
      padding: const EdgeInsets.fromLTRB(
        0,
        50,
        0,
        20,
      ), // Top padding for status bar
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                // Project Selector
                GestureDetector(
                  onTap: _showProjectBottomSheet,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF2C9F6E),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 150),
                          child: Text(
                            _selectedProjectName,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF2C9F6E),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Color(0xFF2C9F6E),
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),
          // Chart Card with Line Graph
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Time Period Selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Leads Trend",
                          style: TextStyle(
                            color: const Color(0xFF134044),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (_isLoadingChart)
                          const SizedBox(
                            height: 12,
                            width: 12,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFF134044),
                            ),
                          ),
                      ],
                    ),
                    // Date Filter Selector
                    GestureDetector(
                      onTap: _showFilterBottomSheet,
                      child: Container(
                        height: 36,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFF2C9F6E).withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _selectedFilter,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2C9F6E),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(0xFF2C9F6E),
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Line Chart
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 600),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.1, 0),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                          ),
                        ),
                        child: child,
                      ),
                    );
                  },
                  child: _buildLineChart(key: ValueKey(_selectedFilter)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.60,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              children: [
                const SizedBox(height: 8),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Text(
                      "Select Period",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildOptionItem("All Dates", Icons.calendar_view_week),
                _buildOptionItem("Today", Icons.today),
                _buildOptionItem("Previous Day", Icons.history),
                _buildOptionItem("Last 7 Days", Icons.date_range),
                _buildOptionItem("Last 30 Days", Icons.date_range),
                _buildOptionItem("Last Month", Icons.calendar_month),
              ],
            ),
          ),
    );
  }

  Widget _buildOptionItem(String label, IconData icon) {
    bool isSelected = _selectedFilter == label;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
        _applyFilter(label);
        Navigator.pop(context);
        _fetchData();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F8F0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: const Color(0xFF2C9F6E), size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Color(0xFF2C9F6E), size: 20)
            else
              const Icon(Icons.circle_outlined, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }

  // Widget _buildExploreHeader() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 20),
  //     child: Column(
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   "Explore",
  //                   style: TextStyle(
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.black87,
  //                   ),
  //                 ),
  //                 Text(
  //                   "the best FDs",
  //                   style: TextStyle(
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.black87,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             Row(
  //               children: [
  //                 Text(
  //                   "Sr. citizen (60+)",
  //                   style: TextStyle(color: Colors.grey[700], fontSize: 14),
  //                 ),
  //                 const SizedBox(width: 8),
  //                 Switch(
  //                   value: isSrCitizen,
  //                   activeThumbColor: const Color(0xFF134044),
  //                   onChanged: (val) {
  //                     setState(() {
  //                       isSrCitizen = val;
  //                     });
  //                   },
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //         SizedBox(height: 8),
  //       ],
  //     ),
  //   );
  // }

  Map<String, dynamic> _getChartData() {
    return _chartData;
  }

  Widget _buildLineChart({Key? key}) {
    final chartData = _getChartData();
    final labels = List<String>.from(chartData['labels'] ?? []);
    final data = List<double>.from(chartData['data'] ?? []);
    final maxValue = (chartData['max'] as num?)?.toDouble() ?? 100.0;

    // Check if data is empty or all zeros
    final bool isEmpty = data.isEmpty || data.every((val) => val == 0);

    if (isEmpty) {
      return SizedBox(
        key: key,
        height: 200,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.bar_chart_rounded, size: 48, color: Colors.grey[300]),
              const SizedBox(height: 12),
              Text(
                "No leads for the chosen option",
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      key: key,
      height: 200,
      child: CustomPaint(
        painter: LineChartPainter(
          dataPoints: data,
          labels: labels,
          maxValue: maxValue,
        ),
        size: const Size(double.infinity, 200),
      ),
    );
  }

  Widget _buildFeaturesBar() {
    return Container(
      color: const Color(0xFF134044),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FeatureItem(
            icon: Icons.leaderboard,
            label: "Total Leads",
            value: _sTotalLeads.toString(),
            isLoading: _isLoadingSummary,
          ),
          SizedBox(
            height: 30,
            child: VerticalDivider(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
          ),
          FeatureItem(
            icon: Icons.check_circle_outline,
            label: "Qualified",
            value: _sQualifiedLeads.toString(),
            isLoading: _isLoadingSummary,
          ),
          SizedBox(
            height: 30,
            child: VerticalDivider(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
          ),
          FeatureItem(
            icon: Icons.cancel_outlined,
            label: "Unqualified",
            value: _sUnqualifiedLeads.toString(),
            isLoading: _isLoadingSummary,
          ),
        ],
      ),
    );
  }

  Widget _buildTableSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: Text(
            "Project List",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (_isLoadingStats)
          const Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: CircularProgressIndicator(color: Color(0xFF134044)),
            ),
          )
        else
          ProjectTableWidget(projectStats: _projectStats),
      ],
    );
  }

  Widget _buildFDCard({
    required String bankName,
    required String rate,
    required String tag,
    required IconData tagIcon,
    required String colorTheme, // green, blue, blue_light
    Color? tagColor,
  }) {
    Color bgColor;
    Color tColor;

    if (colorTheme == "green") {
      bgColor = const Color(0xFFE8F8F0);
      tColor = const Color(0xFF2C9F6E);
    } else {
      bgColor = const Color(0xFFEBF2FF);
      tColor = const Color(0xFF3B64B8);
    }

    if (tagColor != null) {
      tColor = tagColor;
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, bgColor.withOpacity(0.5), bgColor],
          stops: const [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              colorTheme == "green"
                  ? const Color(0xFF2C9F6E)
                  : Colors.blue.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            width: double.infinity,
            child: Row(
              children: [
                Icon(tagIcon, size: 12, color: tColor),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    tag,
                    style: TextStyle(
                      fontSize: 10,
                      color: tColor,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Up to",
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      rate,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const Text(
                      " p.a.",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 8,
                      backgroundColor: Color(0xFFE0E0E0),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        bankName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF134044),
                      minimumSize: Size.zero,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Invest now",
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showProjectBottomSheet() {
    final AuthService authService = Get.find<AuthService>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.45,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              children: [
                const SizedBox(height: 8),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Text(
                      "Select Project",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: Obx(() {
                      if (authService.projects.isEmpty) {
                        return const Center(child: Text("No projects found"));
                      }
                      return Column(
                        children: [
                          _buildProjectOption("All Projects", null, null),
                          ...authService.projects.map((project) {
                            return _buildProjectOption(
                              project['name'] ?? 'Unknown',
                              project['id'],
                              project['logoUrl'],
                            );
                          }),
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildProjectOption(String label, String? projectId, String? logoUrl) {
    bool isSelected = _selectedProjectName == label;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedProjectName = label;
          _selectedProjectId = projectId;
        });
        Navigator.pop(context);
        _fetchChartData();
        _fetchSummaryStats();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F8F0),
                borderRadius: BorderRadius.circular(8),
              ),
              child:
                  logoUrl != null && logoUrl.isNotEmpty
                      ? ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          logoUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.apartment,
                              color: Color(0xFF2C9F6E),
                              size: 20,
                            );
                          },
                        ),
                      )
                      : const Icon(
                        Icons.apartment,
                        color: Color(0xFF2C9F6E),
                        size: 20,
                      ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Color(0xFF2C9F6E), size: 20)
            else
              const Icon(Icons.circle_outlined, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }
}

class FeatureItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final bool isLoading;

  const FeatureItem({
    super.key,
    required this.icon,
    required this.label,
    this.value,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(height: 6),
        if (value != null) ...[
          isLoading
              ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
              : Text(
                value!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
          const SizedBox(height: 4),
        ],
        SizedBox(
          width: 80,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 10),
          ),
        ),
      ],
    );
  }
}

// Custom Painter for Line Chart with Smooth Curves and Gradient Fill
class LineChartPainter extends CustomPainter {
  final List<double> dataPoints;
  final List<String> labels;
  final double maxValue;

  LineChartPainter({
    required this.dataPoints,
    required this.labels,
    required this.maxValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (dataPoints.isEmpty) return;

    final paint =
        Paint()
          ..color = const Color(0xFFD4AF7A).withOpacity(0.8)
          ..strokeWidth = 2.5
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    final fillPaint =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFD4AF7A).withOpacity(0.3),
              const Color(0xFFD4AF7A).withOpacity(0.05),
            ],
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
          ..style = PaintingStyle.fill;

    final dotPaint =
        Paint()
          ..color = const Color(0xFFD4AF7A)
          ..style = PaintingStyle.fill;

    final innerDotPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

    final gridPaint =
        Paint()
          ..color = const Color(0xFFE0E0E0)
          ..strokeWidth = 0.5;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    // Calculate dimensions
    const padding = 40.0;
    const bottomPadding = 30.0;
    final chartWidth = size.width - padding * 2;
    final chartHeight = size.height - bottomPadding - 20;

    // Draw horizontal grid lines (Y-axis)
    final gridLineCount = 5;
    for (int i = 0; i <= gridLineCount; i++) {
      final y = 20 + (chartHeight / gridLineCount) * i;
      canvas.drawLine(
        Offset(padding, y),
        Offset(size.width - padding, y),
        gridPaint,
      );

      // Draw Y-axis labels
      final value = maxValue * (1 - i / gridLineCount);
      textPainter.text = TextSpan(
        text: ProjectStyle.formatCurrency(value),
        style: TextStyle(color: const Color(0xFF999999), fontSize: 10),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(padding - 30, y - textPainter.height / 2),
      );
    }

    // Create path for the line
    final path = Path();
    final fillPath = Path();
    final points = <Offset>[];

    for (int i = 0; i < dataPoints.length; i++) {
      final x = padding + (chartWidth / (dataPoints.length - 1)) * i;
      final normalizedValue = dataPoints[i] / maxValue;
      final y = 20 + chartHeight - (normalizedValue * chartHeight);
      points.add(Offset(x, y));

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height - bottomPadding);
        fillPath.lineTo(x, y);
      } else {
        // Create smooth curve using quadratic bezier
        final prevPoint = points[i - 1];
        final controlX = (prevPoint.dx + x) / 2;
        path.quadraticBezierTo(
          controlX,
          prevPoint.dy,
          controlX,
          (prevPoint.dy + y) / 2,
        );
        path.quadraticBezierTo(controlX, y, x, y);

        fillPath.quadraticBezierTo(
          controlX,
          prevPoint.dy,
          controlX,
          (prevPoint.dy + y) / 2,
        );
        fillPath.quadraticBezierTo(controlX, y, x, y);
      }

      // Draw X-axis labels
      textPainter.text = TextSpan(
        text: labels[i],
        style: TextStyle(color: const Color(0xFF999999), fontSize: 10),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, size.height - 20),
      );
    }

    // Complete fill path
    fillPath.lineTo(points.last.dx, size.height - bottomPadding);
    fillPath.close();

    // Draw gradient fill
    canvas.drawPath(fillPath, fillPaint);

    // Draw line
    canvas.drawPath(path, paint);

    // Draw dots at data points
    for (final point in points) {
      // Outer dot
      canvas.drawCircle(point, 5, dotPaint);
      // Inner white dot
      canvas.drawCircle(point, 3, innerDotPaint);
    }
  }

  @override
  bool shouldRepaint(LineChartPainter oldDelegate) {
    return oldDelegate.dataPoints != dataPoints ||
        oldDelegate.labels != labels ||
        oldDelegate.maxValue != maxValue;
  }
}
