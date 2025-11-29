import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget timeSlotCard({
  required String startTime,
  required String endTime,
  required bool isSelected,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
    decoration: BoxDecoration(
      color: isSelected ? AppColors.secondary : Colors.transparent,
      borderRadius: BorderRadius.circular(12.r),
      border: Border.all(
        color: isSelected ? AppColors.searchScreenBg : AppColors.white,
        width: isSelected ? 2 : 1,
      ),
      boxShadow: isSelected
          ? [
              BoxShadow(
                color: AppColors.secondary.withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
                spreadRadius: 2,
              ),
            ]
          : [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Start Time
        CustomText(
          text: startTime,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: isSelected ? AppColors.white : AppColors.black,
        ),
   
        // Separator Icon
        Icon(
          Icons.arrow_downward,
          size: 16.sp,
          color: isSelected ? AppColors.white : AppColors.gray300,
        ),
      
        // End Time
        CustomText(
          text: endTime,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: isSelected ? AppColors.white : AppColors.black,
        ),
        SizedBox(height: 5.h),
        // Check Icon (only show when selected)
        if (isSelected)
          Container(
            padding: EdgeInsets.all(4.r),
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check,
              color: AppColors.secondary,
              size: 12.sp,
            ),
          ),
      ],
    ),
  );
}