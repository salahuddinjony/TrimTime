import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget barberTile(
    {required String name,
    required String imagePath,
    required bool isSelected,
    required VoidCallback onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 90.w,
      margin: EdgeInsets.only(right: 10.w),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.secondary : Colors.transparent,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isSelected ? AppColors.searchScreenBg : Colors.grey,
          width: 2,
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
            : null,
      ),
      child: Column(
        children: [
          CustomNetworkImage(
            imageUrl: imagePath,
            height: 50,
            width: 50,
            boxShape: BoxShape.circle,
          ),
          SizedBox(height: 8.h),
          Text(
            name,
            style: TextStyle(fontSize: 14.sp, color: AppColors.white),
          ),
          if (isSelected)
            const Icon(
              Icons.check_circle,
              color: Colors.white,
            ),
        ],
      ),
    ),
  );
}
