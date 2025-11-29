import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/global/helper/extension/extension.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:barber_time/app/view/screens/user/home/controller/user_home_controller.dart';
import 'package:barber_time/app/view/screens/user/home/create_booking/models/get_barber_with_date_wise_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SummeryScreen extends StatelessWidget {
  final UserRole userRole;
  final String seloonOwnerId;
  final UserHomeController controller;
  final String seloonName;
  final String seloonImage;
  final String seloonAddress;

  const SummeryScreen(
      {super.key,
      required this.userRole,
      required this.seloonOwnerId,
      required this.controller,
      required this.seloonName,
      required this.seloonImage,
      required this.seloonAddress});
  @override
  Widget build(BuildContext context) {
    final selectedBarberId = controller.selectedBarberId.value ?? '';
    final extra = GoRouter.of(context).state.extra;
    UserRole? userRoleLocal = userRole;

    if (extra is UserRole) {
      userRoleLocal = extra;
    } else if (extra is Map<String, dynamic>) {
      userRoleLocal = extra['userRole'] as UserRole?;
    }

    debugPrint("==================={userRoleLocal?.name}");
    if (userRoleLocal == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No user role received')),
      );
    }
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
                                    imageUrl: seloonImage,
                                    height: 53,
                                    width: 53),
                                SizedBox(width: 10.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: seloonName,
                                      fontSize: 18.sp,
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    CustomText(
                                      text: seloonAddress,
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
                                    imageUrl: controller
                                        .barberDatewiseBookings.value!.barbers
                                        .firstWhere(
                                          (barber) =>
                                              barber.barberId.toString() ==
                                              selectedBarberId,
                                          orElse: () => Barber(
                                            barberId: '',
                                            name: 'Barber Name',
                                            image: '',
                                            status: '',
                                            totalQueueLength: 0,
                                            schedule: BarberSchedule(
                                                start: '', end: ''),
                                          ),
                                        )
                                        .image,
                                    height: 53,
                                    width: 53),
                                SizedBox(width: 10.w),
                                Column(
                                  children: [
                                    CustomText(
                                      text: controller
                                          .barberDatewiseBookings.value!.barbers
                                          .firstWhere(
                                            (barber) =>
                                                barber.barberId.toString() ==
                                                selectedBarberId,
                                            orElse: () => Barber(
                                              barberId: '',
                                              name: 'Barber Name',
                                              image: '',
                                              status: '',
                                              totalQueueLength: 0,
                                              schedule: BarberSchedule(
                                                  start: '', end: ''),
                                            ),
                                          )
                                          .name,
                                      fontSize: 18.sp,
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    Row(
                                      children: [
                                        CustomText(
                                          text: controller
                                              .barberDatewiseBookings
                                              .value!
                                              .barbers
                                              .firstWhere(
                                                (barber) =>
                                                    barber.barberId
                                                        .toString() ==
                                                    selectedBarberId,
                                                orElse: () => Barber(
                                                  barberId: '',
                                                  name: 'Barber Name',
                                                  image: '',
                                                  status: '',
                                                  totalQueueLength: 0,
                                                  schedule: BarberSchedule(
                                                      start: '', end: ''),
                                                ),
                                              )
                                              .status
                                              .toString(),
                                          fontSize: 12.sp,
                                          color: AppColors.normalHover,
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
                                  '${controller.selectedDate.formatDate()}',
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700),
                                ),
                                const Spacer(),
                                Text(
                                  '${controller.selectedTimeSlot.value} - '
                                  '${controller.endTimeSlot(controller.selectedTimeSlot.value)}',
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700),
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
                            ListView.separated(
                              itemCount: controller.selectedServices.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final service =
                                    controller.selectedServices[index];
                                return Row(
                                  children: [
                                    const Icon(Icons.check_circle,
                                        color: AppColors.white),
                                    SizedBox(width: 10.w),
                                    Text(
                                      service.name,
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                    const Spacer(),
                                    Text(
                                      '£ ${service.price}',
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                  ],
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 10.h),
                            ),
                            SizedBox(height: 20.h),
                            // Selected Services
                            Row(
                              children: [
                                Text(
                                  'Service Charge ( 5% Of ${controller.getTotalCostOfSelectedServices()})',
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                Text(
                                  '£ ${controller.serviceChargeCost().toStringAsFixed(2)}',
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
                            //   '£{selectedServices[index]['price']}',
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
                                  '£ ${controller.grandTotalCost().toStringAsFixed(2)}',
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
                  onTap: () async {
                    // Using GoRouter for pushing a route
                    final result = await controller.createSelonBooking(
                        saloonOwnerId: seloonOwnerId);
                    if (result) {
                      controller.seletedBarberFreeSlots.clear();
                      controller.seletedBarberFreeSlots.refresh();
                      controller.clearControllers();
                      // Navigate back to the previous two screens after successful booking
                      AppRouter.route.pop();
                      AppRouter.route.pop();
                    }
                    // context.pushNamed(RoutePath.paymentOption, extra: userRoleLocal);
                  },
                  title: "Payment",
                ),
              ),
              SizedBox(height: 50.h),
            ],
          ),
        ));
  }
}
