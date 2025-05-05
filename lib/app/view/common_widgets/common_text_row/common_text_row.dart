
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../custom_text/custom_text.dart';

class CommonTextRow extends StatelessWidget {
  final String keyText;
  final String valueText;

  const CommonTextRow({
    super.key,
    required this.keyText,
    required this.valueText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomText(
          text: "$keyText",
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.white,
          bottom: 10.h,
        ),
        CustomText(
          text: valueText,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.white,
          bottom: 10.h,
        ),
      ],
    );
  } }