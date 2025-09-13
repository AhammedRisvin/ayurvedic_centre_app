import 'package:ayurvedic_centre_app/core/routes/routes.dart';
import 'package:ayurvedic_centre_app/core/util/app_color.dart';
import 'package:ayurvedic_centre_app/core/util/responsive.dart';
import 'package:ayurvedic_centre_app/core/util/sized_box.dart';
import 'package:flutter/material.dart';

import '../../../core/util/common_widgets.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back, color: AppColor.black),
        actions: [Image.asset('assets/images/notificationBell.png', height: 28, width: 28), SizeBoxV(20)],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizeBoxH(20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: buildCommonTextFormField(
                      hintText: 'Search for treatments',
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
                      prefixIcon: Image.asset('assets/images/searchIcon.png'),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  SizeBoxV(16),
                  button(
                    name: 'Search',
                    fontSize: 13,
                    height: Responsive.height * 5.6,
                    borderRadius: BorderRadius.circular(8),
                    width: 80,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            SizeBoxH(30),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  text(text: 'Sort by :', fontWeight: FontWeight.w500, size: 16),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 19, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: AppColor.black.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        text(text: 'Date', size: 14),
                        SizeBoxV(75),
                        Icon(Icons.keyboard_arrow_down, color: AppColor.greenColor),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizeBoxH(10),
            Divider(color: AppColor.black.withOpacity(0.4), thickness: 1),
            SizeBoxH(14),
            ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 20),
              itemBuilder: (context, index) {
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color(0XFFF1F1F1)),
                  child: Column(
                    children: [
                      SizeBoxH(23),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            text(text: '1.', size: 18, fontWeight: FontWeight.w500, color: AppColor.black),
                            SizeBoxV(10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  text(
                                    text: 'Vikram Singh',
                                    size: 18,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.black,
                                  ),
                                  SizeBoxH(3),
                                  text(
                                    text: 'Couple Combo Package (Rejuvenasjhdvasjhd asdhgasd ',
                                    size: 16,
                                    fontWeight: FontWeight.w300,
                                    color: AppColor.greenColor,
                                    maxLines: 1,
                                    overFlow: TextOverflow.ellipsis,
                                  ),
                                  SizeBoxH(14),
                                  Row(
                                    children: [
                                      Image.asset('assets/images/calenderIcon.png', height: 16, width: 16),
                                      SizeBoxV(6),
                                      text(
                                        text: ' 20/02/2024',
                                        size: 15,
                                        fontWeight: FontWeight.w400,
                                        color: AppColor.black.withOpacity(0.5),
                                      ),
                                      SizeBoxV(20),
                                      Image.asset('assets/images/personIcon.png', height: 16, width: 16),
                                      SizeBoxV(6),
                                      text(
                                        text: ' Jithesh',
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
                            text(
                              text: 'View Booking details',
                              size: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColor.black,
                            ),
                            Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColor.greenColor),
                          ],
                        ),
                      ),
                      SizeBoxH(9),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => SizeBoxH(24),
              itemCount: 3,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
            ),
            SizeBoxH(30),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: button(
                name: 'Register Now',
                height: 50,
                isLoading: false,
                width: double.infinity,
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.register);
                },
              ),
            ),
            SizeBoxH(100),
          ],
        ),
      ),
    );
  }
}
