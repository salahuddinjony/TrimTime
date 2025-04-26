import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/global/controller/auth_controller/auth_controller.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/curved_short_clipper/curved_short_clipper.dart';
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
    final Map<String, dynamic> extraData = GoRouterState.of(context).extra as Map<String, dynamic>? ?? {};
    final bool isForget = extraData['isForget'] ?? false;
    final UserRole userRole = getRoleFromString(extraData['userRole'] ?? 'user');

    debugPrint("Forget Password Screen: isForget = $isForget, userRole = ${userRole.name}");

    debugPrint("Selected Role============================${userRole.name}");
    return Scaffold(
      // backgroundColor: AppColors.normalHover,

      ///: <<<<<<====== AppBar ======>>>>>>>>
      appBar: CustomAppBar(
        appBarBgColor: AppColors.linearFirst,
        appBarContent: AppStrings.verifyCode,
        iconData: Icons.arrow_back,
        onTap: () {
          context.pop(); // Navigate back
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: CurvedShortClipper(),
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height/2,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xCCEDC4AC), // First color (with opacity)
                      Color(0xFFE9864E),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),

                child:  Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 16.w),
                  child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ///: <<<<<<====== Header ======>>>>>>>>
                           CustomText(
                            text: AppStrings.checkYourEmail,
                            fontWeight: FontWeight.w500,
                            fontSize: 22.sp,
                            color: AppColors.black,
                          ),

                           CustomText(
                            textAlign: TextAlign.center,
                            top: 15.h,
                            maxLines: 5,
                            text: AppStrings.weHaveSentYouANAu,
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                            color: AppColors.black,
                          ),
                          SizedBox(height: 60.h),

                          ///: <<<<<<====== OTP Pin Code Field ======>>>>>>>>
                          PinCodeTextField(
                            textStyle:  TextStyle(color: AppColors.black, fontSize: 24.sp),
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
                              fieldWidth: 40.w,
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


                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            ///: <<<<<<====== Verify Code Button ======>>>>>>>>
            CustomButton(
              isRadius: false,
              width: MediaQuery.of(context).size.width,
              onTap: () {
                if (formKey.currentState!.validate()) {
                  isForget
                      ?  AppRouter.route.goNamed(RoutePath.resetPasswordScreen,
                      extra: userRole)
                      :  AppRouter.route.goNamed(RoutePath.signInScreen,
                      extra: userRole);
                }
              },
              title: AppStrings.verifyCode,
              fillColor: AppColors.black,
              textColor: AppColors.white50,
            ),
          ],
        ),
      )


    );
  }
}
