import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:barber_time/app/view/common_widgets/custom_text_field/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomFromCard extends StatelessWidget {
  final String title;
  final String? hinText;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final bool isPassword;
  final bool isRead;
  final bool? isBgColor;
  final bool? isBorderColor;
  final int? maxLine;
  final Widget? suffixIcon;

  const CustomFromCard({
    super.key,
    required this.title,
    required this.controller,
    required this.validator,
    this.isPassword = false,
    this.isRead = false,
    this.hinText,
    this.maxLine,
    this.isBgColor = false, this.isBorderColor = false, this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          color: AppColors.black,
          text: title,
          fontWeight: FontWeight.w400,
          fontSize: 16,
          bottom: 8,
        ),
        CustomTextField(
          suffixIcon: suffixIcon,
          maxLines: isPassword ? 1 : (maxLine ?? 1),
          // Ensure single line for password
          hintStyle: const TextStyle(color: AppColors.gray300),
          readOnly: isRead,
          validator: validator,
          isPassword: isPassword,
          textEditingController: controller,
          hintText: hinText,
          inputTextStyle: const TextStyle(color: AppColors.black),
          fillColor: isBgColor == true ? AppColors.linearFirst : AppColors
              .white50,
          fieldBorderColor: isBorderColor == true
              ? AppColors.black
              : AppColors.f32Color,
          keyboardType:
          isPassword ? TextInputType.visiblePassword : TextInputType.text,
        ),
        SizedBox(height: 12.h,)
      ],
    );
  }
}
