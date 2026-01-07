import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customerapp/models/cost_item_model.dart';
import 'package:customerapp/models/document_model.dart';
import 'package:customerapp/models/payment_entry_model.dart';
import 'package:customerapp/models/quick_action_model.dart';
import 'package:customerapp/models/transaction_model.dart';
import '../models/unit_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/project_style.dart';
import '../utils/supabase_config.dart';

class ProjectController extends GetxController {
  final String projectName;
  final unit;
  ProjectController({required this.projectName, required this.unit});
  // Unit Summary
  final totalAmount = 0.0.obs;
  final paidAmount = 0.0.obs;
  final unitCost = 0.0.obs;
  final totalDue = 0.0.obs;
  final RxList<Map<String, dynamic>> paymentSchedule =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, String>> costSheetItems =
      <Map<String, String>>[].obs;

  final RxList<PaymentEntry> payments = <PaymentEntry>[].obs;
  final RxList<CostItem> charges = <CostItem>[].obs;
  final RxList<CostItem> additionalCharges = <CostItem>[].obs;
  final RxList<CostItem> constructionCharges = <CostItem>[].obs;
  final RxList<CostItem> constructionAdditionalCharges = <CostItem>[].obs;
  final RxList<CostItem> possessionCharges = <CostItem>[].obs;

  final RxDouble tA = 0.0.obs;
  final RxDouble tB = 0.0.obs;
  final RxDouble tC = 0.0.obs;
  final RxDouble tD = 0.0.obs;
  final RxDouble tE = 0.0.obs;

  final RxBool isLoadingDemands = true.obs;
  final RxBool isLoadingTransactions = false.obs;
  final RxList<UnitModel> attentionItems = <UnitModel>[].obs;

  void _parseTValues() {
    final data = unit.data() as Map<String, dynamic>?;
    if (data == null) return;

    // Fetch the values from projectData and set them, defaulting to 0.0 if not found
    tA.value = _safeParseDouble(data["T_A"]);
    tB.value = _safeParseDouble(data["T_B"]);
    tC.value = _safeParseDouble(data["T_C"]);
    tD.value = _safeParseDouble(data["T_D"]);
    tE.value = _safeParseDouble(data["T_E"]);

    print("📊 T-Values (Parsed):");
    print("T_A: ${tA.value}");
    print("T_B: ${tB.value}");
    print("T_C: ${tC.value}");
    print("T_D: ${tD.value}");
    print("T_E: ${tE.value}");
  }

  final RxBool isLoadingDocuments = true.obs;
  // Map to store documents grouped by category
  final Map<String, RxList<DocumentModel>> documentsMap = {
    'Agreement': <DocumentModel>[].obs,
    'Register Doc': <DocumentModel>[].obs,
    'Construction Gallery': <DocumentModel>[].obs,
    'EC': <DocumentModel>[].obs,
    'Others': <DocumentModel>[].obs,
  };

  void _fetchDocuments() async {
    isLoadingDocuments.value = true;
    try {
      final data = unit.data() as Map<String, dynamic>?;
      String? unitId;
      if (data != null && data.containsKey('id')) {
        unitId = data['id'];
      } else if (unit is DocumentSnapshot) {
        unitId = unit.id;
      }

      // FIXME: Temporary hardcode for testing/debugging as per user request
      unitId = 'jcP8JHDu5jIpI6r1a4Mr';

      print("📂 Fetching documents for Unit ID: $unitId");

      final docSnapshot =
          await FirebaseFirestore.instance
              .collection('spark_unit_docs')
              .doc(unitId)
              .get();

      if (docSnapshot.exists && docSnapshot.data() != null) {
        final docsData = docSnapshot.data() as Map<String, dynamic>;

        print("📄 Document Data: $docsData");

        // Clear existing docs
        documentsMap.forEach((key, value) => value.clear());

        // Check if the document ITSELF is a file record (has 'url' or 'cat' at root)
        bool isSingleFile =
            docsData.containsKey('url') || docsData.containsKey('cat');

        if (isSingleFile) {
          print("💡 Detected Single File Document");
          try {
            final doc = DocumentModel.fromJson(docSnapshot.id, docsData);
            _categorizeDocument(doc);
          } catch (e) {
            print("❌ Error parsing single document: $e");
          }
        } else {
          // Iterate as map of files
          print("💡 Detected Map of Files");
          docsData.forEach((key, value) {
            if (value is Map<String, dynamic>) {
              try {
                final doc = DocumentModel.fromJson(key, value);
                _categorizeDocument(doc);
              } catch (e) {
                print("❌ Error parsing document $key: $e");
              }
            } else {
              print(
                "⚠️ Value for $key is not a Map used for parsing: ${value.runtimeType}",
              );
            }
          });
        }
      } else {
        print("⚠️ No documents found for this unit.");
      }
    } catch (e) {
      print("❌ Error fetching documents: $e");
    } finally {
      isLoadingDocuments.value = false;
    }
  }

  void _categorizeDocument(DocumentModel doc) {
    // Map Firebase 'cat' to our display categories
    // Assuming 'cat' values from Firebase need to be mapped.
    // If exact match is found, add it, otherwise add to 'Others' or specific logic.

    // Example mapping based on common sense or typical keys,
    // adjusting based on what we see in the image: "constructGallery" -> "Construction Gallery"
    String targetCategory = 'Others';

    switch (doc.category) {
      case 'agree':
      case 'agreement':
      case 'Agreement':
        targetCategory = 'Agreement';
        break;
      case 'reg':
      case 'registry':
      case 'Register Doc':
      case 'register_doc':
        targetCategory = 'Register Doc';
        break;
      case 'others':
        targetCategory = 'Others';
        break;
      case 'constructGallery':
      case 'Construction Gallery':
        targetCategory = 'Construction Gallery';
        break;
      case 'ec':
      case 'EC':
        targetCategory = 'EC';
        break;
      default:
        targetCategory = 'Others';
    }

    if (documentsMap.containsKey(targetCategory)) {
      documentsMap[targetCategory]!.add(doc);
    } else {
      documentsMap['Others']!.add(doc);
    }
  }

  // Transactions
  final transactions = <TransactionModel>[].obs;

  // Quick Actions (5 Dummy Data)
  final quickActions =
      <QuickActionModel>[
        QuickActionModel(
          title: 'Cost Sheet',
          description: 'View detailed cost breakdown',
        ),
        QuickActionModel(
          title: 'Payment Schedule',
          description: 'Check payment timeline',
        ),
        QuickActionModel(
          title: 'Activity log',
          description: 'View modification history',
        ),
        QuickActionModel(
          title: 'Make Payment',
          description: 'Pay your dues online',
        ),
        QuickActionModel(
          title: 'Modifications',
          description: 'Request modification',
        ),
      ].obs;

  @override
  void onInit() {
    super.onInit();
    _initSupabase();
    _parseUnitSummaryData();
    _parseCostItems();
    _parseTValues();
    _parsePaymentData();
    _fetchDemands();
    _fetchDocuments();
  }

  Future<void> _initSupabase() async {
    try {
      // Check if already initialized
      try {
        Supabase.instance.client;
      } catch (e) {
        await Supabase.initialize(
          url: SupabaseConfig.supabaseUrl,
          anonKey: SupabaseConfig.supabaseAnonKey,
        );
      }
      _fetchTransactions();
    } catch (e) {
      print("❌ Supabase Init Error: $e");
    }
  }

  Future<void> _fetchTransactions() async {
    isLoadingTransactions.value = true;
    try {
      final client = Supabase.instance.client;

      String? unitId;
      try {
        final data = unit.data() as Map<String, dynamic>?;
        unitId = data?['id'];
        if (unitId == null && unit is DocumentSnapshot) {
          unitId = unit.id;
        }
      } catch (e) {
        print("Error getting unit ID: $e");
      }

      print(
        "Fetching transactions from spark_accounts (flat table) for Unit ID: $unitId",
      );

      if (unitId == null) {
        transactions.clear();
        return;
      }

      // Exact query based on discovered schema:
      // Table: spark_accounts
      // Filter: unit_id (which exists in the keys)
      final response = await client
          .from('spark_accounts')
          .select()
          .eq('unit_id', unitId)
          .order('txt_dated', ascending: false);

      print("Fetched ${response.length} transactions.");

      final List<dynamic> data = response as List<dynamic>;
      transactions.value =
          data.map((e) => TransactionModel.fromJson(e)).toList();
    } catch (e) {
      print("❌ Supabase Fetch Error: $e");
    } finally {
      isLoadingTransactions.value = false;
    }
  }

  void _parseUnitSummaryData() {
    double eligibleCost = 0;
    double paid = 0;
    double balance = 0;
    double tReview = 0;
    double tApproved = 0;

    final data = unit.data() as Map<String, dynamic>?;

    print("📊 Project Data Keys: ${data?.keys.toList()}");

    if (data != null) {
      eligibleCost = _safeParseDouble(data["T_elgible"]);

      tReview = _safeParseDouble(data["T_review"]);
      tApproved = _safeParseDouble(data["T_approved"]);
      paid = tReview + tApproved;

      balance = _safeParseDouble(data["T_elgible_balance"]);

      // New values from T_total and T_balance
      unitCost.value = _safeParseDouble(data["T_total"]);
      totalDue.value = _safeParseDouble(data["T_balance"]);

      print(
        "🔎 Raw T_total: ${data["T_total"]} (${data["T_total"].runtimeType})",
      );
      print(
        "🔎 Raw T_balance: ${data["T_balance"]} (${data["T_balance"].runtimeType})",
      );
    }

    totalAmount.value = eligibleCost;
    paidAmount.value = paid;

    print("Eligible Cost: $eligibleCost");
    print("Paid (Review: $tReview + Approved: $tApproved): $paid");
    print("Balance: $balance");
    print("Unit Cost (T_total): ${unitCost.value}");
    print("Total Due (T_balance): ${totalDue.value}");
  }

  double _safeParseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) {
      if (value.trim().isEmpty) return 0.0;
      return double.tryParse(value.trim()) ?? 0.0;
    }
    print(
      "⚠️ Warning: Could not parse double from $value (${value.runtimeType})",
    );
    return 0.0;
  }

  List<CostItem> _extractCostItems(String key) {
    List<CostItem> items = [];

    print('🔍 Extracting cost items from key: $key');
    var unitData = unit.data() as Map<String, dynamic>;
    if (unitData.containsKey(key)) {
      var list = unitData[key];
      print('📦 Raw data for $key: $list');

      if (list is List) {
        for (int i = 0; i < list.length; i++) {
          var item = list[i];
          try {
            print('➡️ Parsing item $i: $item');

            String label =
                item["component"]?["label"]?.toString().trim() ?? "N/A";
            double price =
                double.tryParse(item["TotalNetSaleValueGsT"].toString()) ?? 0.0;
            String formattedPrice = "₹ ${_formatCurrency(price)}";

            // Determine rate: try 'charges' first, then 'component.value'
            double rateVal = 0.0;
            if (item.containsKey('charges')) {
              rateVal = _safeParseDouble(item['charges']);
            } else {
              rateVal = _safeParseDouble(item['component']?['value']);
            }

            // Extract Unit and GST %
            String unit = item['units']?['value']?.toString() ?? '';
            String gstPercent = item['gst']?['value']?.toString() ?? '';
            // If gstPercent is a number, format it? Usually it's like "18" or "0.18".
            // Assuming it comes as "18" or "18%", leaving as string for now but might need formatting if it's raw number.
            // If it's a number like 18, maybe append '%'.
            // Let's assume raw string for now.

            print(
              '✅ Parsed: Label = $label | Price = $formattedPrice | Unit = $unit',
            );

            items.add(
              CostItem(
                label,
                '',
                formattedPrice,
                rate: "₹ ${_formatCurrency(rateVal)}",
                saleValue: "₹ ${_formatCurrency(item['TotalSaleValue'] ?? 0)}",
                gst: "₹ ${_formatCurrency(item['gstValue'] ?? 0)}",
                unit: unit,
                gstPercentage: gstPercent,
              ),
            );
          } catch (e) {
            print("❌ Error parsing item $i in $key: $e");
          }
        }
      } else {
        print('⚠️ Expected a List for $key, but got: ${list.runtimeType}');
      }
    }
    //else {
    //print('❌ projectData does not contain key: $key');
    //}

    return items;
  }

  void _parseCostItems() {
    charges.value = _extractCostItems("plotCS");
    additionalCharges.value = _extractCostItems("addChargesCS");
    constructionCharges.value = _extractCostItems("constructCS");
    constructionAdditionalCharges.value = _extractCostItems(
      "constAdditionalChargesCS",
    );
    possessionCharges.value = _extractCostItems("possessionAdditionalCostCS");

    print("✅ Parsed Cost Items:");
    print("Additional Charges: ${additionalCharges.length}");
    print("Construction Charges: ${constructionCharges.length}");
    print(
      "Construction Additional Charges: ${constructionAdditionalCharges.length}",
    );
    print("Possession Charges: ${possessionCharges.length}");
  }

  String _formatCurrency(dynamic amount) {
    return ProjectStyle.formatCurrency(amount);
  }

  void _parsePaymentData() {
    var unitData = unit.data() as Map<String, dynamic>;
    if (unitData.containsKey("fullPs")) {
      var fullPs = unitData["fullPs"];
      if (fullPs is List &&
          fullPs.isNotEmpty &&
          fullPs[0] is Map<String, dynamic>) {
        List<Map<String, dynamic>> allSchedules = [];

        for (int index = 0; index < fullPs.length; index++) {
          var item = fullPs[index];

          String description =
              item["stage"]?["label"]?.toString() ??
              item["label"]?.toString() ??
              '';

          String dateStr =
              item["schDate"]?.toString() ?? item["oldDate"]?.toString() ?? '';
          String formattedDate = _formatDate(dateStr);

          double value = _safeParseDouble(item["value"]);
          double amt = _safeParseDouble(item["amt"]);
          double balanceVal = value - amt;

          // If balance is calculated as 0 but outstanding flag says otherwise, we might trust the calculation or the flag.
          // For now, using calculation for display.

          String amountStr = "₹ ${_formatCurrency(value)}";
          String receivedStr = "₹ ${_formatCurrency(amt)}";
          String balanceStr = "₹ ${_formatCurrency(balanceVal)}";

          String status;
          Color statusColor;

          DateTime? scheduledDate;
          try {
            if (dateStr.isNotEmpty) {
              scheduledDate = DateTime.fromMillisecondsSinceEpoch(
                int.parse(dateStr),
              );
            }
          } catch (e) {
            scheduledDate = null;
          }

          DateTime today = DateTime.now();
          if (balanceVal <= 0) {
            status = "PAID";
            statusColor = Colors.green;
          } else if (scheduledDate != null && scheduledDate.isAfter(today)) {
            status = "UPCOMING";
            statusColor = Colors.orange;
          } else if (scheduledDate != null && scheduledDate.isBefore(today)) {
            status = "DUE TODAY";
            statusColor = Colors.red;
          } else {
            status = "PENDING";
            statusColor = Colors.grey;
          }

          allSchedules.add({
            'number': (index + 1).toString().padLeft(2, '0'),
            'date': formattedDate,
            'description': description,
            'amount': amountStr,
            'received': receivedStr,
            'balance': balanceStr,
            'status': status,
            'statusColor': statusColor,
          });
        }

        paymentSchedule.value = allSchedules;
        payments.value =
            allSchedules.map((entry) => PaymentEntry.fromJson(entry)).toList();

        print("\n📅 Parsed Payment Schedule Entries:");
        for (var item in allSchedules) {
          print('--------------------------------');
          print('🔢 No: ${item['number']}');
          print('📆 Date: ${item['date']}');
          print('📝 Description: ${item['description']}');
          print('💰 Amount: ${item['amount']}');
          print('📥 Received: ${item['received']}');
          print('⚖️ Balance: ${item['balance']}');
          print('📌 Status: ${item['status']}');
        }
      } else {
        print("fullPs format is unexpected or empty.");
      }
    } else {
      print("fullPs not found in project data.");
    }
  }

  String _formatDate(dynamic date) {
    if (date is Timestamp) {
      // Use your preferred date format here
      return date.toDate().toString();
    }
    if (date is String && date.isNotEmpty) {
      try {
        DateTime parsedDate = DateTime.parse(date);
        // Customize format if needed, for now returning in 'dd, MMM, yyyy'
        return "${parsedDate.day}, ${_getMonthName(parsedDate.month)}, ${parsedDate.year}";
      } catch (e) {
        return date;
      }
    }
    return 'N/A';
  }

  Future<void> _fetchDemands() async {
    isLoadingDemands.value = true;
    try {
      print("Fetching Demands...");
      DocumentSnapshot doc =
          await FirebaseFirestore.instance
              .collection('demands')
              .doc('IEPyd5WGOsmig8w9AfuX')
              .get();

      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;
        String unitNo = data['unitNo']?.toString() ?? 'N/A';
        String amount = data['amount']?.toString() ?? '0';
        String dueDateStr = data['dueDate']?.toString() ?? '';

        String daysLeft = '0';
        if (dueDateStr.isNotEmpty) {
          try {
            // Check if format is pure ints or something else.
            // Assuming standard date string or timestamp.
            // If it's a string like "2025-01-10", parse it.
            DateTime dueDate = DateTime.parse(dueDateStr);
            DateTime now = DateTime.now();
            Duration diff = dueDate.difference(now);
            daysLeft = diff.inDays.toString();
          } catch (e) {
            print("Error parsing due date: $e");
          }
        }

        attentionItems.assignAll([
          UnitModel(
            unit_no: unitNo,
            amount: amount,
            daysLeft: daysLeft,
            name: '',
            user: '',
            due: '',
          ),
        ]);
        print("Demands fetched successfully: ${attentionItems.length} items");
      } else {
        print("Demand document does not exist");
      }
    } catch (e) {
      print("Error fetching demands: $e");
    } finally {
      isLoadingDemands.value = false;
    }
  }

  String _getMonthName(int month) {
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
    return months[month - 1];
  }
}
