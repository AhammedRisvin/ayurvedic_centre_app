import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/util/app_color.dart';
import '../../../../core/util/common_widgets.dart';
import '../../../../core/util/sized_box.dart';
import '../../controller/register_controller.dart';
import 'treatment_dialog_widget.dart';

class TreatmentSelectionWidget extends StatelessWidget {
  const TreatmentSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterProvider>(
      builder: (context, provider, child) {
        log('lengthh. ${provider.treatments.length}');
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(),
            const SizeBoxH(6),
            // Show treatment cards only if treatments exist
            if (provider.treatments.isNotEmpty) ...[
              ...provider.treatments.asMap().entries.map(
                (entry) => _buildTreatmentCard(context, entry.key, entry.value, provider),
              ),
              const SizeBoxH(10),
            ],
            _buildAddTreatmentButton(context),
            // Show error if treatments validation fails
            if (provider.fieldErrors['treatments'] != null) _buildTreatmentError(provider.fieldErrors['treatments']!),
            const SizeBoxH(20),
          ],
        );
      },
    );
  }

  Widget _buildSectionTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: text(text: 'Treatments', size: 16, fontWeight: FontWeight.w400, letterSpacing: 1.4),
    );
  }

  Widget _buildTreatmentCard(BuildContext context, int index, Treatment treatment, RegisterProvider provider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color(0XFFF0F0F0)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          text(text: '${index + 1}.', size: 18, fontWeight: FontWeight.w500, color: AppColor.black),
          const SizeBoxV(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTreatmentHeader(context, index, treatment, provider),
                const SizeBoxH(14),
                _buildGenderCountRow(context, index, treatment, provider),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTreatmentHeader(BuildContext context, int index, Treatment treatment, RegisterProvider provider) {
    return Row(
      children: [
        Expanded(
          child: text(
            text: treatment.name,
            size: 16,
            fontWeight: FontWeight.w300,
            color: AppColor.black,
            maxLines: 2,
            overFlow: TextOverflow.ellipsis,
          ),
        ),
        const SizeBoxV(10),
        GestureDetector(
          onTap: () => _removeTreatment(context, index, provider),
          child: CircleAvatar(
            radius: 14,
            backgroundColor: const Color(0xffF21E1E).withOpacity(0.5),
            child: const Icon(Icons.close, color: Colors.white, size: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderCountRow(BuildContext context, int index, Treatment treatment, RegisterProvider provider) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              _buildGenderCounter('Male', treatment.maleCount),
              const Spacer(),
              _buildGenderCounter('Female', treatment.femaleCount),
            ],
          ),
        ),
        const SizeBoxV(40),
        GestureDetector(
          onTap: () => _editTreatment(context, index),
          child: Icon(Icons.edit_outlined, color: AppColor.greenColor),
        ),
      ],
    );
  }

  Widget _buildGenderCounter(String gender, int count) {
    return Row(
      children: [
        text(text: gender, size: 15, fontWeight: FontWeight.w400, color: AppColor.appPrimary),
        const SizeBoxV(10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: AppColor.black.withOpacity(0.5)),
          ),
          child: text(text: count.toString(), size: 16, fontWeight: FontWeight.w400, color: AppColor.appPrimary),
        ),
      ],
    );
  }

  Widget _buildAddTreatmentButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: button(
        name: '+ Add Treatments',
        textColor: AppColor.black,
        color: const Color(0XFF389A48).withOpacity(0.3),
        borderColor: const Color(0XFF389A48).withOpacity(0.3),
        height: 50,
        fontSize: 15,
        width: double.infinity,
        onTap: () => _showAddTreatmentDialog(context),
        isLoading: false,
      ),
    );
  }

  Widget _buildTreatmentError(String error) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 8),
      child: text(text: error, size: 12, color: Colors.red, fontWeight: FontWeight.w400),
    );
  }

  void _showAddTreatmentDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return const TreatmentDialogWidget();
      },
    );
  }

  void _editTreatment(BuildContext context, int index) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return TreatmentDialogWidget(editIndex: index);
      },
    );
  }

  void _removeTreatment(BuildContext context, int index, RegisterProvider provider) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Treatment'),
          content: const Text('Are you sure you want to remove this treatment?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                provider.removeTreatment(index);
                Navigator.pop(context);
              },
              child: const Text('Remove', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
