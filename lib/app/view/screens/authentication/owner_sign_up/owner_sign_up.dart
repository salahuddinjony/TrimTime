import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/global/controller/auth_controller/auth_controller.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/view/common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_from_card/custom_from_card.dart';
import 'package:barber_time/app/view/common_widgets/custom_rich_text/custom_rich_text.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class OwnerSignUp extends StatelessWidget {
  OwnerSignUp({super.key});

  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarContent:AppStrings.personalInformation,
        appBarBgColor: AppColors.linearFirst,
        iconData: Icons.arrow_back,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: CurvedBannerClipper(),
              child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 1.3,
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 30.h,
                        ),
                        const CustomText(
                          text: AppStrings.signUp,
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          color: AppColors.black,
                        ),

                        const CustomText(
                          text: AppStrings.helloLetsJoin,
                          fontWeight: FontWeight.w300,
                          fontSize: 20,
                          color: AppColors.black,
                        ),

                        SizedBox(
                          height: 34.h,
                        ),
                        //ToDo ==========✅✅ fullName ✅✅==========
                        CustomFromCard(
                            hinText: AppStrings.enterYourName,
                            title: AppStrings.fullName,
                            controller: authController.fullNameController,
                            validator: (v) {}),
                        //ToDo ==========✅✅ Email✅✅==========
                        CustomFromCard(
                            hinText: AppStrings.enterYourEmail,
                            title: AppStrings.email,
                            controller: authController.emailController,
                            validator: (v) {}),
                        //ToDo ==========✅✅ password ✅✅==========
                        CustomFromCard(
                            hinText: AppStrings.enterYourPassword,
                            title: AppStrings.password,
                            controller: authController.passwordController,
                            validator: (v) {}),

                        //ToDo ==========✅✅ Confirm ✅✅==========
                        CustomFromCard(
                            hinText: AppStrings.confirmNewPassword,
                            title: AppStrings.confirmPassword,
                            controller:
                                authController.confirmPasswordController,
                            validator: (v) {}),
                      ],
                    ),
                  )),
            ),
            SingleChildScrollView(
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    children: [
                      CustomButton(
                        onTap: () {
                          context.pushNamed(
                            RoutePath.otpScreen,
                          );
                        },
                        title: AppStrings.signUp,
                        fillColor: Colors.black,
                        textColor: Colors.white,
                      ),
                      SizedBox(
                        height: 50.h,
                      ),

                      //ToDo ==========✅✅ alreadyHaveAnAccount✅✅==========
                      CustomRichText(
                          firstText: AppStrings.alreadyHaveAnAccount,
                          secondText: AppStrings.signIn,
                          onTapAction: () {
                            context.pushNamed(
                              RoutePath.signInScreen,
                            );
                          })
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
