import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../custom_network_image/custom_network_image.dart';

class CustomBookingCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String dateTime;
  final String location;
  final String price;
  final VoidCallback onTap;

  const CustomBookingCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.dateTime,
    required this.location,
    required this.price, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: EdgeInsets.all(10.w),
        child: Row(
          children: [
            // Image
            CustomNetworkImage(
              imageUrl: imageUrl,
              borderRadius: BorderRadius.circular(10.r),
              height: 83.h,
              width: 115.w,
            ),
            SizedBox(width: 10.w),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: title,
                    fontSize: 13.sp,
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 4.h),
                  CustomText(
                    text: dateTime,
                    fontSize: 12.sp,
                    color: AppColors.gray300,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: AppColors.gray300,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: CustomText(
                          text: location,
                          fontSize: 12.sp,
                          color: AppColors.gray300,
                          fontWeight: FontWeight.w500,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Price
            CustomText(
              text: price,
              fontSize: 14.sp,
              color: AppColors.black,
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
      ),
    );
  }
}
