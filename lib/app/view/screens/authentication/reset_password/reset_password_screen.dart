import 'package:barber_time/app/global/controller/auth_controller/auth_controller.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_from_card/custom_from_card.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String email;
  final UserRole userRole;

  ResetPasswordScreen({super.key, required this.email, required this.userRole});

  final AuthController authController = Get.find<AuthController>();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    debugPrint("Email received in Reset Password Screen: $email");
    final extra = GoRouter.of(context).state.extra;
    if (extra is UserRole) {
    } else if (extra is Map) {
      try {
      } catch (_) {
      }
    }
    debugPrint("Selected Role============================${userRole.name}");
    return Scaffold(
      backgroundColor: AppColors.linearFirst,

      ///: <<<<<<======🗄️🗄️🗄️🗄️🗄️🗄️💡💡VerifyCode Appbar💡💡🗄️🗄️🗄️🗄️🗄️🗄️🗄️>>>>>>>>===========
      appBar: const CustomAppBar(
        appBarBgColor: AppColors.first,
        appBarContent: AppStrings.resetPassword,
        iconData: Icons.arrow_back,
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
                    Color(0xCCEEC0A6), // First color (with opacity)
                    Color(0xFFEA8D58),
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
                        ///: <<<<<<======🗄️🗄️🗄️🗄️🗄️🗄️💡💡Header💡💡🗄️🗄️🗄️🗄️🗄️🗄️🗄️>>>>>>>>===========

                        SizedBox(
                          height: 80.h,
                        ),

                        ///: <<<<<<======🗄️🗄️🗄️🗄️🗄️🗄️💡💡Password Fields💡💡🗄️🗄️🗄️🗄️🗄️🗄️🗄️>>>>>>>>===========
                        CustomFromCard(
                            isPassword: true,
                            hinText: AppStrings.enterNewPassword,
                            title: AppStrings.enterYourNewPassword,
                            controller: authController.passwordController,
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Please enter a new password';
                              }
                              if (v.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            }),
                        CustomFromCard(
                            isPassword: true,
                            hinText: AppStrings.confirmNewPassword,
                            title: AppStrings.confirmNewPassword,
                            controller: authController.confirmPasswordController,
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (v != authController.passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            }),
                        SizedBox(
                          height: 100.h,
                        ),

                        ///: <<<<<<======🗄️🗄️🗄️🗄️🗄️🗄️💡💡Reset Button💡💡🗄️🗄️🗄️🗄️🗄️🗄️🗄️>>>>>>>>===========

                        CustomButton(
                          isRadius: false,
                          width: MediaQuery.of(context).size.width,
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              authController.resetPassword(email: email);
                            }
                          },
                          title: AppStrings.resetPassword,
                          fillColor: AppColors.black,
                          textColor: AppColors.white50,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
