import 'package:ayurvedic_centre_app/core/util/app_color.dart';
import 'package:ayurvedic_centre_app/core/util/common_widgets.dart';
import 'package:ayurvedic_centre_app/core/util/sized_box.dart';
import 'package:flutter/material.dart';

import '../../model/patient_model.dart';

class BookingCard extends StatelessWidget {
  final Patient item;
  final int index;

  const BookingCard({super.key, required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    final treatmentName = item.patientDetails?.isNotEmpty == true
        ? item.patientDetails?.first.treatmentName ?? 'No Treatment'
        : 'No Treatment';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color(0XFFF1F1F1)),
      child: Column(
        children: [
          SizeBoxH(23),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                text(text: '${index + 1}.', size: 18, fontWeight: FontWeight.w500),
                SizeBoxV(10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      text(text: item.name, size: 18, fontWeight: FontWeight.w700),
                      SizeBoxH(3),
                      text(
                        text: treatmentName,
                        size: 16,
                        fontWeight: FontWeight.w300,
                        color: AppColor.greenColor,
                        maxLines: 1,
                        overFlow: TextOverflow.ellipsis,
                      ),
                      SizeBoxH(14),
                      Row(
                        children: [
                          Image.asset('assets/images/calenderIcon.png'),
                          SizeBoxV(6),
                          text(
                            text: ' ${item.dateTime?.split("T").first}',
                            size: 15,
                            fontWeight: FontWeight.w400,
                            color: AppColor.black.withOpacity(0.5),
                          ),
                          SizeBoxV(20),
                          Image.asset('assets/images/personIcon.png'),
                          SizeBoxV(6),
                          text(
                            text: ' ${item.user}',
                            size: 15,
                            fontWeight: FontWeight.w400,
                            color: AppColor.black.withOpacity(0.5),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizeBoxH(10),
          Divider(color: AppColor.black.withOpacity(0.2), thickness: 1),
          SizeBoxH(9),
          Padding(
            padding: const EdgeInsets.only(left: 40.0, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                text(text: 'View Booking details', size: 16, fontWeight: FontWeight.w500),
                Icon(Icons.arrow_forward_ios_rounded, size: 20, color: AppColor.greenColor),
              ],
            ),
          ),
          SizeBoxH(9),
        ],
      ),
    );
  }
}
