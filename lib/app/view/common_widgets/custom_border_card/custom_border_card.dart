import 'package:barber_time/app/core/bottom_navbar.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBorderCard extends StatelessWidget {
  final String title;
  final String time;
  final String price;
  final String date;
  final String buttonText;
  final VoidCallback onButtonTap;
  final Widget? logoImage;
  final bool? isButton;

  const CustomBorderCard({
    required this.title,
    required this.time,
    required this.price,
    required this.date,
    required this.buttonText,
    required this.onButtonTap,
    this.logoImage,
    super.key, this.isButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DottedBorder(
          borderType: BorderType.RRect,
          color: Colors.black.withOpacity(0.5),
          radius: const Radius.circular(12),
          padding: const EdgeInsets.all(6),
          child: Container(
            padding: const EdgeInsets.all(12),
            width: double.infinity,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    logoImage ?? const SizedBox(),
                  ],
                ),

                Text(
                  time,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  price,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      date,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    isButton == true?
                    Expanded(
                      child: CustomButton(
                        textColor: AppColors.white50,
                        fillColor:AppColors.bottomColor ,
                        onTap: onButtonTap,
                        title: buttonText,
                      ),
                    ):const SizedBox()
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 12.h,)
      ],
    );
  }
}
