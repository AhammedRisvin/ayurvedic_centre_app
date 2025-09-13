import 'package:flutter/material.dart';

import '../../../../core/util/app_color.dart';
import '../../../../core/util/common_widgets.dart';
import '../../../../core/util/sized_box.dart';
import '../../controller/register_controller.dart';

class PaymentSelectionWidget extends StatelessWidget {
  final PaymentType initialSelection;
  final Function(PaymentType)? onSelectionChanged;
  final String? error;

  const PaymentSelectionWidget({super.key, required this.initialSelection, this.onSelectionChanged, this.error});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(),
        const SizeBoxH(15),
        _buildPaymentOptions(),
        if (error != null) _buildErrorWidget(error!),
        const SizeBoxH(20),
      ],
    );
  }

  Widget _buildSectionTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: text(text: 'Payment Option', size: 16, fontWeight: FontWeight.w400, letterSpacing: 1.4),
    );
  }

  Widget _buildPaymentOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          _buildPaymentOption('Cash', PaymentType.cash),
          const Spacer(),
          _buildPaymentOption('Card', PaymentType.card),
          const Spacer(),
          _buildPaymentOption('UPI', PaymentType.upi),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String paymentType, PaymentType type) {
    bool isSelected = initialSelection == type;

    return GestureDetector(
      onTap: () => _selectPayment(type),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 22,
            width: 22,
            decoration: BoxDecoration(
              color: isSelected ? AppColor.appPrimary : Colors.transparent,
              border: Border.all(color: isSelected ? AppColor.appPrimary : AppColor.black.withOpacity(0.3), width: 2),
              borderRadius: BorderRadius.circular(100),
            ),
            child: isSelected ? Icon(Icons.check, color: Colors.white, size: 14) : null,
          ),
          const SizeBoxV(10),
          text(
            text: paymentType,
            size: 15,
            fontWeight: FontWeight.w500,
            color: isSelected ? AppColor.appPrimary : AppColor.black,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String errorMessage) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 16),
          const SizeBoxV(5),
          Expanded(
            child: text(text: errorMessage, size: 12, color: Colors.red, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  void _selectPayment(PaymentType type) {
    if (onSelectionChanged != null) {
      onSelectionChanged!(type);
    }
  }

  // Getter methods for backward compatibility
  PaymentType get getSelectedPayment => initialSelection;

  String getSelectedPaymentString() {
    switch (initialSelection) {
      case PaymentType.cash:
        return 'Cash';
      case PaymentType.card:
        return 'Card';
      case PaymentType.upi:
        return 'UPI';
    }
  }
}
