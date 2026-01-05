import 'package:customerapp/models/payment_entry_model.dart';
import 'package:customerapp/models/quick_action_model.dart';

import 'package:get/get.dart';

class PaymentScheduleController extends GetxController {
  // Payment Entries
  final payments = <PaymentEntry>[].obs;

  // Quick Actions
  final quickActions =
      <QuickActionModel>[
        QuickActionModel(
          title: 'Cost Sheet',
          description: 'View detailed cost breakdown',
        ),
        QuickActionModel(
          title: 'Make a Payment',
          description: 'Initiate new payment',
        ),
        QuickActionModel(
          title: 'Download Receipt',
          description: 'Get your payment receipts',
        ),
        QuickActionModel(
          title: 'View Agreement',
          description: 'Check the agreement details',
        ),
        QuickActionModel(
          title: 'Payment History',
          description: 'Review past transactions',
        ),
      ].obs;
}
