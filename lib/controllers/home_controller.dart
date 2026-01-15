import 'package:get/get.dart';

class HomeController extends GetxController {
  final summaryData =
      <Map<String, String>>[
        {'value': '1', 'label': 'Total Units'},
        {'value': '₹ 0', 'label': 'Total Due'},
        {'value': '₹ 0', 'label': 'Total Paid'},
      ].obs;

  var selectedIndex = 0.obs;

  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    _fetchUnitData();
  }

  void _fetchUnitData() {
    // FirebaseFirestore.instance
    //     .doc('/spark_units/NQ1GGynwiDg58BD1kKPv')
    //     .snapshots()
    //     .listen((snapshot) {
    //       if (snapshot.exists) {
    //         final data = snapshot.data();
    //         if (data != null) {
    //           double tBalance = _safeParseDouble(data['T_elgible_balance']);
    //           double tReview = _safeParseDouble(data['T_review']);
    //           double tApproved = _safeParseDouble(data['T_approved']);
    //           double totalPaid = tReview + tApproved;

    //           summaryData[0] = {'value': '1', 'label': 'Total Units'};
    //           summaryData[1] = {
    //             'value': '₹ ${ProjectStyle.formatCurrency(tBalance)}',
    //             'label': 'Total Due',
    //           };
    //           summaryData[2] = {
    //             'value': '₹ ${ProjectStyle.formatCurrency(totalPaid)}',
    //             'label': 'Total Paid',
    //           };
    //         }
    //       }
    //     });

    // Mock Data
    summaryData[0] = {'value': '1', 'label': 'Total Units'};
    summaryData[1] = {'value': '₹ 10,00,000', 'label': 'Total Due'};
    summaryData[2] = {'value': '₹ 2,50,000', 'label': 'Total Paid'};
  }

  final stories = [
    {
      'title': 'Shuba Elan',
      'thumbnail': 'assets/t1.png', // Replace with video thumbnail if available
      'videoUrl':
          'assets/videos/property_tour.mp4', // Use actual video assets or URLs
      'address': 'Chikbalapur, Karnataka',
    },
    {
      'title': 'Shuba Eco Stone',
      'thumbnail': 'assets/t2.png',
      'videoUrl': 'assets/videos/property_tour_2.mp4',
      'address': 'Bangalore, Karnataka',
    },
    {
      'title': 'Sunday Hotel',
      'thumbnail': 'assets/t3.png',
      'videoUrl': 'assets/videos/property_tour_3.mp4',
      'address': 'Vadodara, Gujarat',
    },
  ];

  final balance = 750000.0.obs;
  final paid = 250000.0.obs;
  final total = 1000000.0.obs;

  // Needs Attention
  final outstandingAmount = 132000.0.obs;
  final dueDays = 3.obs;

  // Recent Transactions
  // final transactions = <TransactionModel>[
  //   TransactionModel(
  //     name: 'Plastering',
  //     amount: 1000000,
  //     type: 'Agreement',
  //     project: 'Shuba Ecovillony'
  //   ),
  // ].obs;

  // Facilities
  // final facilities = <FacilityModel>[
  //   FacilityModel(name: 'Agreement', description: 'Shuba Ecovillony'),
  // ].obs;

  // // Quick Actions
  // final quickActions = <QuickActionModel>[
  //   QuickActionModel(title: 'Civil sliver', description: 'Modification request'),
  // ].obs;
}
