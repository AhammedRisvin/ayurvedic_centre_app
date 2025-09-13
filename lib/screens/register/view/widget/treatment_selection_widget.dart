import 'package:flutter/material.dart';

import '../../../../core/util/app_color.dart';
import '../../../../core/util/common_widgets.dart';
import '../../../../core/util/sized_box.dart';

class TreatmentSelectionWidget extends StatefulWidget {
  // treatmentIndex, genderType (0=male, 1=female), count

  const TreatmentSelectionWidget({super.key});

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
          onTap: () {},
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
          onTap: () {},
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
          showCustomDialog(context);
        },
        isLoading: false,
      ),
    );
  }

  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizeBoxH(40),
                  text(text: 'Choose Treatment', size: 16, fontWeight: FontWeight.w400, letterSpacing: 1.4),
                  SizeBoxH(6),
                  buildCommonTextFormField(
                    hintText: 'Choose preferred treatment',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    controller: TextEditingController(),
                    context: context,
                    validator: (p0) {
                      return null;
                    },
                    obscureText: false,
                    onTap: () {},
                    onFieldSubmitted: (p0) {},
                    suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColor.appPrimary),
                  ),
                  SizeBoxH(20),
                  text(text: 'Add Patients', size: 16, fontWeight: FontWeight.w400, letterSpacing: 1.4),
                  SizeBoxH(6),
                  Row(
                    children: [
                      Container(
                        height: 50,
                        width: 124,
                        padding: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.53),
                          border: Border.all(color: AppColor.black.withOpacity(0.25)),
                          color: Color(0XFFD9D9D9).withOpacity(0.25),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: text(text: 'Male', fontWeight: FontWeight.w300, size: 14),
                        ),
                      ),
                      Spacer(),
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: AppColor.appPrimary,
                          boxShadow: [
                            BoxShadow(color: AppColor.appPrimary.withOpacity(0.2), blurRadius: 4, offset: Offset(2, 2)),
                          ],
                        ),
                        child: Icon(Icons.remove, color: AppColor.white),
                      ),
                      SizeBoxV(8),
                      Container(
                        height: 44,
                        width: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.53),
                          border: Border.all(color: AppColor.black.withOpacity(0.25)),
                        ),
                        child: Center(
                          child: text(text: '1', fontWeight: FontWeight.w500, size: 18),
                        ),
                      ),
                      SizeBoxV(8),
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: AppColor.appPrimary,
                          boxShadow: [
                            BoxShadow(color: AppColor.appPrimary.withOpacity(0.2), blurRadius: 4, offset: Offset(2, 2)),
                          ],
                        ),
                        child: Icon(Icons.add, color: AppColor.white),
                      ),
                    ],
                  ),
                  SizeBoxH(22),
                  Row(
                    children: [
                      Container(
                        height: 50,
                        width: 124,
                        padding: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.53),
                          border: Border.all(color: AppColor.black.withOpacity(0.25)),
                          color: Color(0XFFD9D9D9).withOpacity(0.25),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: text(text: 'Female', fontWeight: FontWeight.w300, size: 14),
                        ),
                      ),
                      Spacer(),
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: AppColor.appPrimary,
                          boxShadow: [
                            BoxShadow(color: AppColor.appPrimary.withOpacity(0.2), blurRadius: 4, offset: Offset(2, 2)),
                          ],
                        ),
                        child: Icon(Icons.remove, color: AppColor.white),
                      ),
                      SizeBoxV(8),
                      Container(
                        height: 44,
                        width: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.53),
                          border: Border.all(color: AppColor.black.withOpacity(0.25)),
                        ),
                        child: Center(
                          child: text(text: '1', fontWeight: FontWeight.w500, size: 18),
                        ),
                      ),
                      SizeBoxV(8),
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: AppColor.appPrimary,
                          boxShadow: [
                            BoxShadow(color: AppColor.appPrimary.withOpacity(0.2), blurRadius: 4, offset: Offset(2, 2)),
                          ],
                        ),
                        child: Icon(Icons.add, color: AppColor.white),
                      ),
                    ],
                  ),
                  SizeBoxH(30),
                  button(
                    name: 'Save',
                    height: 50,
                    fontSize: 15,
                    width: double.infinity,
                    onTap: () {},
                    isLoading: false,
                  ),
                  SizeBoxH(40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class Treatment {
  final int id;
  final String name;
  int maleCount;
  int femaleCount;

  Treatment({required this.id, required this.name, required this.maleCount, required this.femaleCount});
}
