

import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final Widget icon;
  final Color color;
  final double elevation;
  final VoidCallback? onTap;

  const CustomCard({
    super.key,
    required this.title,
    required this.icon,
    this.color = AppColors.primary, // default color from AppColors
    this.elevation = 5.0,  this.onTap, // elevation default
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 100.w,

        child: Card(

          color: color, // You may now pass custom color
          elevation: elevation, // Elevation can be customized
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r), // Optional: make the corners rounded
          ),
          child: Padding(
            padding:  EdgeInsets.all(16.r),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min, // Ensures the column only takes necessary space
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  icon,
                  SizedBox(height: 12.h),
                  CustomText(
                    text: title,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.black, // Assuming AppColors black500 works for the text color
                    overflow: TextOverflow.ellipsis, // If the text is too long, use ellipsis
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
