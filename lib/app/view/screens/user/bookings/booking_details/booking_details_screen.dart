import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class BookingDetailsScreen extends StatelessWidget {
  const BookingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userRole = GoRouter.of(context).state.extra as UserRole?;

    if (userRole == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No user role received')),
      );
    }
    return Scaffold(
      backgroundColor: AppColors.white50,
      appBar: const CustomAppBar(
        iconData: Icons.arrow_back,
        appBarContent: "Booking Details",
        appBarBgColor: AppColors.linearFirst,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomNetworkImage(
              imageUrl: AppConstants.shop,
              borderRadius: BorderRadius.circular(10.r),
              height: 174.h,
              width: double.infinity,
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              children: [
                const Icon(Icons.calendar_month),
                Expanded(
                  child: CustomText(
                    left: 10,
                    text: "Fri 28 Sep 2023 at 11:30 am",
                    fontWeight: FontWeight.w500,
                    fontSize: 20.sp,
                    color: AppColors.black,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              children: [
                const Icon(Icons.watch_later),
                Expanded(
                  child: CustomText(
                    left: 10,
                    text: "45 min duration",
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                    color: AppColors.gray500,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              children: [
                const Icon(Icons.location_on),
                Expanded(
                  child: CustomText(
                    left: 10,
                    text: "Chev 36 St, London",
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                    color: AppColors.gray500,
                  ),
                ),
                SizedBox(
                  width: 10.h,
                ),
                GestureDetector(
                  onTap: () {
                    AppRouter.route
                        .pushNamed(RoutePath.mapViewScreen, extra: userRole);
                  },
                  child: Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.all(Radius.circular(10.r))),
                    child: CustomText(
                      left: 10,
                      text: "Live Location",
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      color: AppColors.white50,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            CustomText(
              text: "Selected services",
              fontWeight: FontWeight.w500,
              fontSize: 20.sp,
              color: AppColors.black,
            ),
            CustomText(
              top: 10,
              text: "Deep Massage - 45 Minutes",
              fontWeight: FontWeight.w500,
              fontSize: 18.sp,
              color: AppColors.black,
            ),
            CustomText(
              top: 10,
              text: "£ 50",
              fontWeight: FontWeight.w500,
              fontSize: 18.sp,
              color: AppColors.black,
            ),
            const Divider(),
            Row(
              children: [
                CustomText(
                  top: 10,
                  text: "Total: 54",
                  fontWeight: FontWeight.w500,
                  fontSize: 18.sp,
                  color: AppColors.black,
                  right: 10,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15.r)),
                        border: Border.all(color: AppColors.black)),
                    child: CustomText(
                      text: "Cancel Booking",
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.red,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(15.r)),
                      border: Border.all(color: AppColors.black)),
                  child: CustomText(
                    text: "Reschedule",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white50,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
