import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';

class CustomMessageCard extends StatelessWidget {
  final String senderName;
  final String message;
  final String imageUrl;
  final int maxLines;
  final VoidCallback? onTap;

  const CustomMessageCard({
    super.key,
    required this.senderName,
    required this.message,
    required this.imageUrl,
    this.maxLines = 2, // Default max lines for message preview
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Profile Image
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary),
                borderRadius: const BorderRadius.all(Radius.circular(25))
              ),
              child: CustomNetworkImage(
                boxShape: BoxShape.circle,
                imageUrl: imageUrl,
                height: 48.h,
                width: 49.w,
              ),
            ),
            SizedBox(width: 12.w),

            // ✅ Message Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: senderName,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.white50,
                  ),
                  SizedBox(height: 4.h),
                  CustomText(
                    textAlign: TextAlign.start,
                    maxLines: maxLines,
                    text: message,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w300,
                    color: AppColors.whiteDark,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
