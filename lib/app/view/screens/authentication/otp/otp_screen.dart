import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/global/controller/auth_controller/auth_controller.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreen extends StatelessWidget {
  OtpScreen({super.key});

  final AuthController authController = Get.find<AuthController>();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Ensure the correct type is received
    final bool isForget = (GoRouterState.of(context).extra as bool?) ?? false;

    return Scaffold(
      backgroundColor: AppColors.normalHover,

      ///: <<<<<<====== AppBar ======>>>>>>>>
      appBar: CustomAppBar(
        appBarBgColor: AppColors.normalHover,
        appBarContent: AppStrings.verifyCode,
        iconData: Icons.arrow_back,
        onTap: () {
          context.pop(); // Navigate back
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ///: <<<<<<====== Header ======>>>>>>>>
                const CustomText(
                  text: AppStrings.checkYourEmail,
                  fontWeight: FontWeight.w500,
                  fontSize: 22,
                  color: AppColors.white50,
                ),

                const CustomText(
                  textAlign: TextAlign.center,
                  top: 15,
                  maxLines: 5,
                  text: AppStrings.weHaveSentYouANAu,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: AppColors.white50,
                ),
                SizedBox(height: 60.h),

                ///: <<<<<<====== OTP Pin Code Field ======>>>>>>>>
                PinCodeTextField(
                  textStyle: const TextStyle(color: AppColors.black, fontSize: 24),
                  keyboardType: TextInputType.number,
                  autoDisposeControllers: false,
                  cursorColor: AppColors.black,
                  appContext: context,
                  controller: authController.pinCodeController,
                  onCompleted: (value) {},
                  validator: (value) {
                    if (value == null || value.length != 4) {
                      return "Please enter a 4-digit OTP code";
                    }
                    return null;
                  },
                  autoFocus: true,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.underline,
                    fieldHeight: 49.h,
                    fieldWidth: 40,
                    borderWidth: 1.5,
                    activeColor: Colors.white,
                    inactiveColor: Colors.white,
                    selectedColor: Colors.black, // Black underline for the selected field
                  ),
                  length: 4,
                  enableActiveFill: false, // Disable fill for better appearance
                  onChanged: (value) {},
                ),
                SizedBox(height: 100.h),

                ///: <<<<<<====== Verify Code Button ======>>>>>>>>
                CustomButton(
                  isRadius: false,
                  width: MediaQuery.of(context).size.width,
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      isForget
                          ? context.push(RoutePath.resetPasswordScreen)
                          : context.push(RoutePath.signInScreen);
                    }
                  },
                  title: AppStrings.verifyCode,
                  fillColor: AppColors.white50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
