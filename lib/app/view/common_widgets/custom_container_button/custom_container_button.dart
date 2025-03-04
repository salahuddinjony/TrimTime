import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';

class CustomContainerButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Widget icon;
  final Color backgroundColor;
  final bool? isArrow;

  // Constructor to allow customization of the button
  const CustomContainerButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.icon,
    this.backgroundColor = Colors.black,
    this.isArrow, // Default background color is black
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            isArrow == false
                ? SizedBox(width: 60.w)
                : SizedBox(
                    width: 20.w,
                  ),
            icon,
            SizedBox(
              width: 20.w,
            ),
            CustomText(
              text: text,
              fontWeight: FontWeight.w500,
              fontSize: 18.sp,
              color: AppColors.whiteColor,
            ),
            const Spacer(),
            isArrow == true
                ? const Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.whiteColor,
                  )
                : SizedBox(width: 5.w),
            SizedBox(width: 5.w),
          ],
        ),
      ),
    );
  }
}
