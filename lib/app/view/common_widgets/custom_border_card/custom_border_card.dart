import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
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
  final VoidCallback? isEditTap;
  final VoidCallback seeDescriptionTap;
  final Widget? logoImage;
  final bool? isButton;
  final bool? isEdit;
  final bool? isSeeDescription;
  final bool? isDelete;
  final VoidCallback? onTapDelete;
  final bool? isToggle;
  final bool? toggleValue;
  final ValueChanged<bool>? onToggleChanged;

  const CustomBorderCard({
    required this.title,
    required this.time,
    required this.price,
    required this.date,
    required this.buttonText,
    required this.onButtonTap,
    this.logoImage,
    super.key,
    this.isButton = false,
    required this.seeDescriptionTap,
    this.isSeeDescription = false,
    this.isEdit = false,
    this.isEditTap,
    this.isDelete = false,
    this.onTapDelete,
    this.isToggle = false,
    this.toggleValue,
    this.onToggleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DottedBorder(
          strokeWidth: 2,
          borderType: BorderType.RRect,
          color: Colors.black.withValues(alpha: .5),
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
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        date,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    if (isSeeDescription == true)
                      GestureDetector(
                        onTap: seeDescriptionTap,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          decoration: const BoxDecoration(
                              color: AppColors.black,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4))),
                          child: const CustomText(
                            textAlign: TextAlign.center,
                            text: "See Description",
                            fontWeight: FontWeight.w500,
                            fontSize: 8,
                            color: AppColors.white50,
                          ),
                        ),
                      ),
                    if (isSeeDescription == true) SizedBox(width: 6.w),
                    if (isButton == true)
                      GestureDetector(
                        onTap: onButtonTap,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: const BoxDecoration(
                              color: AppColors.secondary,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          child: CustomText(
                            textAlign: TextAlign.center,
                            text: buttonText,
                            fontWeight: FontWeight.w500,
                            fontSize: 8,
                            color: AppColors.white50,
                          ),
                        ),
                      ),
                    if (isEdit == true) ...[
                      SizedBox(width: 6.w),
                      GestureDetector(
                        onTap: isEditTap,
                        child: Assets.icons.edit
                            .svg(color: Colors.green, height: 15.h),
                      ),
                    ],
                    if (isToggle == true) ...[
                      SizedBox(width: 4.w),
                      Transform.scale(
                        scale: 0.7,
                        child: Switch.adaptive(
                          value: toggleValue ?? false,
                          onChanged: onToggleChanged,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                    if (isDelete == true) ...[
                      SizedBox(width: 6.w),
                      GestureDetector(
                        onTap: onTapDelete,
                        child: Assets.icons.delete.svg(),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 12.h,
        )
      ],
    );
  }
}
