import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/project_controller.dart';
import '../widgets/donut_chart.dart';
import '../widgets/document_item.dart';
import '../widgets/need_attention_item.dart';
import 'package:lottie/lottie.dart';
import '../widgets/transaction_item.dart';
import '../widgets/needs_attention_sheet.dart';

import '../utils/project_style.dart';

class ProjectDetailScreen extends StatefulWidget {
  const ProjectDetailScreen({super.key});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen>
    with SingleTickerProviderStateMixin {
  late final String projectName;
  late final dynamic unit;
  late final ProjectController _controller;

  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _sectionKeys = {
    'Unit Summary': GlobalKey(),
    'Needs Attention': GlobalKey(),
    'Category': GlobalKey(),
    'Documents': GlobalKey(),
    'Transactions': GlobalKey(),
    'Gallery': GlobalKey(),
    'Modification': GlobalKey(),
    'Help & Repair': GlobalKey(),
  };

  String _currentTab = 'Unit Summary';
  late final List<String> _tabs = _sectionKeys.keys.toList();
  double _headerOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    projectName = args['projectName'];
    unit = args['unit'];

    _controller = Get.put(
      ProjectController(projectName: projectName, unit: unit),
    );

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

    // Trigger opacity animation (approx value based on header height)
    if (offset > 50) {
      progress = (offset - 50) / 50;
      if (progress > 1.0) progress = 1.0;
    }

    if (progress != _headerOpacity) {
      setState(() {
        _headerOpacity = progress;
      });
    }

    // Scroll spy logic
    for (final tab in _tabs.reversed) {
      final key = _sectionKeys[tab]!;
      final context = key.currentContext;
      if (context != null) {
        final box = context.findRenderObject() as RenderBox;
        final offset = box.localToGlobal(Offset.zero);
        // "200" is an estimated offset for the tab bar/app bar height
        if (offset.dy <= 180) {
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
        alignment: 0.15, // Offset slightly to account for tab bar
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProjectStyle.backgroundColor,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // 1. Sliver App Bar
          SliverAppBar(
            expandedHeight: 0, // Standard height, not expanded
            pinned: true,
            elevation: 0,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
            backgroundColor: ProjectStyle.appbarbackgroundColor,
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
              child: Container(
                color: ProjectStyle.appbarbackgroundColor,
                padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Test Project', style: ProjectStyle.titleText),
                    Text('Test Project - 131', style: ProjectStyle.bodyText),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.favorite_border,
                  color: ProjectStyle.iconColor,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(
                  Icons.share_outlined,
                  color: ProjectStyle.iconColor,
                ),
                onPressed: () {},
              ),
            ],
          ),

          // 2. Tab Bar Header
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              minHeight: 40 * _headerOpacity,
              maxHeight: 40 * _headerOpacity,
              progress: _headerOpacity,
              child: Container(
                color: ProjectStyle.appbarbackgroundColor,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _tabs.length,
                  itemBuilder: (context, index) {
                    final tab = _tabs[index];
                    final isSelected = _currentTab == tab;
                    return GestureDetector(
                      onTap: () => _scrollToSection(tab),
                      child: Container(
                        margin: const EdgeInsets.only(right: 24),
                        padding: const EdgeInsets.only(bottom: 0),
                        alignment: Alignment.center,
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
                          tab.toUpperCase(),
                          style: TextStyle(
                            fontFamily: ProjectStyle.fontFamily,
                            fontSize: 12,
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.w500,
                            color:
                                isSelected
                                    ? ProjectStyle.primaryTextColor
                                    : Colors.grey[600],
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // 3. Content List
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: ProjectStyle.pagePadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(key: _sectionKeys['Unit Summary']),
                    _buildUnitSummary(),
                    const SizedBox(height: ProjectStyle.sectionSpacing),
                    const DottedSeparator(
                      color: ProjectStyle.secondaryTextColor,
                    ),
                    const SizedBox(height: ProjectStyle.sectionSpacing),

                    SizedBox(key: _sectionKeys['Needs Attention']),
                    _buildNeedsAttentionSection(),
                    const SizedBox(height: ProjectStyle.sectionSpacing),
                    // const DottedSeparator(
                    //   color: ProjectStyle.secondaryTextColor,
                    // ),
                    const SizedBox(height: 6),

                    SizedBox(key: _sectionKeys['Category']),
                    _buildCategory(),
                    const SizedBox(height: ProjectStyle.sectionSpacing),
                    // const DottedSeparator(
                    //   color: ProjectStyle.secondaryTextColor,
                    // ),
                    const SizedBox(height: ProjectStyle.sectionSpacing),

                    SizedBox(key: _sectionKeys['Documents']),
                    _buildDocumentsSection(),
                    const SizedBox(height: 0),

                    // const DottedSeparator(
                    //   color: ProjectStyle.secondaryTextColor,
                    // ),
                    SizedBox(key: _sectionKeys['Transactions']),
                    _buildTransactionsSection(),
                    const SizedBox(height: ProjectStyle.sectionSpacing),

                    //const SizedBox(height: ProjectStyle.sectionSpacing),
                    SizedBox(key: _sectionKeys['Gallery']),
                    _buildGallerySection(),
                    const SizedBox(height: ProjectStyle.sectionSpacing),
                    const SizedBox(height: ProjectStyle.sectionSpacing),
                    const DottedSeparator(
                      color: ProjectStyle.secondaryTextColor,
                    ),
                    const SizedBox(height: ProjectStyle.sectionSpacing),
                    SizedBox(key: _sectionKeys['Modification']),
                    _buildModificationSection(),
                    const SizedBox(height: 4),

                    SizedBox(key: _sectionKeys['Help & Repair']),
                    _buildHelpRepairSection(),
                    SizedBox(
                      height: 24 + MediaQuery.of(context).padding.bottom,
                    ), // Bottom padding
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildUnitSummary() {
    RxInt selectedTab = 0.obs;
    final ProjectController controller = Get.find<ProjectController>();

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Text('UNIT SUMMARY', style: ProjectStyle.sectionHeaderText),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTab('Stage Balance', 0, selectedTab),
              _buildTab('Unit Cost', 1, selectedTab),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: ProjectStyle.surfaceColor,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(ProjectStyle.pagePadding),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child:
                  selectedTab.value == 0
                      ? KeyedSubtree(
                        key: const ValueKey(0),
                        child: _buildStageBalance(controller),
                      )
                      : KeyedSubtree(
                        key: const ValueKey(1),
                        child: _buildUnitCost(controller),
                      ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String text, int index, RxInt selectedTab) {
    bool isSelected = selectedTab.value == index;

    return GestureDetector(
      onTap: () => selectedTab.value = index,
      child: Container(
        margin: const EdgeInsets.only(right: 24),
        padding: const EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
          border:
              isSelected
                  ? const Border(
                    bottom: BorderSide(color: Colors.black, width: 2),
                  )
                  : null,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: ProjectStyle.fontFamily,
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color:
                isSelected ? ProjectStyle.primaryTextColor : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildStageBalance(ProjectController controller) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          Positioned(
            left: 30,
            top: 30,
            child: DonutChart(
              paid: controller.paidAmount.value,
              total: controller.totalAmount.value,
              size: 80,
              paidColor: ProjectStyle.accentColor,
              eligibleColor: Colors.grey[300]!,
            ),
          ),
          Positioned(
            right: 1,
            top: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAmountRow(
                  'Eligible Cost',
                  "₹ ${ProjectStyle.formatCurrency(controller.totalAmount.value)}",
                  Colors.grey[700]!,
                  isDotted: true,
                ),
                const SizedBox(height: 16),
                _buildAmountRow(
                  'Paid',
                  "₹ ${ProjectStyle.formatCurrency(controller.paidAmount.value)}",
                  ProjectStyle.accentColor,
                  isDotted: true,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 20,
            child: Row(
              children: [
                _buildLegendItem(ProjectStyle.accentColor, 'Paid'),
                const SizedBox(width: 24),
                _buildLegendItem(Colors.grey[300]!, 'Balance'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 8),
        Text(label, style: ProjectStyle.bodyText),
      ],
    );
  }

  Widget _buildUnitCost(ProjectController controller) {
    return const Center(
      child: Text(
        'Unit Cost Details Coming Soon!',
        style: ProjectStyle.bodyText,
      ),
    );
  }

  Widget _buildAmountRow(
    String label,
    String value,
    Color color, {
    bool isDotted = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isDotted)
            DottedUnderlineText(
              text: label,
              style: ProjectStyle.bodyText.copyWith(
                fontWeight: FontWeight.w500,
              ),
              underlineColor: Colors.grey,
            )
          else
            Text(
              label,
              style: ProjectStyle.bodyText.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          const SizedBox(height: 4),
          Text(value, style: ProjectStyle.titleText),
        ],
      ),
    );
  }

  Widget _buildNeedsAttentionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('NEEDS ATTENTION', style: ProjectStyle.sectionHeaderText),
        const SizedBox(height: 10),
        Obx(
          () =>
              _controller.isLoadingDemands.value
                  ? Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Center(
                      child: Lottie.asset(
                        'assets/Loading Dots Blue.json',
                        height: 100,
                        width: 100,
                      ),
                    ),
                  )
                  : Column(
                    children: [
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:
                            _controller.attentionItems.length > 2
                                ? 2
                                : _controller.attentionItems.length,
                        itemBuilder:
                            (context, index) => NeedsAttentionItem(
                              unit: _controller.attentionItems[index],
                              index: index,
                              onPayNow: () {
                                Get.bottomSheet(
                                  NeedsAttentionSheet(
                                    items: _controller.attentionItems.toList(),
                                  ),
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                );
                              },
                            ),
                      ),
                      // Adjust spacing above the button here
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          Get.bottomSheet(
                            NeedsAttentionSheet(
                              items: _controller.attentionItems.toList(),
                            ),
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'View all',
                            style: TextStyle(
                              fontFamily: ProjectStyle.fontFamily,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: ProjectStyle.primaryTextColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
        ),
        // Adjust spacing below the button here
        const SizedBox(height: 6),
      ],
    );
  }

  Widget _buildCategory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('CATEGORY', style: ProjectStyle.sectionHeaderText),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildCategoryItem(Icons.receipt_long_outlined, "Cost Sheet", () {
              Get.toNamed('/cost-sheet');
            }),
            _buildCategoryItem(Icons.schedule_outlined, "Schedule", () {
              Get.toNamed('/payment-schedule');
            }),
            _buildCategoryItem(Icons.list_outlined, "Activity", () {
              Get.toNamed('/activity-log');
            }),
            _buildCategoryItem(Icons.build_outlined, "Modifications", () {
              Get.toNamed('/modification');
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryItem(IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: ProjectStyle.surfaceColor,
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 28,
                  color: const Color.fromARGB(255, 79, 70, 70),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: ProjectStyle.bodyText.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGallerySection() {
    final List<String> images = [
      'https://maahomes.in/media/LANDING-PAGE-landscape_yCQHN7l.png',
      'https://maahomes.in/media/bel-3_QElfrCg.jpg',
      'https://maahomes.in/media/WhatsApp_Image_2024-06-01_at_6.32.47_PM.jpeg',
      'https://maahomes.in/media/1383X446px_Panchajanyaa_Maahomes-web-banner.png',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('GALLERY', style: ProjectStyle.sectionHeaderText),
        const SizedBox(height: 10),
        SizedBox(
          height: 140,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return Container(
                width: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(images[index]),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildModificationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('MODIFICATION', style: ProjectStyle.sectionHeaderText),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(ProjectStyle.internalPadding),
          color: Colors.transparent,
          child: Row(
            children: [
              const Icon(
                Icons.build_outlined,
                size: 32,
                color: Color.fromARGB(255, 79, 70, 70),
              ),
              const SizedBox(width: ProjectStyle.gapMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Need to modify your home?',
                      style: ProjectStyle.titleText,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Modify home's layout, interiors or features effortlessly.",
                      style: ProjectStyle.bodyText.copyWith(
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Get.toNamed('/modification'),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHelpRepairSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('HELP & REPAIR', style: ProjectStyle.sectionHeaderText),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(ProjectStyle.internalPadding),
          color: Colors.transparent,
          child: Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage('assets/profile.jpeg'),
              ),
              const SizedBox(width: ProjectStyle.gapMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Hanif', style: ProjectStyle.titleText),
                    SizedBox(height: 4),
                    Text('CRM Executive', style: ProjectStyle.bodyText),
                    SizedBox(height: 4),
                    Text('+91 9768562601', style: ProjectStyle.bodyText),
                  ],
                ),
              ),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: ProjectStyle.surfaceColor,
                  border: Border.all(color: Colors.black),
                ),
                child: TextButton(
                  onPressed: () => Get.toNamed('/contact'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Contact',
                    style: TextStyle(
                      fontFamily: ProjectStyle.fontFamily,
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('DOCUMENTS', style: ProjectStyle.sectionHeaderText),
        const SizedBox(height: 10),
        Obx(
          () => ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _controller.documents.length,
            itemBuilder:
                (context, index) => DocumentItem(
                  document: _controller.documents[index],
                  screenWidth: MediaQuery.of(context).size.width,
                ),
          ),
        ),
        // Adjust spacing above the button here
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () {},
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: const Text(
              'View all',
              style: TextStyle(
                fontFamily: ProjectStyle.fontFamily,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: ProjectStyle.primaryTextColor,
              ),
            ),
          ),
        ),
        // Adjust spacing below the button here
        const SizedBox(height: 6),
      ],
    );
  }

  Widget _buildTransactionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 17),
        const Text(
          'RECENT TRANSACTIONS',
          style: ProjectStyle.sectionHeaderText,
        ),
        const SizedBox(height: 10),
        Obx(() {
          if (_controller.isLoadingTransactions.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_controller.transactions.isEmpty) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: ProjectStyle.surfaceColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Center(
                child: Text(
                  "No transactions found",
                  style: ProjectStyle.bodyText,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _controller.transactions.length,
            itemBuilder: (context, index) {
              return TransactionItem(
                transaction: _controller.transactions[index],
                index: index,
              );
            },
          );
        }),
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
    return Opacity(
      opacity: progress,
      child: Transform.translate(
        offset: Offset(0, -40 * (1 - progress)),
        child: child,
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return progress != oldDelegate.progress || child != oldDelegate.child;
  }
}
