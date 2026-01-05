import 'package:customerapp/models/cost_item_model.dart';
import 'package:customerapp/models/payment_entry_model.dart';
import 'package:customerapp/models/quick_action_model.dart';
import 'package:get/get.dart';

// Controller
class CostSheetController extends GetxController {
  final List<CostItem> plcItems = [
    CostItem('Unit cost', '1,32,000 sqft', '₹ 1,32,000'),
    CostItem('PLC', '0 sqft', '₹ 0'),
  ];

  final List<PaymentEntry> paymentEntries = [];

  final List<QuickActionModel> quickActions = [
    QuickActionModel(
      title: 'Payment Schedule',
      description: 'View payment timeline',
    ),
    QuickActionModel(
      title: 'Make a Payment',
      description: 'Initiate new payment',
    ),
  ];
}
