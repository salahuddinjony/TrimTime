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
  final int? maxLine;

  const CustomFromCard({
    super.key,
    required this.title,
    required this.controller,
    required this.validator,
    this.isPassword = false,
    this.isRead = false,
    this.hinText,
    this.maxLine,
    this.isBgColor = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          color: AppColors.white50,
          text: title,
          fontWeight: FontWeight.w400,
          fontSize: 16,
          bottom: 8,
        ),
        CustomTextField(
          maxLines: isPassword ? 1 : (maxLine ?? 1),
          // Ensure single line for password
          hintStyle: const TextStyle(color: AppColors.gray300),
          readOnly: isRead,
          validator: validator,
          isPassword: isPassword,
          textEditingController: controller,
          hintText: hinText,
          inputTextStyle: const TextStyle(color: AppColors.whiteColor),
          fillColor: isBgColor == true ? AppColors.black : AppColors.white50,
          fieldBorderColor: AppColors.f32Color,
          keyboardType:
              isPassword ? TextInputType.visiblePassword : TextInputType.text,
        ),
        SizedBox(height: 12.h,)
      ],
    );
  }
}
