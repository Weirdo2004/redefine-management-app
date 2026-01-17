import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

import 'package:get/get.dart';
import '../services/auth_service.dart';

class StatsFilterWidget extends StatefulWidget {
  final Function(DateTime start, DateTime end)? onDateChanged;
  final Function(String? projectId)? onProjectChanged;

  const StatsFilterWidget({
    super.key,
    this.onDateChanged,
    this.onProjectChanged,
  });

  @override
  State<StatsFilterWidget> createState() => _StatsFilterWidgetState();
}

class _StatsFilterWidgetState extends State<StatsFilterWidget> {
  String _selectedFilter = 'Today';
  String _dateRangeText = '';
  String _selectedProject = 'All Projects';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _applyFilter('Today');
    });
  }

  String _formatDate(DateTime date) {
    // Simple formatter: "10 Jan"
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return "${date.day} ${months[date.month - 1]}";
  }

  void _applyFilter(String filter) {
    if (widget.onDateChanged == null) return;

    if (filter == 'All Dates') {
      final start = DateTime(1970);
      final end = DateTime(2100);
      setState(() {
        _dateRangeText = "";
      });
      widget.onDateChanged!(start, end);
      return;
    }

    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    DateTime start;
    DateTime end;

    if (filter == 'Previous Day') {
      start = todayStart.subtract(const Duration(days: 1));
      end = start.add(const Duration(days: 1));
      setState(() {
        _dateRangeText = _formatDate(start);
      });
    } else if (filter == 'Last 7 Days') {
      start = todayStart.subtract(const Duration(days: 6));
      end = todayStart.add(const Duration(days: 1));
      setState(() {
        _dateRangeText = "${_formatDate(start)} - ${_formatDate(todayStart)}";
      });
    } else if (filter == 'Last 30 Days') {
      start = todayStart.subtract(const Duration(days: 29));
      end = todayStart.add(const Duration(days: 1));
      setState(() {
        _dateRangeText = "${_formatDate(start)} - ${_formatDate(todayStart)}";
      });
    } else if (filter == 'Last Month') {
      // Start of last month
      start = DateTime(now.year, now.month - 1, 1);
      // Start of this month (end of last month exclusive)
      end = DateTime(now.year, now.month, 1);
      final displayEnd = end.subtract(const Duration(days: 1));
      setState(() {
        _dateRangeText = "${_formatDate(start)} - ${_formatDate(displayEnd)}";
      });
    } else {
      // Default to Today
      start = todayStart;
      end = start.add(const Duration(days: 1));
      setState(() {
        _dateRangeText = ""; // Hidden for Today
      });
    }

    widget.onDateChanged!(start, end);
  }

  // ... (Project Bottom Sheet code remains same) ...

  void _showProjectBottomSheet(BuildContext context) {
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
                        return Column(
                          children: [
                            _buildProjectOption("All Projects", null, null),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Text(
                                "No ongoing projects found",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        );
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
    bool isSelected = _selectedProject == label;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedProject = label;
        });
        debugPrint("🔵 Selected Project: $label, ID: $projectId");
        if (widget.onProjectChanged != null) {
          widget.onProjectChanged!(projectId);
        }
        Navigator.pop(context);
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

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            height:
                MediaQuery.of(context).size.height * 0.60, // Increased height
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
                _buildCustomDateItem(),
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

  Widget _buildCustomDateItem() {
    bool isCustom =
        !_filterOptions.contains(_selectedFilter) &&
        _selectedFilter != "Custom Range";
    return InkWell(
      onTap: () async {
        Navigator.pop(context);
        final DateTimeRange? picked = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
          builder: (context, child) {
            return Theme(
              data: ThemeData.light().copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Color(0xFF2C9F6E),
                  onPrimary: Colors.white,
                  surface: Colors.white,
                  onSurface: Colors.black,
                ),
              ),
              child: child!,
            );
          },
        );

        if (picked != null) {
          final start = picked.start;
          final end = picked.end.add(
            const Duration(days: 1),
          ); // Include end date

          setState(() {
            _selectedFilter = "Custom Range";
            _dateRangeText =
                "${_formatDate(picked.start)} - ${_formatDate(picked.end)}";
          });

          if (widget.onDateChanged != null) {
            widget.onDateChanged!(start, end);
          }
        }
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
              child: const Icon(
                Icons.edit_calendar,
                color: Color(0xFF2C9F6E),
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                "Custom Range",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            if (isCustom)
              const Icon(Icons.check_circle, color: Color(0xFF2C9F6E), size: 20)
            else
              const Icon(Icons.circle_outlined, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }

  List<String> get _filterOptions => [
    'Today',
    'Previous Day',
    'Last 7 Days',
    'Last 30 Days',
    'Last Month',
    'All Dates',
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Project Filter
        Flexible(
          child: GestureDetector(
            onTap: () => _showProjectBottomSheet(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFF2C9F6E).withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      _selectedProject,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F1F1F),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Color(0xFF1F1F1F),
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Date Filter
        GestureDetector(
          onTap: () => _showFilterBottomSheet(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFF2C9F6E).withOpacity(0.2),
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
                    color: Color(0xFF1F1F1F),
                  ),
                ),
                if (_dateRangeText.isNotEmpty) ...[
                  const SizedBox(width: 6),
                  // Subtle Date Range text
                  Text(
                    "($_dateRangeText)",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF1F1F1F).withOpacity(0.6),
                    ),
                  ),
                ],
                const SizedBox(width: 4),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Color(0xFF1F1F1F),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
