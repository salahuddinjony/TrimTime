import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class ScheduleCard extends StatelessWidget {
  final String timeTitle;
  final String shopTitle;
  final String timeValue;
  final String shopName;

  const ScheduleCard({
    super.key,
    required this.timeTitle,
    required this.shopTitle,
    required this.timeValue,
    required this.shopName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: AppColors.brown50,
        borderRadius: BorderRadius.all(Radius.circular(5.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomText(
                text: timeTitle,
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
                color: AppColors.gray500,
                bottom: 9.h,
              ),
              const Spacer(),
              CustomText(
                text: shopTitle,
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
                color: AppColors.gray500,
                bottom: 9.h,
              ),
            ],
          ),
          Row(
            children: [
              CustomText(
                text: timeValue,
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
                color: AppColors.secondary,
              ),
              const Spacer(),
              CustomText(
                text: shopName,
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
                color: AppColors.secondary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
