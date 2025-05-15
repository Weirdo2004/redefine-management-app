class UnitModel {
  final String unit_no;
  final String name;
  final String user;
  final String due;
  final String? amount;
  final String? daysLeft;
  // final String status;
  // final String T_elgible_balance;

  UnitModel({
    required this.unit_no,
    required this.name,
    required this.user,
    required this.due,
    this.amount,
    this.daysLeft,
    // required this.status,
    // required this.T_elgible_balance,
  });
}