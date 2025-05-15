import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/project_controller.dart';
import '../widgets/dimension_graph_chart.dart';
import '../widgets/donut_chart.dart';
// import '../widgets/dimension_diagram.dart';
import '../widgets/document_item.dart';
import '../widgets/need_attention_item.dart';
import '../widgets/transaction_item.dart';
import '../widgets/quick_action_item.dart';
import '../utils/responsive.dart';

class ProjectDetailScreen extends StatefulWidget {
  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  late final String projectName;
  late final dynamic unit;
  late final ProjectController _controller;




  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    projectName = args['projectName'];
    unit = args['unit'];


    _controller = Get.put(ProjectController(projectName: projectName, unit: unit));
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;


    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(screenWidth),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Responsive.getPadding(screenWidth).horizontal*0.4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUnitSummary(screenWidth),
            SizedBox(height: screenHeight * 0.03),

              _buildNeedsAttentionSection(screenWidth, screenHeight),

            _buildCategory(screenWidth, screenHeight),
            SizedBox(height: screenHeight * 0.03),

            //_buildUnitDimensions(screenWidth, screenHeight),
            SizedBox(height: screenHeight * 0.03),
            _buildModificationSection(screenWidth),
            SizedBox(height: screenHeight * 0.03),
            _buildHelpRepairSection(screenWidth),
            SizedBox(height: screenHeight * 0.03),
            _buildDocumentsSection(screenWidth),
            // SizedBox(height: screenHeight * 0.03),
            _buildTransactionsSection(screenWidth),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(double screenWidth) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Shuba Ecostone',
              style: TextStyle(
                fontSize: Responsive.getFontSize(screenWidth, 20,), fontWeight: FontWeight.bold,
              )),
          Text('Shuba Ecostone - 131',
              style: TextStyle(
                fontSize: Responsive.getFontSize(screenWidth, 14),
              )),
        ],
      ),
    );
  }

Widget _buildUnitSummary(double screenWidth) {
  RxInt selectedTab = 0.obs; // 0 = Stage Balance, 1 = Unit Cost
  final ProjectController _controller = Get.find<ProjectController>();

  return Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heading
          Text(
            'UNIT SUMMARY',
            style: TextStyle(
              fontSize: Responsive.getFontSize(screenWidth, 14),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: screenWidth * 0.03),

          // Center-Aligned Tab Switcher
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTab('Stage Balance', 0, selectedTab, screenWidth),
                _buildTab('Unit Cost', 1, selectedTab, screenWidth),
              ],
            ),
          ),
          SizedBox(height: screenWidth * 0.04),

          // Content Card
          Container(
  padding: EdgeInsets.all(screenWidth * 0.04),
  decoration: BoxDecoration(
    color: Colors.white, // Changed from Colors.grey[200] to Colors.white
    borderRadius: BorderRadius.zero, // Sharp corners
  ),
  child: selectedTab.value == 0
      ? _buildStageBalance(screenWidth, _controller)
      : _buildUnitCost(screenWidth, _controller),
),
        ],
      ));
}

// Center-Aligned Tab Widget
Widget _buildTab(String text, int index, RxInt selectedTab, double screenWidth) {
  bool isSelected = selectedTab.value == index;

  return GestureDetector(
    onTap: () {
      selectedTab.value = index;
    },
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenWidth * 0.015),
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: isSelected
                  ? Responsive.getFontSize(screenWidth, 16) // Larger for selected
                  : Responsive.getFontSize(screenWidth, 14), // Smaller for unselected
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal, // No bold for unselected
              color: isSelected ? Colors.black : Colors.grey[600], // Black for selected, grey for unselected
            ),
          ),
          SizedBox(height: 3),
          Container(
            height: 2,
            width: screenWidth * 0.2,
            color: isSelected ? Colors.black : Colors.transparent, // Dark line for selected tab
          ),
        ],
      ),
    ),
  );
}

// Widget for Stage Balance
Widget _buildStageBalance(double screenWidth, ProjectController _controller) {
  return Column(
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Aligns donut and amounts properly
        children: [
          // Donut Chart (Eligible = Grey, Paid = Light Lavender)
          SizedBox(width: screenWidth * 0.08),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                DonutChart(
                  paid: _controller.paidAmount.value,
                  total: _controller.totalAmount.value,
                  size: screenWidth * 0.35,
                  paidColor: Colors.purple[300]!, // Paid section color
                  eligibleColor: Colors.grey[400]!, // Remaining section color

                ),
                SizedBox(height: screenWidth * 0.05), // Space below donut
              ],
            ),
          ),

          // Added space between Donut Chart and Amount Details
          SizedBox(width: screenWidth * 0.2),

          // Amount Details
          Expanded(
            flex: 3,
            child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAmountRow('Eligible Cost', '₹${_controller.totalAmount.value.round()}', Colors.grey[700]!),
                SizedBox(height: screenWidth * 0.02), // Space between rows
                _buildAmountRow('Paid', '₹${_controller.paidAmount.value.round()}', Colors.purple[300]!),
              ],
            ),
          ),
        ],
      ),


      // Legend (Color Indication) - Now Below the Donut
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildLegendItem(Colors.purple[300]!, 'Paid'),
          SizedBox(width: screenWidth * 0.06),
          _buildLegendItem(Colors.grey[400]!, 'Balance'),
        ],
      ),
    ],
  );
}

// Legend Item Widget
Widget _buildLegendItem(Color color, String label) {
  return Row(
    children: [
      Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.rectangle, // Changed from circle to square
          borderRadius: BorderRadius.circular(2), // Slightly rounded corners for aesthetics
        ),
      ),
      SizedBox(width: 8),
      Text(
        label,
        style: TextStyle(fontSize: 14),
      ),
    ],
  );
}

// Placeholder for Unit Cost section
Widget _buildUnitCost(double screenWidth, ProjectController _controller) {
  return Center(
    child: Text(
      'Unit Cost Details Coming Soon!',
      style: TextStyle(fontSize: Responsive.getFontSize(screenWidth, 16)),
    ),
  );
}

// Amount Row (Stacked Layout: Label above, Value below)
Widget _buildAmountRow(String label, String value, Color color) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500, // Slightly bold for emphasis
              ),
            ),

        SizedBox(height: 4), // Small spacing between label and value
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    ),
  );
}

Widget _buildNeedsAttentionSection(double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'NEEDS ATTENTION',
              style: TextStyle(
                fontSize: Responsive.getFontSize(screenWidth, 14),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: screenHeight * 0.01),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _controller.attentionItems.length,
          itemBuilder: (context, index) => NeedsAttentionItem(
            unit: _controller.attentionItems[index],
            index: index,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            //=> Get.toNamed('/needs-attention'),
            child: Text(
              'View all',
              style: TextStyle(
                fontSize: Responsive.getFontSize(screenWidth, 16),
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategory(double screenWidth, double screenHeight) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'CATEGORY',
        style: TextStyle(
          fontSize: Responsive.getFontSize(screenWidth, 14),
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: screenHeight * 0.02),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround, // Ensures equal spacing
        children: [
          _buildCategoryItem(
              screenWidth, screenHeight, Icons.receipt_long, "Cost Sheet", () {
            Get.toNamed('/cost-sheet');
          }),
          _buildCategoryItem(
              screenWidth, screenHeight, Icons.schedule, "Schedule", () {
            Get.toNamed('/payment-schedule');
          }),
          _buildCategoryItem(
              screenWidth, screenHeight, Icons.list, "Activity", () {
            Get.toNamed('/activity-log');
          }),
          _buildCategoryItem(
              screenWidth, screenHeight, Icons.build, "Modifications", () {
            Get.toNamed('/modification');
          }),
        ],
      ),
    ],
  );
}

Widget _buildCategoryItem(double screenWidth, double screenHeight,
    IconData icon, String label, VoidCallback onTap) {
  double iconSize = screenWidth * 0.08; // Responsive icon size
  double textSize = Responsive.getFontSize(screenWidth, 14);
  double containerSize = screenWidth * 0.15; // Responsive circle size

  return Expanded( // Ensures equal spacing for all items
    child: Column(
      children: [
        GestureDetector(
          onTap: onTap,

          child: Container(
            width: containerSize,
            height: containerSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                icon,
                size: iconSize,
                color: Colors.black,
              ),
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        Text(
          label,
          style: TextStyle(fontSize: textSize, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

  Widget _buildUnitDimensions(double screenWidth, double screenHeight) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'UNIT DETAILS AND DIMENSIONS',
        style: TextStyle(
          fontSize: Responsive.getFontSize(screenWidth, 14),
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: screenWidth * 0.03),
      Center(
        child: Container(
          height: screenHeight * 0.35, // Adjusted for better fit
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: DimensionGraph(screenWidth: screenWidth, screenHeight: screenHeight),
        ),
      ),
    ],
  );
}

  Widget _buildModificationSection(double screenWidth) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Heading
      Text(
        'Modification',
        style: TextStyle(
          fontSize: Responsive.getFontSize(screenWidth, 14),
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: screenWidth * 0.03),

      // Modification Card
      Container(
        padding: EdgeInsets.all(screenWidth * 0.04),
        decoration: BoxDecoration(
          color: Colors.white, // Background is white
        ),
        child: Row(
          children: [
            // Modification Icon (Black)
            Icon(
              Icons.build,
              size: screenWidth * 0.08,
              color: Colors.black, // Black icon
            ),
            SizedBox(width: screenWidth * 0.04),

            // Text Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Need to modify your home?',
                    style: TextStyle(
                      fontSize: Responsive.getFontSize(screenWidth, 16),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Modify home's layout, interiors or features effortlessly.",
                    style: TextStyle(
                      fontSize: Responsive.getFontSize(screenWidth, 14),
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),

            // Right Arrow (White arrow inside black circle)
            GestureDetector(
              onTap: () => Get.toNamed('/modification'),
              child: Container(
                width: screenWidth * 0.08,
                height: screenWidth * 0.08,
                decoration: BoxDecoration(
                  color: Colors.black, // Black circle
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: screenWidth * 0.05,
                    color: Colors.white, // White arrow
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

  Widget _buildHelpRepairSection(double screenWidth) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Heading
      Text(
        'Help & Repair',
        style: TextStyle(
          fontSize: Responsive.getFontSize(screenWidth, 14),
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: screenWidth * 0.03),

      // Profile Card
      Container(
        padding: EdgeInsets.all(screenWidth * 0.04),
        decoration: BoxDecoration(
          color: Colors.white, // White background
        ),
        child: Row(
          children: [
            // Profile Image (Reduced Radius)
            CircleAvatar(
              radius: screenWidth * 0.06, // Reduced size
              backgroundImage: AssetImage('assets/profile.jpeg'),
            ),
            SizedBox(width: screenWidth * 0.04),

            // Name, Position, and Number
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hanif',
                    style: TextStyle(
                      fontSize: Responsive.getFontSize(screenWidth, 16),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4), // Added space between lines
                  Text(
                    'CRM Executive',
                    style: TextStyle(
                      fontSize: Responsive.getFontSize(screenWidth, 14),
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 4), // Added space between lines
                  Text(
                    '+91 9768562601',
                    style: TextStyle(
                      fontSize: Responsive.getFontSize(screenWidth, 14),
                    ),
                  ),
                ],
              ),
            ),

            // Contact Button with White Background & Black Border
            Container(
              height: screenWidth*0.1,
              width: screenWidth*0.3,
              decoration: BoxDecoration(
                color: Colors.white, // White background
                border: Border.all(color: Colors.black), // Black border
                borderRadius: BorderRadius.circular(5), // Slightly rounded edges
              ),
              child: TextButton(
                onPressed: () => Get.toNamed('/contact'),
                child: Text(
                  'Contact',
                  style: TextStyle(
                    color: Colors.black, // Black text
                    fontSize: Responsive.getFontSize(screenWidth, 16),
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

  Widget _buildDocumentsSection(double screenWidth) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Title: DOCUMENTS
      Text(
        'DOCUMENTS',
        style: TextStyle(
          fontSize: Responsive.getFontSize(screenWidth, 14), // Increased font size slightly
          fontWeight: FontWeight.bold,
        ),
      ),

      SizedBox(height: screenWidth * 0.04), // Added space after heading

      // Documents List
      Obx(() => ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _controller.documents.length,
            itemBuilder: (context, index) => DocumentItem(
              document: _controller.documents[index],
              screenWidth: screenWidth,
            ),
          )),

      SizedBox(height: screenWidth * 0.03), // Responsive spacing

      // "View All" Button
      Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: (){},
              //Get.toNamed('/documents'),
          child: Text(
            'View all',
            style: TextStyle(
              fontSize: Responsive.getFontSize(screenWidth, 16),
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ),
    ],
  );
}

Widget _buildTransactionsSection(double screenWidth) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Title: RECENT TRANSACTIONS
      Text(
        'RECENT TRANSACTIONS',
        style: TextStyle(
          fontSize: Responsive.getFontSize(screenWidth, 14), // Increased for better visibility
          fontWeight: FontWeight.bold,
        ),
      ),

      SizedBox(height: screenWidth * 0.04), // Added space after heading

      // Transactions List
      Obx(() => ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _controller.transactions.length,
            itemBuilder: (context, index) => TransactionItem(
              transaction: _controller.transactions[index],
              screenWidth: screenWidth,
            ),
          )),

      SizedBox(height: screenWidth * 0.03), // Responsive spacing

      // "View All" Button
      Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () {},
              //Get.toNamed('/transactions'),
          child: Text(
            'View all',
            style: TextStyle(
              fontSize: Responsive.getFontSize(screenWidth, 16),
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ),
    ],
  );
}
}