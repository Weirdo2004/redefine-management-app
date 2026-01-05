class CostItem {
  final String description;
  final String details;
  final String amount;
  final String rate;
  final String saleValue;
  final String gst;
  final String unit;
  final String gstPercentage;

  CostItem(
    this.description,
    this.details,
    this.amount, {
    this.rate = '',
    this.saleValue = '',
    this.gst = '',
    this.unit = '',
    this.gstPercentage = '',
  });
}
