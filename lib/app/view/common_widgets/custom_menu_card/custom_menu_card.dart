import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';

class CustomMenuCard extends StatelessWidget {
  final String text;
  final Widget icon;
  final VoidCallback? onTap;
  final bool isTextRed;
  final bool isArrow;

  const CustomMenuCard(
      {super.key,
      required this.text,
      required this.icon,
      this.onTap,
      this.isTextRed = false,
      this.isArrow = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Row(
              children: [
                icon,
                SizedBox(width: 16.w),
                CustomText(
                  text: text,
                  fontWeight: FontWeight.w300,
                  fontSize: 16.sp,
                  color: isTextRed ? AppColors.red : AppColors.primary,
                ),
                const Spacer(),
                if (isArrow) const SizedBox() else Assets.icons.chevronRight.image(),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 16.h,
        )
      ],
    );
  }
}
