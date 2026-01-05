import 'package:customerapp/controllers/project_controller.dart';
import 'package:customerapp/models/transaction_model.dart';
import 'package:get/get.dart';

class TransactionController extends GetxController {
  // Try to find ProjectController.
  ProjectController? _projectController;

  @override
  void onInit() {
    super.onInit();
    try {
      _projectController = Get.find<ProjectController>();
    } catch (e) {
      print("ProjectController not found in TransactionController: $e");
    }
  }

  // Return transactions from ProjectController if available, else empty list
  List<TransactionModel> get transactions =>
      _projectController?.transactions ?? <TransactionModel>[];

  bool get isLoading =>
      _projectController?.isLoadingTransactions.value ?? false;
}
