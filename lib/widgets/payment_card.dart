import 'package:flutter/material.dart';
import '../models/payment_entry_model.dart';
import '../utils/project_style.dart';

class PaymentCard extends StatefulWidget {
  final PaymentEntry payment;
  final double screenWidth;
  final double screenHeight;
  final bool showBorder;

  const PaymentCard({
    super.key,
    required this.payment,
    required this.screenWidth,
    required this.screenHeight,
    this.showBorder = true,
    this.margin,
  });

  final EdgeInsetsGeometry? margin;

  @override
  State<PaymentCard> createState() => _PaymentCardState();
}

class _PaymentCardState extends State<PaymentCard> {
  bool isExpanded = false;

  String _formatDate(String dateString) {
    if (dateString.contains('GMT')) {
      return dateString.split('GMT')[0].trim();
    }
    return dateString;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: widget.margin ?? EdgeInsets.zero,

      padding: EdgeInsets.all(widget.screenHeight * 0.015),
      decoration: BoxDecoration(
        color: ProjectStyle.surfaceColor,
        borderRadius: BorderRadius.circular(8),
        border:
            widget.showBorder ? Border.all(color: Colors.grey.shade300) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Number, Description, Amount, Arrow
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center, // Ensure alignment
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: widget.screenHeight * 0.03,
                      height: widget.screenHeight * 0.03,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ProjectStyle.secondaryTextColor,
                      ),
                      child: Center(
                        child: Text(
                          widget.payment.number,
                          style: ProjectStyle.smallText.copyWith(
                            fontSize: widget.screenHeight * 0.015,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: widget.screenWidth * 0.03),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.payment.description,
                            style: ProjectStyle.bodyText.copyWith(
                              fontSize: widget.screenHeight * 0.016,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            widget.payment.amount,
                            style: ProjectStyle.bodyText.copyWith(
                              fontSize: widget.screenHeight * 0.015,
                              color: ProjectStyle.secondaryTextColor,
                              fontWeight: FontWeight.w500,
                              decoration:
                                  widget.payment.status == 'RECEIVED'
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  // Removed Status Text as per request ("display on booking and value... don't show pending text")
                  // But we might want to keep the indicator if needed? User didn't explicitly safeguard it differently than "pending text".
                  IconButton(
                    icon: Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: widget.screenHeight * 0.025,
                      color: ProjectStyle.iconColor,
                    ),
                    onPressed: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),

          if (isExpanded) ...[
            SizedBox(height: widget.screenHeight * 0.01),
            // Date replaces Description in expanded view
            // And we keep Bal/Rec on the right.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    _formatDate(widget.payment.date),
                    style: ProjectStyle.bodyText.copyWith(
                      color: ProjectStyle.secondaryTextColor,
                      fontSize: widget.screenHeight * 0.014,
                    ),
                  ),
                ),
                if (widget.payment.status == 'RECEIVED')
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xffDFF6E0),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        'Paid',
                        style: ProjectStyle.smallText.copyWith(
                          fontSize: widget.screenHeight * 0.016,
                          color: Color(0xff1B6600),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Rec: ${widget.payment.received}',
                        style: ProjectStyle.smallText.copyWith(
                          fontSize: widget.screenHeight * 0.014,
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Bal: ${widget.payment.balance}',
                        style: ProjectStyle.smallText.copyWith(
                          fontSize: widget.screenHeight * 0.014,
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
