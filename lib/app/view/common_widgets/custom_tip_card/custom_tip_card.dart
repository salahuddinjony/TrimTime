import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';

class CustomTipCard extends StatelessWidget {
  const CustomTipCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.onSendTip,
  });

  final String imageUrl;
  final String name;
  final VoidCallback onSendTip;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Profile Image
        CustomNetworkImage(
          imageUrl: imageUrl,
          height: 58,
          width: 58,
          boxShape: BoxShape.circle,
        ),

        SizedBox(height: 5.h),

        /// Barber Name
        CustomText(
          text: name,
          fontSize: 11.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.gray500,
        ),

        SizedBox(height: 5.h),

        /// Send Tips Button
        GestureDetector(
          onTap: onSendTip,
          child: Container(
            padding: EdgeInsets.all(5.r),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(5.r),
            ),
            child: CustomText(
              text: "Send Tips",
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.last,
            ),
          ),
        ),
      ],
    );
  }
}
