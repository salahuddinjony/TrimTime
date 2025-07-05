import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';

class SummeryScreen extends StatefulWidget {
  const SummeryScreen({super.key});

  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummeryScreen> {
  List<Map<String, dynamic>> selectedServices = [
    {'service': 'Deep Massage - 45 Minutes', 'price': 50.0},
    {'service': 'Deep Massage - 45 Minutes', 'price': 50.0},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: const CustomAppBar(
          appBarBgColor: AppColors.searchScreenBg,
          appBarContent: "Summary",
          iconData: Icons.arrow_back,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ClipPath(
                  clipper: CurvedBannerClipper(),
                  child: Container(
                    width: double.infinity,
                    decoration:
                        const BoxDecoration(color: AppColors.searchScreenBg),
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Review & Confirm Section
                            CustomText(
                              text: "Review & confirm",
                              fontSize: 20.sp,
                              color: AppColors.black,
                              fontWeight: FontWeight.w500,
                            ),

                            const Divider(
                              color: Colors.grey,
                            ),
                            SizedBox(height: 20.h),
                            Row(
                              children: [
                                CustomNetworkImage(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.r)),
                                    imageUrl: AppConstants.demoImage,
                                    height: 53,
                                    width: 53),
                                SizedBox(width: 10.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: "Serenity Saloon",
                                      fontSize: 18.sp,
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w500,
                                    ),

                                    CustomText(
                                      text: "Chev 36 St, London",
                                      fontSize: 16.sp,
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),

                            const Divider(
                              color: Colors.grey,
                            ),

                            SizedBox(height: 20.h),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomNetworkImage(
                                  boxShape: BoxShape.circle,
                                    imageUrl: AppConstants.demoImage,
                                    height: 53,
                                    width: 53),
                                SizedBox(width: 10.w),
                                Column(
                                  children: [
                                    CustomText(
                                      text: "Talha",
                                      fontSize: 18.sp,
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    Row(
                                      children: [
                                        CustomText(
                                          text: "5.0 *",
                                          fontSize: 18.sp,
                                          color: AppColors.white,
                                          fontWeight: FontWeight.w600,
                                        ),

                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            SizedBox(height: 20.h),
                            const Divider(
                              color: Colors.grey,
                            ),

                            SizedBox(height: 20.h),

                            // Date & Time Section
                            Row(
                              children: [
                                const Icon(Icons.calendar_today,
                                    color: Colors.white),
                                SizedBox(width: 10.w),
                                Text(
                                  'Sat 7 Oct 2023',
                                  style: TextStyle(fontSize: 16.sp),
                                ),
                                const Spacer(),
                                Text(
                                  '11:00 - 11:45 pm',
                                  style: TextStyle(fontSize: 16.sp),
                                ),
                              ],
                            ),

                            SizedBox(height: 20.h),
                            // Selected Services
                            Text(
                              'Selected services',
                              style: TextStyle(
                                  fontSize: 18.sp, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10.h),
                            ListView.builder(
                              itemCount: selectedServices.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Row(
                                  children: [
                                    const Icon(Icons.check_circle,
                                        color: AppColors.last),
                                    SizedBox(width: 10.w),
                                    Text(
                                      selectedServices[index]['service'],
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                    const Spacer(),
                                    Text(
                                      '£ ${selectedServices[index]['price']}',
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                  ],
                                );
                              },
                            ),
                            SizedBox(height: 20.h),
                            // Selected Services
                            Row(
                              children: [
                                Text(
                                  'Service Charge',
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                Text(
                                  '0.50 ',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                            // Text(
                            //   selectedServices[index]['service'],
                            //   style: TextStyle(fontSize: 14.sp),
                            // ),
                            // const Spacer(),
                            // Text(
                            //   '£ ${selectedServices[index]['price']}',
                            //   style: TextStyle(fontSize: 14.sp),
                            // ),
                            SizedBox(height: 20.h),
                            // Invoice Details
                            const Divider(
                              color: Colors.grey,
                            ),

                            SizedBox(height: 10.h),
                            Row(
                              children: [
                                Text(
                                  'Subtotal',
                                  style: TextStyle(fontSize: 16.sp),
                                ),
                                const Spacer(),
                                Text(
                                  '£100.00',
                                  style: TextStyle(fontSize: 16.sp),
                                ),
                              ],
                            ),
                            SizedBox(height: 50.h),
                          ],
                        ),
                      ),
                    ),
                  )),
              SizedBox(height: 50.h),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: CustomButton(
                  onTap: () {
                    // Using GoRouter for pushing a route
                    context.pushNamed(RoutePath.paymentOption);
                  },
                  textColor: Colors.white,
                  fillColor: Colors.black,
                  title: "Select Payment",
                ),
              ),
              SizedBox(height: 50.h),
            ],
          ),
        ));
  }
}
