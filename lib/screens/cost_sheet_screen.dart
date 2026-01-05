import 'package:customerapp/controllers/project_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/cost_item_model.dart';
import '../models/quick_action_model.dart';
import '../widgets/quick_actions_section.dart';
import '../utils/project_style.dart';

class CostSheetScreen extends StatefulWidget {
  const CostSheetScreen({super.key});

  @override
  State<CostSheetScreen> createState() => _CostSheetScreenState();
}

class _CostSheetScreenState extends State<CostSheetScreen>
    with SingleTickerProviderStateMixin {
  // final CostSheetController _controller = Get.put(CostSheetController()); // Unused
  final ProjectController projectController = Get.find<ProjectController>();
  final ScrollController _scrollController = ScrollController();

  final Map<String, GlobalKey> _sectionKeys = {
    'Summary': GlobalKey(),
    'Charges': GlobalKey(),
    'Add. Charges': GlobalKey(),
    'Construction': GlobalKey(),
    'Cons. Add.': GlobalKey(),
    'Possession': GlobalKey(),
    'Schedule': GlobalKey(),
    'Actions': GlobalKey(),
  };

  late List<String> _tabs;
  String _currentTab = 'Summary';
  double _headerOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _tabs = _sectionKeys.keys.toList();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    double offset = _scrollController.offset;
    double progress = 0.0;

    if (offset > 150) {
      progress = (offset - 150) / 50;
      if (progress > 1.0) progress = 1.0;
    }

    if (progress != _headerOpacity) {
      setState(() {
        _headerOpacity = progress;
      });
    }

    for (final tab in _tabs.reversed) {
      final key = _sectionKeys[tab]!;
      final context = key.currentContext;
      if (context != null) {
        final box = context.findRenderObject() as RenderBox;
        final offset = box.localToGlobal(Offset.zero);
        if (offset.dy <= 200) {
          if (_currentTab != tab) {
            setState(() {
              _currentTab = tab;
            });
          }
          break;
        }
      }
    }
  }

  void _scrollToSection(String tab) {
    setState(() {
      _currentTab = tab;
    });
    final key = _sectionKeys[tab]!;
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.1,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: ProjectStyle.backgroundColor,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            pinned: true,
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: ProjectStyle.appbarbackgroundColor,
            toolbarHeight: 56,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_outlined,
                color: ProjectStyle.iconColor,
              ),
              onPressed: () => Get.back(),
            ),
            titleSpacing: 0,
            title: Transform.translate(
              offset: const Offset(-8, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Cost Sheet', style: ProjectStyle.titleText),
                  const SizedBox(
                    height: 2,
                  ), // Spacing between title and subtitle
                  Text(
                    'Test Project - 131',
                    style: ProjectStyle.smallText.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),
            // This eliminates the bottom padding of the AppBar
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(-6),
              child: const SizedBox(),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              minHeight: 30,
              maxHeight: 30,
              progress: 1.0,
              child: Container(
                color: ProjectStyle.appbarbackgroundColor,
                alignment: Alignment.bottomLeft,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 0,
                  ),
                  itemCount: _tabs.length,
                  itemBuilder: (context, index) {
                    final tab = _tabs[index];
                    final isSelected = _currentTab == tab;
                    return GestureDetector(
                      onTap: () => _scrollToSection(tab),
                      child: Container(
                        margin: const EdgeInsets.only(right: 24),
                        padding: const EdgeInsets.only(bottom: 4.0),
                        alignment: Alignment.bottomCenter,
                        decoration: BoxDecoration(
                          border:
                              isSelected
                                  ? const Border(
                                    bottom: BorderSide(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  )
                                  : null,
                        ),
                        child: Text(
                          tab,
                          style: TextStyle(
                            fontFamily: ProjectStyle.fontFamily,
                            fontSize: 16,
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.w500,
                            color:
                                isSelected
                                    ? ProjectStyle.primaryTextColor
                                    : Colors.grey[600],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                ProjectStyle.pagePadding, // left
                8, // top - reduced from ProjectStyle.pagePadding (16)
                ProjectStyle.pagePadding, // right
                ProjectStyle.pagePadding +
                    MediaQuery.of(context).padding.bottom, // bottom
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    key: _sectionKeys['Summary'],
                    child: _buildTotalUnitCost(screenWidth, screenHeight),
                  ),
                  _buildSection(
                    context,
                    'Charges',
                    projectController.charges,
                    screenWidth,
                    screenHeight,
                    projectController.tA.value,
                    _sectionKeys['Charges']!,
                  ),
                  _buildSection(
                    context,
                    'Additional Charges',
                    projectController.additionalCharges,
                    screenWidth,
                    screenHeight,
                    projectController.tB.value,
                    _sectionKeys['Add. Charges']!,
                  ),
                  _buildSection(
                    context,
                    'Construction Charges',
                    projectController.constructionCharges,
                    screenWidth,
                    screenHeight,
                    projectController.tC.value,
                    _sectionKeys['Construction']!,
                  ),
                  _buildSection(
                    context,
                    'Construction Additional Charges',
                    projectController.constructionAdditionalCharges,
                    screenWidth,
                    screenHeight,
                    projectController.tD.value,
                    _sectionKeys['Cons. Add.']!,
                  ),
                  _buildSection(
                    context,
                    'Possession Charges',
                    projectController.possessionCharges,
                    screenWidth,
                    screenHeight,
                    projectController.tE.value,
                    _sectionKeys['Possession']!,
                  ),
                  Container(
                    key: _sectionKeys['Schedule'],
                    child: _buildPaymentScheduleCard(
                      context,
                      screenWidth,
                      screenHeight,
                    ),
                  ),
                  Container(
                    key: _sectionKeys['Actions'],
                    child: _buildQuickActionsSection(screenWidth, screenHeight),
                  ),
                  const SizedBox(height: 24), // Reduced bottom padding
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalUnitCost(double screenWidth, double screenHeight) {
    return InkWell(
      onTap: () => _showSummaryDetails(context, screenHeight),
      child: Container(
        padding: const EdgeInsets.all(0),
        margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.hardEdge,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 20,
                color: Colors.black,
                alignment: Alignment.center,
                child: const RotatedBox(
                  quarterTurns: 3,
                  child: Text(
                    "SUMMARY",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      letterSpacing: 1.1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 2),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            "Total Paid",
                            style: ProjectStyle.smallText.copyWith(
                              fontSize: 18,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.check_circle_outline,
                            color: Colors.green,
                            size: 20,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Obx(
                        () => Text(
                          "₹ ${_formatCurrency(projectController.paidAmount.value)}",
                          style: ProjectStyle.headlineText.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      DottedSeparator(color: Colors.grey),

                      const SizedBox(height: 3),
                      Text(
                        "Tap to view Unit Cost & Due",
                        style: ProjectStyle.smallText.copyWith(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(width: 1, color: Colors.grey[300]),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: const [
                    Text(
                      "View details",
                      style: TextStyle(
                        fontFamily: ProjectStyle.fontFamily,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(Icons.chevron_right, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSummaryDetails(BuildContext context, double screenHeight) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(ProjectStyle.pagePadding),
          decoration: const BoxDecoration(
            color: ProjectStyle.surfaceColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Cost Summary",
                style: ProjectStyle.headlineText.copyWith(fontSize: 20),
              ),
              const SizedBox(height: ProjectStyle.gapLarge),
              Obx(
                () => _buildDetailRow(
                  "Paid Amount",
                  "₹ ${_formatCurrency(projectController.paidAmount.value)}",
                  isBold: true,
                ),
              ),
              const SizedBox(height: ProjectStyle.gapMedium),
              Obx(
                () => _buildDetailRow(
                  "Unit Cost",
                  "₹ ${_formatCurrency(projectController.unitCost.value)}",
                ),
              ),
              const SizedBox(height: ProjectStyle.gapLarge),
              DottedSeparator(color: ProjectStyle.secondaryTextColor),
              const SizedBox(height: ProjectStyle.gapLarge),
              Obx(
                () => _buildDetailRow(
                  "Total Due",
                  "₹ ${_formatCurrency(projectController.totalDue.value)}",
                  isBold: true,
                ),
              ),
              const SizedBox(height: ProjectStyle.gapLarge),
            ],
          ),
        );
      },
    );
  }

  String _formatCurrency(double amount) {
    return ProjectStyle.formatCurrency(amount);
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<CostItem> items,
    double screenWidth,
    double screenHeight,
    double total,
    GlobalKey key,
  ) {
    bool showDetailed = items.isNotEmpty && items.first.rate.isNotEmpty;

    if (items.isEmpty) {
      return Container(
        key: key,
        margin: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
        // padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
              child: Text(title, style: ProjectStyle.sectionHeaderText),
            ),
            Container(
              padding: EdgeInsets.all(ProjectStyle.pagePadding),
              decoration: BoxDecoration(
                color: ProjectStyle.surfaceColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total ',
                    style: ProjectStyle.headlineText.copyWith(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    "₹ ${_formatCurrency(total)}",
                    style: ProjectStyle.headlineText.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ProjectStyle.primaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      key: key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
            child: Text(title, style: ProjectStyle.sectionHeaderText),
          ),
          Container(
            decoration: BoxDecoration(
              color: ProjectStyle.surfaceColor,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.02),
            child: Column(
              children: [
                ...items.map(
                  (item) =>
                      showDetailed
                          ? _buildClickableCostItem(
                            context,
                            item,
                            screenWidth,
                            screenHeight,
                          )
                          : _buildCostItem(item, screenWidth, screenHeight),
                ),
                if (items.isNotEmpty) DottedSeparator(color: Colors.grey),
                _buildTotalRow(screenWidth, screenHeight, total),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClickableCostItem(
    BuildContext context,
    CostItem item,
    double screenWidth,
    double screenHeight,
  ) {
    return InkWell(
      onTap: () => _showCostDetails(context, item, screenHeight),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  item.description,
                  style: ProjectStyle.smallText.copyWith(fontSize: 14),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: ProjectStyle.accentColor,
                ),
              ],
            ),
            Text(
              item.amount,
              style: ProjectStyle.smallText.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCostDetails(
    BuildContext context,
    CostItem item,
    double screenHeight,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Allow it to take up more space and be scrollable
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
      ),
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: ProjectStyle.surfaceColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              // Dragger Handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(ProjectStyle.pagePadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.description,
                        style: ProjectStyle.headlineText.copyWith(fontSize: 25),
                      ),
                      SizedBox(height: ProjectStyle.gapLarge),
                      _buildDetailRow("Rate", item.rate),
                      if (item.unit.isNotEmpty) ...[
                        SizedBox(height: ProjectStyle.gapMedium),
                        _buildDetailRow("Unit", item.unit),
                      ],
                      SizedBox(height: ProjectStyle.gapMedium),
                      _buildDetailRow("Sale Value", item.saleValue),
                      if (item.gstPercentage.isNotEmpty) ...[
                        SizedBox(height: ProjectStyle.gapMedium),
                        _buildDetailRow("GST %", "${item.gstPercentage}%"),
                      ],
                      SizedBox(height: ProjectStyle.gapMedium),
                      _buildDetailRow("GST Amount", item.gst),
                      SizedBox(height: ProjectStyle.gapLarge),
                      DottedSeparator(color: Colors.grey),
                      SizedBox(height: ProjectStyle.gapMedium),
                      _buildDetailRow("Total", item.amount, isBold: true),
                      SizedBox(height: ProjectStyle.gapLarge),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: ProjectStyle.bodyText.copyWith(
            color:
                isBold
                    ? ProjectStyle.primaryTextColor
                    : ProjectStyle.secondaryTextColor,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: ProjectStyle.bodyText.copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            fontSize: isBold ? 16 : 14,
          ),
        ),
      ],
    );
  }

  Widget _buildCostItem(
    CostItem item,
    double screenWidth,
    double screenHeight,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.description,
                style: TextStyle(
                  fontSize: screenHeight * 0.018,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              if (item.details.isNotEmpty)
                Text(
                  item.details,
                  style: TextStyle(
                    fontSize: screenHeight * 0.016,
                    color: Colors.black,
                  ),
                ),
            ],
          ),
          Text(
            item.amount,
            style: TextStyle(
              fontSize: screenHeight * 0.018,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(double screenWidth, double screenHeight, double total) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total',
            style: TextStyle(
              fontSize: screenHeight * 0.018,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "₹ ${ProjectStyle.formatCurrency(total)}",
            style: TextStyle(
              fontSize: screenHeight * 0.018,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentScheduleCard(
    BuildContext context,
    double screenWidth,
    double screenHeight,
  ) {
    return Card(
      color: ProjectStyle.surfaceColor,
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 0,
      child: InkWell(
        onTap: () => Get.toNamed('/payment-schedule'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(screenHeight * 0.02),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment Schedule',
                    style: ProjectStyle.headlineText.copyWith(
                      fontSize: screenHeight * 0.02,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'View detailed payment timeline',
                    style: ProjectStyle.bodyText.copyWith(
                      color: Colors.grey,
                      fontSize: screenHeight * 0.016,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: screenHeight * 0.02,
                color: ProjectStyle.primaryTextColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionsSection(double screenWidth, double screenHeight) {
    return QuickActionsSection(
      actions: [
        QuickActionModel(
          title: 'Payment Schedule',
          description: 'View your payment timeline',
        ),
        QuickActionModel(
          title: 'Activity Log',
          description: 'Track project updates',
        ),
        QuickActionModel(
          title: 'Make Payment',
          description: 'Pay your dues securely',
        ),
        QuickActionModel(
          title: 'Modifications',
          description: 'Request modification',
        ),
      ],
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
    required this.progress,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;
  final double progress;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: progress),
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      builder: (context, value, _) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, -40 * (1 - value)),
            child: child,
          ),
        );
      },
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return progress != oldDelegate.progress || child != oldDelegate.child;
  }
}
