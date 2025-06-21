import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/app_colors.dart';
import '../custom_text/custom_text.dart';

class CustomIconButton extends StatelessWidget {
  final String text;
  final String iconPath;
  final double iconLeftPadding;
  final VoidCallback onTap;
  final Color isBgColor;
  final Color textColor;
  final Color iconColor;

  const CustomIconButton({
    super.key,
    required this.text,
    required this.iconPath,
    this.iconLeftPadding = 10, required this.onTap, required this.isBgColor, required this.textColor, required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(15.r),
        decoration: BoxDecoration(
          color: isBgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(iconPath,color: iconColor,),
            SizedBox(width: iconLeftPadding),
            CustomText(
              text: text,
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
              color: textColor,
            ),
          ],
        ),
      ),
    );
  }
}
