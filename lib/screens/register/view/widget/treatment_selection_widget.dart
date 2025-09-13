import 'package:flutter/material.dart';

import '../../../../core/util/app_color.dart';
import '../../../../core/util/common_widgets.dart';
import '../../../../core/util/sized_box.dart';

class TreatmentSelectionWidget extends StatefulWidget {
  final List<Treatment>? treatments;
  final VoidCallback? onAddTreatment;
  final Function(int)? onRemoveTreatment;
  final Function(int, int, int)? onUpdateCount; // treatmentIndex, genderType (0=male, 1=female), count

  const TreatmentSelectionWidget({
    super.key,
    this.treatments,
    this.onAddTreatment,
    this.onRemoveTreatment,
    this.onUpdateCount,
  });

  @override
  State<TreatmentSelectionWidget> createState() => _TreatmentSelectionWidgetState();
}

class _TreatmentSelectionWidgetState extends State<TreatmentSelectionWidget> {
  // Default treatment for demo purposes
  List<Treatment> treatments = [
    Treatment(id: 1, name: 'Couple Combo Package (Rejuvenasjhdvasjhd asdhgasd)', maleCount: 2, femaleCount: 2),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.treatments != null) {
      treatments = widget.treatments!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(),
        const SizeBoxH(6),
        ...treatments.asMap().entries.map((entry) => _buildTreatmentCard(entry.key, entry.value)),
        const SizeBoxH(10),
        _buildAddTreatmentButton(),
        const SizeBoxH(20),
      ],
    );
  }

  Widget _buildSectionTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: text(text: 'Treatments', size: 16, fontWeight: FontWeight.w400, letterSpacing: 1.4),
    );
  }

  Widget _buildTreatmentCard(int index, Treatment treatment) {
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
                _buildTreatmentHeader(index, treatment),
                const SizeBoxH(14),
                _buildGenderCountRow(index, treatment),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTreatmentHeader(int index, Treatment treatment) {
    return Row(
      children: [
        Expanded(
          child: text(
            text: treatment.name,
            size: 16,
            fontWeight: FontWeight.w300,
            color: AppColor.black,
            maxLines: 1,
            overFlow: TextOverflow.ellipsis,
          ),
        ),
        const SizeBoxV(10),
        GestureDetector(
          onTap: () => _removeTreatment(index),
          child: CircleAvatar(
            radius: 14,
            backgroundColor: const Color(0xffF21E1E).withOpacity(0.5),
            child: const Icon(Icons.close, color: Colors.white, size: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderCountRow(int index, Treatment treatment) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              _buildGenderCounter(index, 'Male', treatment.maleCount, 0),
              const Spacer(),
              _buildGenderCounter(index, 'Female', treatment.femaleCount, 1),
            ],
          ),
        ),
        const SizeBoxV(40),
        GestureDetector(
          onTap: () => _editTreatment(index),
          child: Icon(Icons.edit_outlined, color: AppColor.greenColor),
        ),
      ],
    );
  }

  Widget _buildGenderCounter(int treatmentIndex, String gender, int count, int genderType) {
    return Row(
      children: [
        text(text: gender, size: 15, fontWeight: FontWeight.w400, color: AppColor.appPrimary),
        const SizeBoxV(10),
        GestureDetector(
          onTap: () => _showCountPicker(treatmentIndex, genderType, count),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              border: Border.all(color: AppColor.black.withOpacity(0.5)),
            ),
            child: text(text: count.toString(), size: 16, fontWeight: FontWeight.w400, color: AppColor.appPrimary),
          ),
        ),
      ],
    );
  }

  Widget _buildAddTreatmentButton() {
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
        onTap: () {
          if (widget.onAddTreatment != null) {
            widget.onAddTreatment!();
          } else {
            _addTreatment();
          }
        },
        isLoading: false,
      ),
    );
  }

  void _addTreatment() {
    setState(() {
      treatments.add(Treatment(id: treatments.length + 1, name: 'New Treatment', maleCount: 1, femaleCount: 1));
    });
  }

  void _removeTreatment(int index) {
    setState(() {
      treatments.removeAt(index);
    });
    if (widget.onRemoveTreatment != null) {
      widget.onRemoveTreatment!(index);
    }
  }

  void _editTreatment(int index) {
    // Navigate to edit treatment screen or show edit dialog
    // Implementation depends on your requirements
  }

  void _showCountPicker(int treatmentIndex, int genderType, int currentCount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Count'),
          content: SizedBox(
            width: 300,
            height: 200,
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                int count = index + 1;
                return ListTile(
                  title: Text(count.toString()),
                  selected: count == currentCount,
                  onTap: () {
                    _updateCount(treatmentIndex, genderType, count);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _updateCount(int treatmentIndex, int genderType, int count) {
    setState(() {
      if (genderType == 0) {
        treatments[treatmentIndex].maleCount = count;
      } else {
        treatments[treatmentIndex].femaleCount = count;
      }
    });

    if (widget.onUpdateCount != null) {
      widget.onUpdateCount!(treatmentIndex, genderType, count);
    }
  }
}

class Treatment {
  final int id;
  final String name;
  int maleCount;
  int femaleCount;

  Treatment({required this.id, required this.name, required this.maleCount, required this.femaleCount});
}
