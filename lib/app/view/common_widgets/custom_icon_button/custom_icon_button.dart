import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/app_colors.dart';
import '../custom_text/custom_text.dart';

class CustomIconButton extends StatelessWidget {
  final String text;
  final String iconPath;
  final double iconLeftPadding;

  const CustomIconButton({
    super.key,
    required this.text,
    required this.iconPath,
    this.iconLeftPadding = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Image.asset(iconPath),
          SizedBox(width: iconLeftPadding),
          CustomText(
            text: text,
            fontWeight: FontWeight.w500,
            fontSize: 16.sp,
            color: AppColors.black,
          ),
        ],
      ),
    );
  }
}
