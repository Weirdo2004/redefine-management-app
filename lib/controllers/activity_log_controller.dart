import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customerapp/models/activity_entry_model.dart';
import 'package:customerapp/models/quick_action_model.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'project_controller.dart';

class ActivityLogController extends GetxController {
  final RxList<ActivityEntry> activities = <ActivityEntry>[].obs;
  final RxBool isLoading = true.obs;

  // Quick Actions
  final RxList<QuickActionModel> quickActions =
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

  @override
  void onInit() {
    super.onInit();
    _fetchActivities();
  }

  Future<void> _fetchActivities() async {
    isLoading.value = true;
    try {
      final ProjectController projectController = Get.find<ProjectController>();
      String? unitId;

      // Extract Unit ID (Uuid) from ProjectController
      try {
        final data = projectController.unit.data() as Map<String, dynamic>?;
        unitId = data?['id'];
        if (unitId == null) {
          if (projectController.unit is DocumentSnapshot) {
            unitId = (projectController.unit as DocumentSnapshot).id;
          }
        }
      } catch (e) {
        print("Error getting unit ID: $e");
      }

      if (unitId == null) {
        print("❌ Unit ID is null, cannot fetch activity logs.");
        isLoading.value = false;
        return;
      }

      print(
        "Fetching activity logs for Unit ID (Uuid): $unitId from spark_unit_logs",
      );

      final client = Supabase.instance.client;

      // Query spark_unit_logs
      // Filter by 'Uuid' == unitId
      // Order by 'T' (timestamp millis) descending
      final response = await client
          .from('spark_unit_logs')
          .select()
          .eq('Uuid', unitId)
          .order('T', ascending: false);

      final List<dynamic> data = response as List<dynamic>;

      print("✅ Fetched ${data.length} activity logs.");

      activities.value =
          data
              .map((e) => ActivityEntry.fromMap(e as Map<String, dynamic>))
              .toList();
    } catch (e) {
      print("❌ Error fetching activity logs: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
