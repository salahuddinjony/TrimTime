import 'package:barber_time/app/global/controller/auth_controller/auth_controller.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../common_widgets/custom_rich_text/custom_rich_text.dart';

UserRole getRoleFromString(String role) {
  switch (role.toLowerCase()) {
    case 'owner':
      return UserRole.owner;
    case 'barber':
      return UserRole.barber;
    case 'user':
    default:
      return UserRole.user;
  }
}

class OtpScreen extends StatelessWidget {
  final String isOwner;
  final String email;
  final bool? isForgotPassword;
  OtpScreen({super.key, required this.isOwner, required this.email, this.isForgotPassword});

  final AuthController authController = Get.find<AuthController>();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Ensure the correct type is received
    final Map<String, dynamic> extraData =
        GoRouter.of(context).state.extra as Map<String, dynamic>? ?? {};

    debugPrint("Email received in OTP Screen: $email");
    debugPrint("isForgotPassword received in OTP Screen: $isForgotPassword");
    debugPrint("isOwner received in OTP Screen: $isOwner");
    
    final bool isForget = extraData['isForget'] ?? false;
    final UserRole userRole =
        getRoleFromString(extraData['userRole'] ?? 'user');

    debugPrint(
        "Forget Password Screen: isForget = $isForget, userRole = ${userRole.name}");

    debugPrint("Selected Role============================${userRole.name}");
    return Scaffold(
        // backgroundColor: AppColors.normalHover,

        ///: <<<<<<====== AppBar ======>>>>>>>>
        appBar: CustomAppBar(
          appBarBgColor: AppColors.first,
          appBarContent: AppStrings.verifyCode,
          iconData: Icons.arrow_back,
          onTap: () {
            context.pop(); // Navigate back
          },
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.first, // First color (with opacity)
                      AppColors.last
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ///: <<<<<<====== Header ======>>>>>>>>
                          SizedBox(
                            height: 30.h,
                          ),
                          CustomText(
                            text: AppStrings.checkYourEmail,
                            fontWeight: FontWeight.w500,
                            fontSize: 22.sp,
                            color: AppColors.gray500,
                          ),
                          SizedBox(height: 8.h),
                          Text("A verification code has been sent to $email", 
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),

                          CustomText(
                            textAlign: TextAlign.center,
                            top: 15.h,
                            maxLines: 5,
                            text: AppStrings.weHaveSentYouANAu,
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                            color: AppColors.gray500,
                          ),
                          SizedBox(height: 60.h),

                          ///: <<<<<<====== OTP Pin Code Field ======>>>>>>>>
                          PinCodeTextField(
                            textStyle: TextStyle(
                                color: AppColors.black, fontSize: 24.sp),
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
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(12.r),
                              fieldHeight: 49.h,
                              fieldWidth: 40.w,
                              borderWidth: 1.5,
                              activeColor: AppColors.black,
                              inactiveColor: AppColors.gray300,
                              selectedColor: AppColors.black,
                              activeFillColor: AppColors.first,
                              inactiveFillColor: AppColors.first,
                              selectedFillColor: AppColors.first,
                            ),
                            length: 4,
                            enableActiveFill: true,
                            // ✅ এটা true করতে হবে
                            onChanged: (value) {},
                          ),
                          SizedBox(height: 20.h),
                          CustomRichText(
                            firstText: AppStrings.didNotGetACode,
                            secondText: AppStrings.resendCode,
                            onTapAction: () {},
                          ),
                          SizedBox(height: 20.h),

                          ///: <<<<<<====== Verify Code Button ======>>>>>>>>
                          CustomButton(
                            isRadius: false,
                            width: MediaQuery.of(context).size.width,
                            onTap: () {
                              authController.pinCodeController.text = authController.pinCodeController.text.trim();
                              debugPrint("OTP Entered: ${authController.pinCodeController.text}");

                              authController.userAccountActiveOtp(
                                isOwner: isOwner == 'true',
                                isForgotPassword: isForgotPassword ?? false, 
                              );

                              // if (formKey.currentState!.validate()) {
                              //   isForget
                              //       ? AppRouter.route.goNamed(RoutePath.resetPasswordScreen,
                              //       extra: userRole)
                              //       : AppRouter.route.goNamed(RoutePath.signInScreen,
                              //       extra: userRole);
                              // }
                            },
                            title: AppStrings.verifyCode,
                            fillColor: AppColors.black,
                            textColor: AppColors.white50,
                          ),
                          SizedBox(height: 40.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
