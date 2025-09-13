import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/routes.dart';
import '../../../core/util/app_color.dart';
import '../../../core/util/common_widgets.dart';
import '../../../core/util/responsive.dart';
import '../../../core/util/sized_box.dart';
import '../controller/home_controller.dart';
import 'widget/booking_card_view.dart';
import 'widget/status_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeProvider>(context, listen: false).getHomeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final bookings = homeProvider.patientModel.patient;

    return Scaffold(
      appBar: AppBar(
        actions: [Icon(Icons.notifications_none, size: 28), SizeBoxV(20)],
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: () => homeProvider.getHomeData(),
        child: homeProvider.isLoading
            ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(AppColor.appPrimary)))
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    SizeBoxH(20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: buildCommonTextFormField(
                              hintText: 'Search for treatments',
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              controller: TextEditingController(),
                              context: context,
                              validator: (_) => null,
                              obscureText: false,
                              onTap: () {},
                              onFieldSubmitted: (_) {},
                              prefixIcon: Icon(Icons.search),
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
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text(text: 'Sort by :', fontWeight: FontWeight.w500, size: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 8),
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

                    if (homeProvider.hasError)
                      StatusView(
                        title: 'Something went wrong',
                        subtitle: 'We couldn’t load your bookings. Please try again.',
                        icon: Icons.error_outline,
                        iconColor: Colors.redAccent,
                        buttonText: 'Retry',
                        onTap: () => homeProvider.getHomeData(),
                      )
                    else if (bookings.isEmpty)
                      StatusView(
                        title: 'No Bookings Found',
                        subtitle: 'You haven’t made any bookings yet. Start exploring treatments!',
                        icon: Icons.event_busy,
                        iconColor: Colors.grey,
                        buttonText: 'Refresh',
                        onTap: () => homeProvider.getHomeData(),
                      )
                    else
                      ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemBuilder: (context, index) => BookingCard(item: bookings[index], index: index),
                        separatorBuilder: (_, __) => SizeBoxH(24),
                        itemCount: 3,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                      ),

                    SizeBoxH(30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
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
      ),
    );
  }
}
