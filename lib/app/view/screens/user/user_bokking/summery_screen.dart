import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

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
      appBar: CustomAppBar(
        appBarContent: "Summary",
        iconData: Icons.arrow_back,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Review & Confirm Section
              Text(
                'Review & Confirm',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              Divider(
                color: Colors.grey,
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  CustomNetworkImage(
                      borderRadius: BorderRadius.all(Radius.circular(10.r)),
                      imageUrl: AppConstants.demoImage,
                      height: 53,
                      width: 53),
                  SizedBox(width: 10.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Serenity Saloon',
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Chev 36 St, London',
                        style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              Divider(
                color: Colors.grey,
              ),

              SizedBox(height: 20.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomNetworkImage(
                      borderRadius: BorderRadius.all(Radius.circular(10.r)),
                      imageUrl: AppConstants.demoImage,
                      height: 53,
                      width: 53),
                  SizedBox(width: 10.w),
                  Column(
                    children: [
                      Text(
                        'Talha',
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Text(
                            '5.0 ',
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange),
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.orange,
                            size: 16,
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 20.h),
              Divider(
                color: Colors.grey,
              ),

              SizedBox(height: 20.h),

              // Date & Time Section
              Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.grey),
                  SizedBox(width: 10.w),
                  Text(
                    'Sat 7 Oct 2023',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  Spacer(),
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
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.h),
              ListView.builder(
                itemCount: selectedServices.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green),
                      SizedBox(width: 10.w),
                      Text(
                        selectedServices[index]['service'],
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      Spacer(),
                      Text(
                        '£ ${selectedServices[index]['price']}',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 20.h),
              // Invoice Details
              Divider(
                color: Colors.grey,
              ),

              SizedBox(height: 10.h),
              Row(
                children: [
                  Text(
                    'Subtotal',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  Spacer(),
                  Text(
                    '£100.00',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ],
              ),
              SizedBox(height: 50.h),

              CustomButton(
                onTap: () {
                  // Using GoRouter for pushing a route
                  context.pushNamed(RoutePath.paymentOption);
                },
                textColor: Colors.white,
                fillColor: Colors.black,
                title: "Select Payment",
              )
            ],
          ),
        ),
      ),
    );
  }
}
